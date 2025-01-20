FROM mcr.microsoft.com/devcontainers/base:bookworm@sha256:6155a486f236fd5127b76af33086029d64f64cf49dd504accb6e5f949098eb7e

# Set environment variables
ENV EDITOR=vim
USER vscode

# Install mise CLI
RUN sudo apt update -y && sudo apt install -y gpg sudo wget curl && \
    sudo install -dm 755 /etc/apt/keyrings && \
    wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list && \
    sudo apt update && \
    sudo apt install -y mise

# Activate mise
RUN echo 'eval "$(/usr/bin/mise activate bash)"' >> ~/.bashrc
RUN echo 'eval "$(/usr/bin/mise activate zsh)"' >> ~/.zshrc

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
