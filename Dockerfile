FROM gitlab/gitlab-runner:v10.4.0

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install \
            make \
            rsync \
            curl \
            nano \
            sshpass \
            git-lfs \
        --no-install-recommends && \
    apt-get -y clean && \
    rm -r /var/lib/apt/lists/* # 150901

RUN git lfs install

# add missing SSL certificate https://bugs.launchpad.net/ubuntu/+source/ca-certificates/+bug/1261855
RUN curl -o /usr/local/share/ca-certificates/como.crt \
      https://gist.githubusercontent.com/schmunk42/5abeaf7ca468dc259325/raw/2a8e19139d29aeea2871206576e264ef2d45a46d/comodorsadomainvalidationsecureserverca.crt \
 && update-ca-certificates

# install docker tools in order of release date
RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 > /usr/local/bin/docker-1.9.1 && \
    chmod +x /usr/local/bin/docker-1.9.1

RUN curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose-1.7.1 && \
    chmod +x /usr/local/bin/docker-compose-1.7.1

RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.10.3 > /usr/local/bin/docker-1.10.3 && \
    chmod +x /usr/local/bin/docker-1.10.3

RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.11.2.tgz > /tmp/docker-1.11.2.tgz && \
    cd /tmp && tar -xzf ./docker-1.11.2.tgz && \
    mv /tmp/docker/docker /usr/local/bin/docker-1.11.2 && \
    chmod +x /usr/local/bin/docker-1.11.2 && \
    rm -rf /tmp/docker*

# up to version 4.7
RUN curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose-1.8.1 && \
    chmod +x /usr/local/bin/docker-compose-1.8.1

RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz > /tmp/docker-1.12.6.tgz && \
    cd /tmp && tar -xzf ./docker-1.12.6.tgz && \
    mv /tmp/docker/docker /usr/local/bin/docker-1.12.6 && \
    chmod +x /usr/local/bin/docker-1.12.6 && \
    rm -rf /tmp/docker*

# version 5.0
ENV DOCKER_VERSION_CURRENT=17.12.0-ce \
    COMPOSE_VERSION_CURRENT=1.18.0
RUN curl -L https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION_CURRENT}.tgz > /tmp/docker-${DOCKER_VERSION_CURRENT}.tgz && \
    cd /tmp && tar -xzf ./docker-${DOCKER_VERSION_CURRENT}.tgz && \
    mv /tmp/docker/docker /usr/local/bin/docker-${DOCKER_VERSION_CURRENT} && \
    chmod +x /usr/local/bin/docker-${DOCKER_VERSION_CURRENT} && \
    rm -rf /tmp/docker*

RUN curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION_CURRENT}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose-${COMPOSE_VERSION_CURRENT} && \
    chmod +x /usr/local/bin/docker-compose-${COMPOSE_VERSION_CURRENT}

# Link default versions
RUN ln -s /usr/local/bin/docker-${DOCKER_VERSION_CURRENT} /usr/local/bin/docker && \
    ln -s /usr/local/bin/docker-compose-${COMPOSE_VERSION_CURRENT} /usr/local/bin/docker-compose

ENV TERM=linux

CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]

RUN git config --global user.email "ci-runner@example.com" && \
    git config --global user.name "CI Runner"
