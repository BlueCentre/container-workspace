FROM fedora:latest
MAINTAINER James H Nguyen <james@callfire.com>

RUN dnf -y update && dnf clean all
RUN dnf -y install git \
                   python \
                   sudo \
                   && dnf clean all

# add an gcloud user and allow it to sudo
RUN useradd -m gcloud && echo 'gcloud ALL=NOPASSWD: ALL' > /etc/sudoers.d/gcloud

# switch to gcloud user
USER gcloud
ENV PATH /home/gcloud/google-cloud-sdk/bin:$PATH
ENV HOME /home/gcloud
ENV CLOUDSDK_PYTHON /usr/bin/python

# install gcloud
RUN curl -o /tmp/google-cloud-sdk.tar.gz \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar -C /home/gcloud -zxf /tmp/google-cloud-sdk.tar.gz \
    && /home/gcloud/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --bash-completion true \
        --rc-path /home/gcloud/.bashrc \
        --path-update true \
    && rm -rf /tmp/google-cloud-sdk.tar.gz

VOLUME /home/gcloud /data
#VOLUME ['/home/gcloud/.config/gcloud']

CMD /bin/bash

#build image:
# 'docker build -t gcloud .'
#create storage container:
# 'docker create -v /home/gcloud/.config/gcloud --name gcloud-config ipv1337/docker-gcloud /bin/true'
#run container with storage:
# 'docker run --volumes-from gcloud-config --name gcloud -it ipv1337/docker-gcloud'
