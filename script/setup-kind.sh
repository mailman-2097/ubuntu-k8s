#! /bin/bash -e
pushd /tmp

# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

popd

echo "Copy Kind_cluster config and create cluster"
