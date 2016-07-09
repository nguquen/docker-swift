FROM ubuntu:16.04
MAINTAINER nguquen <info@botbie.com>
LABEL Description="Lastest Swift binaries with libdispatch built-in."
ENV UBUNTU_VERSION ubuntu15.10
ENV UBUNTU_VERSION_NO_DOTS ubuntu1510
ENV SWIFT_VERSION swift-3.0-PREVIEW-2
ENV WORK_DIR /opt
WORKDIR ${WORK_DIR}

# RUN sed -i 's/archive.ubuntu.com/opensource.xtdv.net/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y clang libicu-dev autoconf libtool libkqueue-dev libkqueue0 libcurl4-openssl-dev libbsd-dev libblocksruntime-dev wget git pkg-config libpython2.7

RUN wget -nv https://swift.org/builds/`echo "$SWIFT_VERSION" | awk '{print tolower($0)}'`/$UBUNTU_VERSION_NO_DOTS/$SWIFT_VERSION/$SWIFT_VERSION-$UBUNTU_VERSION.tar.gz \
  && tar xzvf $SWIFT_VERSION-$UBUNTU_VERSION.tar.gz \
  && rm $SWIFT_VERSION-$UBUNTU_VERSION.tar.gz

ENV PATH $WORK_DIR/$SWIFT_VERSION-$UBUNTU_VERSION/usr/bin:$PATH

RUN swift --version

RUN git clone --recursive -b experimental/foundation https://github.com/apple/swift-corelibs-libdispatch.git \
  && cd swift-corelibs-libdispatch \
  && sh ./autogen.sh \
  && ./configure --with-swift-toolchain=$WORK_DIR/$SWIFT_VERSION-$UBUNTU_VERSION/usr --prefix=$WORK_DIR/$SWIFT_VERSION-$UBUNTU_VERSION/usr \
  && make \
  && make install
