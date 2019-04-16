#!/bin/sh
# Run kubectl in a container

# Inspired by https://docs.docker.com/compose/install/
kubectl_ver=${KUBECTL_VERSION:-v1.14.0}

kubectl () {
  docker run --rm -it --user $UID:$GID \
    -w /code -v "$PWD":/code:ro \
    lazyorange/kubectl:$kubectl_ver "$@"
}

exec kubectl "$@"