FROM fedora:latest
MAINTAINER James H Nguyen <james@callfire.com>

RUN dnf -y update && dnf clean all
RUN dnf -y install git \
                   python \
                   sudo \
                   && dnf clean all

# environment
ENV WORKSPACE_USER ${WORKSPACE_USER:-gcloud} \
    HOME /home/luser \
    PATH /opt/google-cloud-sdk/bin:${PATH} \
    CLOUDSDK_PYTHON /usr/bin/python

# add an gcloud user and allow it to sudo
RUN useradd -m luser && echo 'luser ALL=NOPASSWD: ALL' > /etc/sudoers.d/luser

# switch to user
USER luser

# install gcloud
RUN curl -o /tmp/google-cloud-sdk.tar.gz \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar -C /home/luser-zxf /tmp/google-cloud-sdk.tar.gz \
    && /home/luser/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --bash-completion true \
        --rc-path /home/luser/.bashrc \
        --path-update true \
    && rm -rf /tmp/google-cloud-sdk.tar.gz

VOLUME /home/luser /data
#VOLUME ['/home/gcloud/.config/gcloud']

CMD /bin/bash

#build image:
# 'docker build -t fedora-workspace .'

#[host storage option]
# 'docker run --name myworkspace -v c:/Users/<username>/Docker/data:/data -v c:/Users/<username>/Docker/home:/home/luser -it ipv1337/fedora-workspace

#[storage container option]
#create storage container:
# 'docker create -v /home/luser/.config/gcloud --name gcloud-config ipv1337/fedora-workspace /bin/true'
#run container with storage:
# 'docker run --volumes-from gcloud-config --name myworkspace -it ipv1337/fedora-workspace'
