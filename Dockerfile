FROM ubuntu:14.04
MAINTAINER Tom Spacek <ts@papercloud.com.au>

ENV THUMBOR_VERSION 5.0.6

EXPOSE 8000

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    checkinstall \
    gcc \
    python \
    python-dev \
    libpng12-dev \
    libtiff5-dev \
    libpng-dev \
    libjasper-dev \
    libwebp-dev \
    libcurl4-openssl-dev \
    python-pgmagick \
    libmagick++-dev \
    graphicsmagick \
    libopencv-dev \
    python-pip

RUN pip install thumbor==$THUMBOR_VERSION \
                tc_aws \
                envtpl

COPY thumbor.conf.tpl /etc/thumbor.conf.tpl
RUN envtpl /etc/thumbor.conf.tpl --keep-template --allow-missing

ENTRYPOINT ["/usr/local/bin/thumbor"]

CMD ["--port=8000", "-c", "/etc/thumbor.conf"]