#!/bin/bash
#exec 1>log.out 2>&1
set -x   # Display the command and its expanded arguments
set -u   # Treat unset variables and parameters as an error
set -e   # Exit immediately if a command exits with a non-zero status


BASE_DIR=/tmp/ecflow-building.$(whoami)

#CMAKE_VERSION="3.16.4"  # https://cmake.org/download/
CMAKE_VERSION="3.24.2"  # https://cmake.org/download/

#BOOST_VERSION=1.72.0    # https://www.boost.org/users/download/
BOOST_VERSION=1.79.0    # https://www.boost.org/users/download/

if [ -z ${ECFLOW_VERSION:-} ]
then
    ECFLOW_VERSION=5.8.4    # https://confluence.ecmwf.int/display/ECFLOW/Releases
    #ECFLOW_VERSION=5.2.3
fi

if [ -z ${ECFLOW_INSTALL_DIR:-} ]
then
    ECFLOW_INSTALL_DIR=/opt/ecflow-$ECFLOW_VERSION
fi


echo "ECFLOW_VERSION=$ECFLOW_VERSION"
echo "ECFLOW_INSTALL_DIR=$ECFLOW_INSTALL_DIR"

OpenSSL=0


mkdir -p $ECFLOW_INSTALL_DIR

CMAKE_DIR="cmake-${CMAKE_VERSION}"
CMAKE_FILE="${CMAKE_DIR}.tar.gz"
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_FILE}"


BOOST_UNDERSCORE_VERSION=`echo $BOOST_VERSION | tr '.' '_'`
BOOST_DIR="boost_${BOOST_UNDERSCORE_VERSION}"
BOOST_FILE=$BOOST_DIR.tar.gz
#BOOST_SRC_URL=https://boostorg.jfrog.io/artifactory/main/release/$BOOST_VERSION/source/$BOOST_FILE
#BOOST_SRC_URL=https://sourceforge.net/projects/boost/files/boost/$BOOST_VERSION/boost_$BOOST_VERSION.tar.gz/download
BOOST_SRC_URL=https://sourceforge.net/projects/boost/files/boost/1.79.0/boost_1_79_0.tar.gz/download
ECFLOW_RELATIVE_DIR="ecFlow-${ECFLOW_VERSION}-Source"
ECFLOW_FILE=$ECFLOW_RELATIVE_DIR.tar.gz
ECFLOW_SRC_URL=https://confluence.ecmwf.int/download/attachments/8650755/$ECFLOW_FILE?api=v2


DISTRIBUTOR=`lsb_release -si` || exit # eg Ubuntu or CentOS
RELEASE=`lsb_release -sr`     || exit # eg 22.04 or 7.6.1810
if [ "$DISTRIBUTOR" == "Ubuntu" -a "$RELEASE" == "22.04" ] ; then
    DISTRIBUTION="Ubuntu 22.04"
# sudo apt install -y qt5-default libqt5svg5-dev libqt5charts5-dev python3-dev
    # sudo apt -y install gcc
elif [ "$DISTRIBUTOR" == "CentOS" -a "7" '<' "$RELEASE" -a "$RELEASE" '<' "8" ] ; then
        DISTRIBUTION="CentOS 7"
        if [[ -d /modules/centos7/user-apps/python/python-3.7.3 ]]
        then
            module load Python/3.7.3
        fi
       
else
    printf "ERROR: Unknown distributor/release '%s'/'%s'. Exiting.\n" $DISTRIBUTOR $RELEASE
    exit 1
fi


SRC_DIR=$BASE_DIR/src                && mkdir -vp $SRC_DIR
UNTAR_DIR=$BASE_DIR/untar            && mkdir -vp $UNTAR_DIR
BUILD_DIR=$BASE_DIR/build            && mkdir -vp $BUILD_DIR
INSTALL_DIR=$BASE_DIR/install        && mkdir -vp $INSTALL_DIR
DOWNLOAD_DIR=$BASE_DIR/download      && mkdir -vp $DOWNLOAD_DIR


CORES=`cat /proc/cpuinfo  |grep processor |cut -d: -f1 |wc -l`


if [ ! -f $SRC_DIR/$CMAKE_FILE ] ; then
    curl -L $CMAKE_URL -o $DOWNLOAD_DIR/$CMAKE_FILE \
    && mv $DOWNLOAD_DIR/$CMAKE_FILE $SRC_DIR
fi
if [ ! -d $BUILD_DIR/$CMAKE_DIR ] ; then
    cd $UNTAR_DIR \
    && tar xzf $SRC_DIR/$CMAKE_FILE \
    && mv $UNTAR_DIR/$CMAKE_DIR $BUILD_DIR
fi
if [ ! -d $INSTALL_DIR/cmake ] ; then
    if [ "$DISTRIBUTION" == "Ubuntu 22.04" ] ; then
        cd $BUILD_DIR/$CMAKE_DIR \
        && ./bootstrap --prefix=$INSTALL_DIR/cmake \
        && make -j$CORES \
        && make install
    elif [ "$DISTRIBUTION" == "CentOS 7" ] ; then
        cd $BUILD_DIR/$CMAKE_DIR \
        && scl enable devtoolset-8 "./bootstrap --prefix=$INSTALL_DIR/cmake" \
        && scl enable devtoolset-8 "make -j$CORES" \
        && scl enable devtoolset-8 "make install"
    fi
fi

export PATH="$PATH:$INSTALL_DIR/cmake/bin"
export CMAKE_ROOT="$INSTALL_DIR/cmake"


if [ ! -f $SRC_DIR/$BOOST_FILE ] ; then
    curl -L $BOOST_SRC_URL -o $DOWNLOAD_DIR/$BOOST_FILE \
    && mv $DOWNLOAD_DIR/$BOOST_FILE $SRC_DIR
fi
if [ ! -d $BUILD_DIR/$BOOST_DIR ] ; then
    cd $UNTAR_DIR \
    && tar xzf $SRC_DIR/$BOOST_FILE \
    && mv $UNTAR_DIR/$BOOST_DIR $BUILD_DIR
fi


if [ ! -f $SRC_DIR/$ECFLOW_FILE ] ; then
    curl -L $ECFLOW_SRC_URL -o $DOWNLOAD_DIR/$ECFLOW_FILE \
    && mv $DOWNLOAD_DIR/$ECFLOW_FILE $SRC_DIR
fi
if [ ! -d $BUILD_DIR/$ECFLOW_RELATIVE_DIR ] ; then
    cd $UNTAR_DIR \
    && tar xzf $SRC_DIR/$ECFLOW_FILE \
    && mv $UNTAR_DIR/$ECFLOW_RELATIVE_DIR $BUILD_DIR
fi


export BOOST_ROOT=$BUILD_DIR/$BOOST_DIR
if [ "$DISTRIBUTION" == "Ubuntu 22.04" ] ; then
    cd $BOOST_ROOT &&  ./bootstrap.sh
elif [ "$DISTRIBUTION" == "CentOS 7" ] ; then
    cd $BOOST_ROOT &&  scl enable devtoolset-8 ./bootstrap.sh
fi


export WK=$BUILD_DIR/$ECFLOW_RELATIVE_DIR
export PATH="$PATH:$BOOST_ROOT/tools/build/src/engine/"  #  Make bjam accessible from $PATH


if [ "$DISTRIBUTION" == "Ubuntu 22.04" ] ; then
    cd $BOOST_ROOT &&  time $WK/build_scripts/boost_build.sh  
elif [ "$DISTRIBUTION" == "CentOS 7" ] ; then
    cd $BOOST_ROOT &&  scl enable devtoolset-8 "time $WK/build_scripts/boost_build.sh"
fi


cd $WK
mkdir -p build; cd build


if [ "$DISTRIBUTION" == "Ubuntu 22.04" ] ; then
    cmake -DCMAKE_INSTALL_PREFIX=$ECFLOW_INSTALL_DIR -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS=-w -DENABLE_SERVER=on -DENABLE_PYTHON=on -DENABLE_UI=on -DENABLE_GUI=off \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DBOOST_ROOT=$BOOST_ROOT \
    .. \
    && make -j$CORES \
    && make test \
    && make install
elif [ "$DISTRIBUTION" == "CentOS 7" ] ; then
    scl enable devtoolset-8 "cmake -DCMAKE_INSTALL_PREFIX=$ECFLOW_INSTALL_DIR -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS=-w -DENABLE_SERVER=on -DENABLE_PYTHON=on -DENABLE_UI=off -DENABLE_GUI=off \
    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
    -DBOOST_ROOT=$BOOST_ROOT \
    .." \
    && scl enable devtoolset-8 "make -j$CORES" \
    && scl enable devtoolset-8 "make test" \
    && scl enable devtoolset-8 "make install"
fi

exit

