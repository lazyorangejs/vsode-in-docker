#!/bin/sh
# Run kubectl in a container

# Inspired by https://docs.docker.com/compose/install/

# $ sudo curl -L --fail https://raw.githubusercontent.com/lazyorangejs/vsode-in-docker/master/kubectl/run.sh -o /usr/local/bin/kubectl
# $ sudo chmod +x /usr/local/bin/kubectl

kubectl_ver=${KUBECTL_VERSION:-v1.14.0}

kubectl () {
  docker run --rm -it --user $UID:$GID \
    -w /code -v "$PWD":/code:ro \
    lazyorange/kubectl:$kubectl_ver "$@"
}

kubectl "$@"
