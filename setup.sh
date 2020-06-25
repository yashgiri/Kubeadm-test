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

cat > /etc/yum.repos.d/kubernetes.repo <<EOF 
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF
# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

cat << EOF >> /etc/sysctl.conf
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p

systemctl enable --now kubelet || true

systemctl daemon-reload
systemctl restart kubelet