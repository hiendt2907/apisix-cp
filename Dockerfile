# Base image: dùng image chính thức của APISIX hoặc image bạn build sẵn
FROM apache/apisix:3.13.0-debian

# Switch to root để copy file cấu hình và script
USER root

# Copy script khởi động (nếu bạn dùng entrypoint.sh để sinh config.yaml từ ENV)
COPY entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Nếu bạn dùng file config.yaml cố định, hãy copy nó vào đây
# COPY config.yaml /usr/local/apisix/conf/config.yaml

# Optional: expose các cổng cần thiết
EXPOSE 9080 9443 9180 9280

# Healthcheck đơn giản (Railway sẽ dùng để kiểm tra container)
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:9180/apisix/admin/routes || exit 1

# Khởi động bằng entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

