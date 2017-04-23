FROM fedora:latest
MAINTAINER James H Nguyen <james@callfire.com>

RUN dnf -y update && dnf clean all
RUN dnf -y install git \
                   python \
                   sudo \
                   && dnf clean all

# environment
ENV WORKSPACE_USER ${WORKSPACE_USER:-gcloud} \
    HOME /home/${WORKSPACE_USER} \
    PATH /opt/google-cloud-sdk/bin:${PATH} \
    CLOUDSDK_PYTHON /usr/bin/python

# add an gcloud user and allow it to sudo
RUN useradd -m ${WORKSPACE_USER} && echo '${WORKSPACE_USER} ALL=NOPASSWD: ALL' > /etc/sudoers.d/${WORKSPACE_USER}

# switch to user
USER ${WORKSPACE_USER}

# install gcloud
RUN curl -o /tmp/google-cloud-sdk.tar.gz \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar -C /opt -zxf /tmp/google-cloud-sdk.tar.gz \
    && /opt/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --bash-completion true \
        --rc-path /home/${WORKSPACE_USER}/.bashrc \
        --path-update true \
    && rm -rf /tmp/google-cloud-sdk.tar.gz

VOLUME /home/${WORKSPACE_USER} /data
#VOLUME ['/home/gcloud/.config/gcloud']

CMD /bin/bash

#build image:
# 'docker build -t gcloud .'
#create storage container:
# 'docker create -v /home/gcloud/.config/gcloud --name gcloud-config ipv1337/docker-gcloud /bin/true'
#run container with storage:
# 'docker run --volumes-from gcloud-config --name gcloud -it ipv1337/docker-gcloud'
