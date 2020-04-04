# Docker stage we'll use later for the CLI
FROM ubuntu:18.04 AS docker

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
	apt-get update && \
	apt-get install -y docker-ce-cli

FROM codercom/code-server:3.0.2

ENV CURL_RETRY 5

USER root

COPY --from=docker /usr/bin/docker /usr/local/bin/docker

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

# Install go tools fo vscode
RUN go get \
    github.com/mdempsky/gocode \
    github.com/ramya-rao-a/go-outline \
    github.com/acroca/go-symbols \
    golang.org/x/tools/cmd/guru \
    golang.org/x/tools/cmd/gorename \
    github.com/cweill/gotests/... \
    github.com/fatih/gomodifytags \
    github.com/josharian/impl \
    github.com/davidrjenni/reftools/cmd/fillstruct \
    github.com/haya14busa/goplay/cmd/goplay \
    github.com/godoctor/godoctor \
    github.com/go-delve/delve/cmd/dlv \
    github.com/stamblerre/gocode \
    github.com/sqs/goreturns \
    golang.org/x/lint/golint

USER coder
