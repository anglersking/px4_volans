FROM ubuntu:18.04
RUN apt update
RUN apt -y upgrade
RUN apt-get install -y sudo
# RUN sudo apt-get install -y gnupg
RUN sudo apt-get install -y lsb-release gnupg libssl-dev wget locate libssl-dev
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN sudo apt-get update && apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get install -y python3 python3-pip

RUN apt-get install -y ros-melodic-desktop

# RUN sudo apt-get install -y ros-melodic-desktop

# Source ROS
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# ARG DEBIAN_FRONTEND=noninteractive
# ENV TZ=Europe/Moscow
# # RUN sudo apt-get install -y --no-install-recommends ros-melodic-desktop
# RUN sudo apt-get install -y --no-install-recommends ros-melodic-desktop-full
RUN sudo apt install -y ros-melodic-gazebo9* libgazebo9-dev

# # Source ROS
# RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc && \
#     /bin/bash -c "source /root/.bashrc"


# RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# RUN sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

RUN apt install python-rosdep
RUN rosdep init
RUN rosdep update
RUN sudo apt-get install -y ros-melodic-catkin python-catkin-tools
RUN sudo apt install -y ros-melodic-mavros ros-melodic-mavros-extras

RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
RUN chmod +x install_geographiclib_datasets.sh
RUN sudo ./install_geographiclib_datasets.sh
RUN wget https://raw.githubusercontent.com/PX4/Firmware/master/Tools/setup/ubuntu.sh
RUN wget https://raw.githubusercontent.com/PX4/Firmware/master/Tools/setup/requirements.txt
COPY ./requirements.txt /

# RUN wget https://raw.githubusercontent.com/PX4/PX4-Autopilot/main/Tools/setup/ubuntu.sh
# RUN wget https://raw.githubusercontent.com/PX4/PX4-Autopilot/main/Tools/setup/requirements.txt
RUN apt install git 
# RUN git clone https://github.com/PX4/PX4-Autopilot.git --recursive
# RUN ./ubuntu.sh --no-nuttx
# RUN source ubuntu.sh

RUN /bin/bash -c ". ubuntu.sh --no-nuttx"
RUN git clone https://gitee.com/bingobinlw/volans
RUN cd volans && git clone https://github.com/PX4/Firmware 
RUN sudo apt-get install -y protobuf-compiler libeigen3-dev libopencv-dev 
RUN sudo apt-get install -y python-jinja2 

RUN apt-get install -y python-pip
RUN  pip install numpy toml
RUN cd volans && cd Firmware\
&& git submodule update --init --recursive


RUN cd volans && cd Firmware &&\
  git checkout v1.10.1 && make distclean
COPY ./gazebo_opticalflow_plugin.h /volans/Firmware/Tools/sitl_gazebo/include/gazebo_opticalflow_plugin.h

RUN  sudo apt install -y libgstreamer1.0-dev gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly

RUN sudo apt-get remove -y gazebo*
RUN sudo apt-get remove -y libgazebo*

RUN sudo apt-get remove -y ros-melodic-gazebo*

RUN sudo apt install -y ros-melodic-gazebo9* libgazebo9-dev
RUN  sudo apt upgrade -y libignition-math2
# RUN ./Tools/setup/ubuntu.sh

RUN cd volans && cd Firmware &&\
 make distclean && git submodule update --init --recursive
COPY ./gazebo_opticalflow_plugin.h /volans/Firmware/Tools/sitl_gazebo/include/gazebo_opticalflow_plugin.h
# RUN cd volans && cd Firmware &&\
#   make px4_sitl_default gazebo -j100

# RUN  ./PX4-Autopilot/Tools/setup/ubuntu.sh

