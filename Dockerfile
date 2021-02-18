FROM arm32v7/debian:buster-slim

# we not use alpine to install kubectl by "apt-get" (we cannot found how to install kubectl by "apk" at alpine-linux)
# kubectl installation is from https://kubernetes.io/ja/docs/tasks/tools/install-kubectl/
# wget not curl  is needed to get gpg due to when we using curl, valid certificate not used.
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 
RUN apt-get update && \
    apt-get install -y wget apt-transport-https gnupg2 python3 python3-pip && \
    wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl && \
    pip3 install boto3 && \
    echo "done"

WORKDIR /root/

COPY . .

RUN chmod +x /root/update_ecr_credential_secret.sh

CMD ["/root/update_ecr_credential_secret.sh"]