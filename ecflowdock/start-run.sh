docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -ti -v /etc/passwd:/etc/passwd -v $HOME:$HOME  -u `id -u`:`id -g` myggen/ecflow5-jammy:0.1 /bin/bash
