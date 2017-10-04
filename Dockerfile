FROM ubuntu:17.10

RUN apt-get -q update && \
  apt-get -q install -y \
    make \
    libatomic1 \
    libpython2.7 \
    libxml2 \
    clang \
    git \
    curl \
  && true

RUN export SWIFT_PLATFORM=ubuntu16.10 && \
    export SWIFT_VERSION=4.0 && \
    export SWIFT_BASE=swift-$SWIFT_VERSION-RELEASE-$SWIFT_PLATFORM && \
    export SWIFT_URL=https://swift.org/builds/swift-$SWIFT_VERSION-release/$(echo $SWIFT_PLATFORM | tr -d .)/swift-$SWIFT_VERSION-RELEASE/$SWIFT_BASE.tar.gz && \
    curl $SWIFT_URL -o /tmp/swift.tar.gz && \
    tar zxf /tmp/swift.tar.gz -C /opt && \
    mv /opt/$SWIFT_BASE/usr /opt/swift && \
    rmdir /opt/$SWIFT_BASE


RUN useradd -m swift
RUN cd ~swift && \
    export HOME=`pwd` && \
    git clone https://github.com/apstrand/sane.git && \
    rm .bashrc && \
    sane/sanity.sh && \
    chown -R swift. . && \
    echo 'export PATH="$PATH:/opt/swift/bin"' >> .bashrc_local

RUN su swift -l -c "swiftc --version"

ENTRYPOINT su swift -l
