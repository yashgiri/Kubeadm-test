yum update
swapoff -a
## Set up the repository
### Install required packages
yum install -y yum-utils device-mapper-persistent-data lvm2
## Add the Docker repository
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# Install Docker CE
yum update -y
yum install -y containerd.io-1.2.13 docker-ce-19.03.11 docker-ce-cli-19.03.11
## Create /etc/docker
mkdir /etc/docker

# Set up the Docker daemon
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
# Restart Docker
systemctl daemon-reload
systemctl restart docker
# make docker to start on boot
sudo systemctl enable docker