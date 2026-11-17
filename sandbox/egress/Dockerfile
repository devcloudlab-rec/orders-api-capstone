# Egress proxy: lets the agent reach the model API and nothing else.
FROM alpine:3.20
RUN apk add --no-cache tinyproxy
COPY tinyproxy.conf /etc/tinyproxy/tinyproxy.conf
COPY filter /etc/tinyproxy/filter
EXPOSE 8888
USER nobody
CMD ["tinyproxy", "-d"]
