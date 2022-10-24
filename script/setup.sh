#! /bin/bash -e
cp /etc/apt/sources.list /etc/apt/sources.list.0
sed -i -E "s|http://us.|http://|g" /etc/apt/sources.list
apt-get update
apt-get upgrade -y
apt-get install software-properties-common -y
apt-get install linux-headers-$(uname -r) build-essential dkms -y
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install ansible -y
ansible-galaxy collection install community.general

pushd /vagrant
ansible-playbook provisioning/ansible/playbook.yml
popd

usermod -a -G docker vagrant

pushd /tmp

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml

popd

echo "Base Setup Complete !"
