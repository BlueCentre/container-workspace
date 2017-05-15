FROM fedora:latest
MAINTAINER James H Nguyen <james@callfire.com>

RUN dnf -y update && dnf clean all
RUN dnf -y install git \
                   ansible \
                   sudo \
                   && dnf clean all

# environment
ENV WORKSPACE_USER ${WORKSPACE_USER:-gcloud}

# add an gcloud user and allow it to sudo
RUN useradd -m luser && echo 'luser ALL=NOPASSWD: ALL' > /etc/sudoers.d/luser

# switch to user
USER luser
ENV HOME /home/luser
ENV PATH /home/luser/google-cloud-sdk/bin:${PATH}
ENV CLOUDSDK_PYTHON /usr/bin/python

# install gcloud
RUN curl -o /tmp/google-cloud-sdk.tar.gz \
    https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
    && tar -C /home/luser -zxf /tmp/google-cloud-sdk.tar.gz \
    && /home/luser/google-cloud-sdk/install.sh \
        --usage-reporting false \
        --bash-completion true \
        --rc-path /home/luser/.bashrc \
        --path-update true \
    && rm -rf /tmp/google-cloud-sdk.tar.gz

VOLUME /data /home/luser/.config/gcloud /home/luser/.ssh

CMD /bin/bash

#build image:
# $ docker build -t fedora-workspace .

#example usage:
# $ docker create -v /data --name data-volume fedora /bin/true
# $ docker create -v /home/luser/.config/gcloud --name gcloud-config-volume fedora /bin/true
# $ docker run --volumes-from data-volume --volumes-from gcloud-config-volume --name workspace -it ipv1337/fedora-workspace
# or
# $ docker run --volumes-from data-volume --volumes-from gcloud-config-volume -v c:/Users/<username>/Docker/data/Gitlab/home/.ssh:/home/luser/.ssh --name workspace -it ipv1337/fedora-workspace
# or
# $ docker run -v mydatavol:/data -v mygcloudconfigvol:/home/luser/.config/gcloud -v c:/Users/James/Docker/data/Gitlab/home/.ssh:/home/luser/.ssh --name myworkspace -it ipv1337/fedora-workspace
#relaunch:
# $ docker start workspace
# $ docker attach workspace
