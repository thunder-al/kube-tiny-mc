FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5

RUN set -ex; \
    rpm --import https://yum.corretto.aws/corretto.key; \
    curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo; \
    microdnf install -y java-24-amazon-corretto-devel; \
    microdnf clean all;

COPY --chmod=755 setup-and-start /opt/setup-and-start

COPY server/ /srv/server-init

CMD /opt/setup-and-start
