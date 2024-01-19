FROM alpine/k8s:1.25.3
COPY *.sh /opt/
COPY k8s/ /opt/k8s/

RUN apk add vim rsync sysbench stress-ng bash hdparm \
    && chmod +x /opt/*.sh

ENV COMMAND=
ENTRYPOINT  bash -c "[[ ! -z \"$COMMAND\" ]] && bash -c \"$COMMAND\" || tail -f /dev/null"