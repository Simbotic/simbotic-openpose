# Simbotic OpenPose

This is a Docker container running openpose.

OpenPose represents the first real-time multi-person system to jointly detect human body, hand, facial, and foot keypoints (in total 135 keypoints) on single images.

# Prerequisites

- Docker CE 18.x
- docker-compose 1.23.x
- Nvidia Docker

## Docker

Please refer to [Offical docker documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/) to install docker for Ubuntu 18.04

## Docker Compose

[Official docker compose installation](https://docs.docker.com/compose/install/)

## Nvidia Docker

Official [repository](https://github.com/NVIDIA/nvidia-docker)

```
# Add the package repositories

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
 sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
 sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update


# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd
```

## Allow X Server connections

In your host machine type the following:

```
xhost +
```

Now we are ready to proceed

# Build and Running

```
git clone git@github.com:VertexStudio/simbotic-openpose.git
```

Inside the recent clone repo type:

```
docker-compose up -d
```

This will build and start the container.

Now we need to enter:

```
docker exec -it simbotic-openpose bash
```
