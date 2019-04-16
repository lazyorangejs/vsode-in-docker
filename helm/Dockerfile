FROM alpine:3.8

ARG helm_ver=v2.13.1
ENV HELM_VERSION=$helm_ver

RUN apk add --no-cache curl ca-certificates

# Install helm
# https://github.com/helm/helm/releases
RUN curl -o helm-$HELM_VERSION-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz && \
    tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm version --client

ENV HOME=/config

RUN set -x && \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser helm -Du 2342 -h /config

USER helm

ENTRYPOINT ["/usr/local/bin/helm"]