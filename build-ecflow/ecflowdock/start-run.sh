docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix   -i -t myggen/ecflow5-bionic:0.1 /bin/bash
#docker run --net=host --env="DISPLAY"  -i -t myggen/ecflow5-bionic:0.1 /bin/bash
#docker run --env="DISPLAY"  -i -t myggen/ecflow5-bionic:0.1 /bin/bash
