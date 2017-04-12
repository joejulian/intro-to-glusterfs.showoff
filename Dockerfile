FROM alpine:latest
MAINTAINER Joe Julian <me@joejulian.name>

RUN apk update && apk upgrade && apk add ruby ruby-bundler git openssl openssl-dev ruby-dev gcc g++ libc-dev make cmake && rm -rf /var/cache/apk/*
RUN mkdir -p /src
WORKDIR /src

# loop until rubygems.org stops timing out
RUN echo -e "source 'https://rubygems.org'\ngem 'showoff', :git => 'https://github.com/puppetlabs/showoff.git'\n gem 'rack-contrib'" > Gemfile && \
    bundle config timeout 1 && \
    until bundle install --clean --jobs=8 --retry=50 --binstubs=/bin; do sleep 1; done

RUN git clone https://github.com/joejulian/intro-to-glusterfs.showoff.git
WORKDIR /src/intro-to-glusterfs.showoff

RUN apk del openssl-dev ruby-dev libc-dev musl-dev zlib-dev gmp-dev

ENTRYPOINT /bin/showoff serve
