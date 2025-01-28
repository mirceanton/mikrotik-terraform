FROM mcr.microsoft.com/devcontainers/base:bookworm@sha256:6155a486f236fd5127b76af33086029d64f64cf49dd504accb6e5f949098eb7e

# Set environment variables
ENV EDITOR=vim

# Install aqua package manager
RUN wget https://github.com/aquaproj/aqua/releases/download/v2.43.0/aqua_linux_amd64.tar.gz -O aqua.tar.gz && \
    tar xvf aqua.tar.gz && \
    mv aqua /usr/local/bin/aqua && \
    chmod +x /usr/local/bin/aqua

# Switch to vscode user
USER vscode

# Install tools
COPY aqua.yaml aqua.yaml
RUN echo 'export PATH="$(aqua root-dir)/bin:$PATH"' >> ~/.bashrc
RUN echo 'export PATH="$(aqua root-dir)/bin:$PATH"' >> ~/.zshrc
RUN aqua install

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
