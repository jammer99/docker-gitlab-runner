FROM gitlab/gitlab-runner:latest

RUN apt-get update && \
    apt-get -y install \
            make \
            rsync \
            curl \
            nano \
            sshpass \
        --no-install-recommends && \
    rm -r /var/lib/apt/lists/* # 150901

# add missing SSL certificate https://bugs.launchpad.net/ubuntu/+source/ca-certificates/+bug/1261855
RUN curl -o /usr/local/share/ca-certificates/como.crt \
      https://gist.githubusercontent.com/schmunk42/5abeaf7ca468dc259325/raw/2a8e19139d29aeea2871206576e264ef2d45a46d/comodorsadomainvalidationsecureserverca.crt \
 && update-ca-certificates

RUN curl -L https://github.com/docker/compose/releases/download/1.6.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

ENV TERM=linux

RUN git config --global user.email "ci-runner@example.com" && \
    git config --global user.name "CI Runner"

CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
