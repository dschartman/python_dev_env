#################################################
FROM dschartman/miniconda_base as base

#################################################
FROM base as staging

#################################################
FROM base

ENV PYTHONDONTWRITEBYTECODE true

RUN apt update && \
    apt install -y wget && \
    apt clean

ENV DOCKER_CLI_INSTALL_FILE docker-ce-cli_19.03.4~3-0~debian-buster_amd64.deb
RUN wget https://download.docker.com/linux/debian/dists/buster/pool/stable/amd64/${DOCKER_CLI_INSTALL_FILE} && \
    dpkg -i ${DOCKER_CLI_INSTALL_FILE} && \
    rm ${DOCKER_CLI_INSTALL_FILE}

ENV DIVE_INSTALL_FILE dive_0.9.1_linux_amd64.deb
RUN wget https://github.com/wagoodman/dive/releases/download/v0.9.1/${DIVE_INSTALL_FILE} && \
    dpkg -i ${DIVE_INSTALL_FILE} && \
    rm ${DIVE_INSTALL_FILE}