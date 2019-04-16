#!/usr/bin/env bash

export CI_REGISTRY_URL=lazyorange

docker-compose build kubectl helm
docker-compose push kubectl helm
