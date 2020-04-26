#TODO use official flyway

FROM dhoer/flyway:alpine

#Install envsubst and required dependencies
RUN apk add --update --no-cache curl ca-certificates gettext

#Install kubectl
ENV KUBECONFIG /.kube/config

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl

COPY kube_config /.kube

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

#Default values
ENV LOCAL_PORT 8080
ENV NAMESPACE default
ENV SCRIPT_LOCATIONS filesystem:sql

ENTRYPOINT ["/entrypoint.sh"]