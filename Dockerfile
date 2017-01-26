FROM debian:jessie

MAINTAINER Madhava Jay me@madhavajay.com

# Install runtime dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        bzip2 \
        libfontconfig \
        unzip \
        curl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

    # Install PhantomJS Custom Edition https://github.com/mrorgues/PhantomJSCustomEdition
RUN set -x  \
 && mkdir /tmp/phantomjs \
 && curl -L https://raw.githubusercontent.com/mrorgues/PhantomJSCustomEdition/builds/phantomjs-2.1.1-linux-x86_64-workaround_issue_394.tar.bz2 \
        | tar -xj --strip-components=1 -C /tmp/phantomjs \
 && mv /tmp/phantomjs/bin/phantomjs /usr/local/bin \
    # Run as non-root user.
 && useradd --system --uid 72379 -m --shell /usr/sbin/nologin phantomjs \
 && su phantomjs -s /bin/sh -c "phantomjs --version" \
    # Get tweaked GhostDriver which allows custom remoteHost param
 && cd /tmp \
 && curl -O -L https://github.com/madhavajay/ghostdriver/archive/remotehost.zip \
 && unzip /tmp/remotehost.zip \
 && mkdir -p /home/phantomjs/ghostdriver/src \
 && mv /tmp/ghostdriver-remotehost/src /home/phantomjs/ghostdriver \
    # Clean up
&& apt-get purge --auto-remove -y \
     curl \
     unzip \
&& apt-get clean \
&& rm -rf /tmp/* /var/lib/apt/lists/*

USER phantomjs

CMD phantomjs /home/phantomjs/ghostdriver/src/main.js --hub=$HUB --ip=`ip -4 addr show eth0| grep -Po 'inet \K[\d.]+'` --port=$PORT --remoteHost=$REMOTEHOST
