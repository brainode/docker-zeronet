FROM alpine:latest

RUN apk update && apk upgrade && \
    apk add --no-cache --update && \
    apk add python3 python3-dev gcc libffi-dev musl-dev make tor openssl

RUN cd /opt && wget https://github.com/HelloZeroNet/ZeroNet-linux/archive/dist-linux64/ZeroNet-py3-linux64.tar.gz && \
    tar xvpfz ZeroNet-py3-linux64.tar.gz && \
    cp -R /opt/ZeroNet-linux-dist-linux64/core /opt/zeronet
RUN pip3 install -r /opt/zeronet/requirements.txt \
 && apk del python3-dev gcc libffi-dev musl-dev make \
 && echo "ControlPort 9051" >> /etc/tor/torrc \
 && echo "CookieAuthentication 1" >> /etc/tor/torrc
WORKDIR /



ENV ENABLE_TOR false


EXPOSE 43110 26552

CMD (! ${ENABLE_TOR} || tor&) && python3 /opt/zeronet/zeronet.py --fileserver_port 26552