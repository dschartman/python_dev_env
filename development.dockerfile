#################################################
FROM dschartman/miniconda_base as staging

RUN apt update && \
    apt install -y \
        curl \
        wget

RUN curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o docker-compose
RUN chmod +x docker-compose

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
RUN chmod +X kubectl

RUN wget https://get.helm.sh/helm-v2.16.0-linux-amd64.tar.gz && \
    tar -xzvf helm-v2.16.0-linux-amd64.tar.gz

#################################################
FROM dschartman/miniconda_base

ENV PYTHONDONTWRITEBYTECODE true

RUN apt update && \
    apt install -y \
        wget \
        git \
        vim \
        ansible \
        sshpass \
        htop \
        && \
    apt clean

ENV DOCKER_CLI_INSTALL_FILE docker-ce-cli_19.03.4~3-0~debian-buster_amd64.deb
RUN wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CLI_INSTALL_FILE} && \
    dpkg -i ${DOCKER_CLI_INSTALL_FILE} && \
    rm ${DOCKER_CLI_INSTALL_FILE}

COPY --from=staging docker-compose /usr/local/bin

COPY --from=staging kubectl /usr/local/bin

COPY --from=staging linux-amd64/helm /usr/local/bin

RUN DIVE_INSTALL_FILE=dive_0.9.1_linux_amd64.deb && \
    wget https://github.com/wagoodman/dive/releases/download/v0.9.1/${DIVE_INSTALL_FILE} && \
    dpkg -i ${DIVE_INSTALL_FILE} && \
    rm ${DIVE_INSTALL_FILE}

COPY .gitconfig /root/.git
RUN ln -s /root/.git/.gitconfig /root/.gitconfig

WORKDIR /root
