#docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -ti -v /etc/passwd:/etc/passwd -v $HOME:$HOME  -u `id -u`:`id -g` myggen/ecflow5-bionic:0.1 /bin/bash
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -ti -v /etc/passwd:/etc/passwd -v $HOME:$HOME  -u `id -u`:`id -g` myggen/ecflow5-bionic:firsttry /bin/bash
#docker run --net=host --env="DISPLAY"  -i -t myggen/ecflow5-bionic:0.1 /bin/bash
#docker run --env="DISPLAY"  -i -t myggen/ecflow5-bionic:0.1 /bin/bash
