docker rm -f volans
docker build  -t volans . 
# docker run -dit --net=host -v  $(pwd):/home  --name volans volans

docker run -dit --privileged  --ipc=host --net=host -v  $(pwd):/home  --group-add video \
--volume=/tmp/.X11-unix:/tmp/.X11-unix  --env="DISPLAY=$DISPLAY" \
--env="QT_X11_NO_MITSHM=1"  --device=/dev/dri:/dev/dri \
--name volans volans