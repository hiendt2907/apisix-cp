FROM apache/apisix:3.9.1-debian

USER root
COPY config-template.yaml /usr/local/apisix/conf/config-template.yaml
COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
USER 101   # trả lại user mặc định của apisix

ENTRYPOINT ["/docker-entrypoint.sh"]

