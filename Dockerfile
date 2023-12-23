FROM alpine/k8s:1.25.3
COPY *.sh /opt/

ENTRYPOINT ["tail", "-f", "/dev/null"]