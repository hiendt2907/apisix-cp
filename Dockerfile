FROM apache/apisix:latest

USER root

# Copy entrypoint và mẫu config
COPY entrypoint.sh /entrypoint.sh
COPY config-template.yaml /usr/local/apisix/conf/config-template.yaml

RUN chmod +x /entrypoint.sh

EXPOSE 9080 9443 9180 9280

ENTRYPOINT ["/entrypoint.sh"]

