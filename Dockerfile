FROM alpine:latest

# Install all build dependencies
RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
    build-base \
    gcc \
    && apk add --no-cache \
    bash \
    && apk add --no-cache \
    protobuf \
    protobuf-dev \
    && apk add --no-cache \
    openssl \
    openssl-dev \
    && apk add --no-cache \
    qt5-qtbase \
    iputils \
    tcptraceroute \
    libpcap \
    libpcap-dev \
    whois \
    tcpdump \
    busybox-extras \
    curl && \
    apk add hping3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    mkdir /spoofer

COPY ./spoofer-1.4.6.tar.gz /spoofer

COPY ./entrypoint.sh /spoofer
RUN sed -i 's/\r//' /spoofer/entrypoint.sh && \
    chmod +x /spoofer/entrypoint.sh


WORKDIR /spoofer

# Install CAIDA Spoofer and then cleanup
RUN tar xzvf spoofer-1.4.6.tar.gz && \
    cd spoofer-1.4.6 && \
    ./configure && \
    make && \
    make install && \
    make clean && \
    cd .. && \
    rm -rf spoofer-1.4.6

ENTRYPOINT ["/spoofer/entrypoint.sh"]
