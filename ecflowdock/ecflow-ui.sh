docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -d --rm -v /etc/passwd:/etc/passwd -v $HOME:$HOME  -u `id -u`:`id -g` myggen/ecflow5-bionic:0.1 /opt/ecflow-5.2.3/bin/ecflow_ui

#BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P) cd -- "$BASEDIR"
#cd -- "$BASEDIR"

#docker run \
#       --privileged \
#       --rm \
#       --tty \
#       --interactive \
#       --net=host \
#       --user $UID \
#       -e DISPLAY \
#       -v $HOME/.ecflowrc:/$HOME/.ecflowrc \
#       -v $HOME/.ecflow_ui_v5:/$HOME/.ecflow_ui_v5 \
#       myggen/ecflow5-bionic:0.1 \
#       /opt/ecflow-5.2.3/bin/ecflow_ui

