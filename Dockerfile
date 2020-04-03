FROM codercom/code-server:3.0.2

ENV CURL_RETRY 5

USER root

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    make=4.2.1-1.2 \
    gcc=4:8.3.0-1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install go
ENV GO_VERSION 1.14.1
ENV GO_SHASUM 2f49eb17ce8b48c680cdb166ffd7389702c0dec6effa090c324804a5cac8a7f8
RUN curl -SsL --retry ${CURL_RETRY} -O "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" && \
    sha256sum "go${GO_VERSION}.linux-amd64.tar.gz" | grep "${GO_SHASUM}" && \
    tar xf "go${GO_VERSION}.linux-amd64.tar.gz" && \
    mv go /usr/local && \
    rm -f "go${GO_VERSION}.linux-amd64.tar.gz"
ENV GOPATH /home/coder/project/go
ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:$GOPATH

USER coder
