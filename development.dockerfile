#################################################
FROM dschartman/miniconda_base as staging

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
        git \
        vim \
        ansible \
        sshpass \
        htop \
        ssl-cert \
        gnupg2 \
        && \
    apt clean

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker-ce.list

RUN apt update && \
    apt install -y docker-ce-cli && \
    ACCEPT_EULA=Y apt install -y msodbcsql17 && \
    apt clean

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

ENTRYPOINT /bin/bash
