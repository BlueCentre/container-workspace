FROM fedora:latest
MAINTAINER James H Nguyen <james.nguyen@gmail.com>

# update and install minimal packages
RUN dnf -y update && dnf clean all
RUN dnf -y install python2 \
                   python3-virtualenv \
                   make \
                   git \
                   ansible \
                   sudo \
                   dumb-init \
                   net-tools \
                   procps \
                   unzip \
                   && dnf clean all





# custom aliases to bootstrap workspace
COPY bootstrap.sh /etc/profile.d/





# install these tools before switching to local user
#ENV KUBECTL_VERSION 1.14.1
#RUN curl --silent -L -o kubectl \
#        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
#        && chmod 0755 kubectl \
#        && mv kubectl /usr/bin
RUN curl -sL "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/bin/kubectl && \
    chmod 0755 /usr/bin/kubectl

#ENV HELM_VERSION 2.13.1
#RUN curl --silent -L -o helm.tar.gz \
#        https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
#        && tar -xvzf helm.tar.gz \
#        && rm -rf helm.tar.gz \
#        && chmod 0755 linux-amd64/helm \
#        && mv linux-amd64/helm /usr/local/bin
RUN curl --silent "https://raw.githubusercontent.com/helm/helm/master/scripts/get" | bash

ENV TERRAFORM_VERSION 0.11.13
RUN curl --silent -o ./terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/local/bin \
        && rm -rf terraform.zip

ENV TERRAGRUNT_VERSION 0.18.3
RUN curl --silent -L -o ./terragrunt \
        https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
        && chmod 0755 terragrunt \
        && mv terragrunt /usr/local/bin

#ENV TERRAFORM_PROVIDER_HELM_VERSION 0.7.0
#RUN curl -L -o ./tph.tar.gz \
#        https://github.com/gpii-ops/terraform-provider-helm/releases/download/v${TERRAFORM_PROVIDER_HELM_VERSION}/terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION}_linux_amd64.tar.gz \
#        && tar -xvzf tph.tar.gz \
#        && rm -rf tph.tar.gz \
#        && cd terraform-provider-helm_linux_amd64 \
#        && chmod 0755 terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} \
#        && mkdir -p /root/.terraform.d/plugins/ \
#        && mv terraform-provider-helm_v${TERRAFORM_PROVIDER_HELM_VERSION} /root/.terraform.d/plugins/

#ENV HELMFILE_VERSION 0.54.2
#RUN curl -L -o helmfile \
#        https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 \
#        && chmod 0755 helmfile \
#        && mv helmfile /usr/bin





# install code-server
ENV CODE_VERSION="1.939-vsc1.33.1"
RUN curl -sL https://github.com/codercom/code-server/releases/download/${CODE_VERSION}/code-server${CODE_VERSION}-linux-x64.tar.gz | tar --strip-components=1 -zx -C /usr/local/bin code-server${CODE_VERSION}-linux-x64/code-server

# NOTE: this needs to be set on the k8s nodes since it does nothing inside a container
# https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc
#RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf





# add a local shell user and allow it to sudo without password
ENV LOCAL_USER luser
RUN useradd -m ${LOCAL_USER} && \
    echo "${LOCAL_USER} ALL=NOPASSWD: ALL" > /etc/sudoers.d/${LOCAL_USER}
# switch to user
USER ${LOCAL_USER}
ENV HOME /home/${LOCAL_USER}




# setup & install gcloud
ENV PATH /home/${LOCAL_USER}/google-cloud-sdk/bin:${PATH}
ENV CLOUDSDK_PYTHON /usr/bin/python

RUN curl --silent -o /tmp/google-cloud-sdk.tar.gz \
        https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz \
        && tar -C /home/${LOCAL_USER} -zxf /tmp/google-cloud-sdk.tar.gz \
        && /home/${LOCAL_USER}/google-cloud-sdk/install.sh \
            --usage-reporting false \
            --bash-completion true \
            --rc-path /home/${LOCAL_USER}/.bashrc \
            --path-update true \
        && rm -rf /tmp/google-cloud-sdk.tar.gz \
        && rm -rf /home/${LOCAL_USER}/google-cloud-sdk/.install/.backup





# setup helm client and tiller plugin as local user
RUN helm init --client-only && \
    helm plugin install https://github.com/rimusz/helm-tiller





# setup local user workspace
RUN mkdir -p /home/${LOCAL_USER}/project
WORKDIR /home/${LOCAL_USER}/project





#VOLUME /data /home/luser/.config/gcloud /home/luser/.ssh
VOLUME /data /home/${LOCAL_USER}/.config/gcloud

# code-server will listen on 8443 by default when it starts
EXPOSE 8443
ENTRYPOINT ["dumb-init", "code-server"]
#CMD sleep infinity