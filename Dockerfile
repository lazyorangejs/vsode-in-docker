FROM lazyorange/code-ext:latest as build

# --> You can set prefered version of code-server
FROM codercom/code-server:1.621 as vscode

FROM ubuntu:bionic

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68818C72E52529D4
RUN apt-get update && apt install -y bsdtar

# --> Install Krypton utils
RUN curl https://krypt.co/kr | sh

RUN apt-get install -y jq wget curl && jq --version
# --> Install yq (https://mikefarah.github.io/yq/)
ENV YQ_VERSION 2.3.0
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    mv ./yq_linux_amd64 /usr/local/bin/yq && chmod +x /usr/local/bin/yq && yq --version

ENV HOME_DIR /root
WORKDIR $HOME_DIR/Projects

# --> Install Oh-My-ZSH
RUN apt-get -yq install git zsh && \
    chsh -s /usr/bin/zsh && \ 
    rm -rf $HOME_DIR/.oh-my-zsh && \ 
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME_DIR/.oh-my-zsh
COPY .zshrc $HOME_DIR/.zshrc

RUN curl -sL https://howtowhale.github.io/dvm/downloads/latest/install.sh | sh

ENV VSCODE_EXT_DIR /root/.vscode/extensions
RUN mkdir -p ${VSCODE_EXT_DIR}

COPY --from=build /root/.local/share/code-server/extensions $VSCODE_EXT_DIR
COPY --from=vscode /usr/local/bin/code-server /usr/local/bin/code-server

# --> Install ngrok
RUN apt-get install -y unzip && wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && mv ./ngrok /usr/local/bin

# --> Install Google Cloud SDK and kubectl
RUN apt-get update && apt-get install -y python2.7
RUN cd ~/ && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-241.0.0-linux-x86_64.tar.gz && tar xvzf google-cloud-sdk-241.0.0-linux-x86_64.tar.gz && \ 
    ./google-cloud-sdk/install.sh --usage-reporting false --additional-components kubectl --quiet && \
    # The next line updates PATH for the Google Cloud SDK.
    echo "\n if [ -f '/root/google-cloud-sdk/path.zsh.inc' ]; then . '/root/google-cloud-sdk/path.zsh.inc'; fi" >> ~/.zshrc && \
    # The next line enables shell command completion for gcloud.
    echo "if [ -f '/root/google-cloud-sdk/completion.zsh.inc' ]; then . '/root/google-cloud-sdk/completion.zsh.inc'; fi" >> ~/.zshrc

COPY ./kubectl/run.sh /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

CMD code-server --port 80 --user-data-dir /root/.local/share/code-server --extensions-dir /root/.vscode/extensions --allow-http --no-auth