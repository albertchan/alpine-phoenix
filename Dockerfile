FROM elixir:1.6.5-alpine
MAINTAINER Albert Chan <atfchan@gmail.com>

ARG VERSION=1.3.0

RUN apk update add && \
  apk --no-cache --update add \
  git make g++ wget curl inotify-tools nodejs && \
  npm install npm -g --no-progress && \
  update-ca-certificates --fresh && \
  rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH=./node_modules/.bin:$PATH \
    MIX_HOME=/opt/mix \
    HEX_HOME=/opt/hex \
    HOME=/opt/app

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install Phoenix framework
RUN echo "Installing phoenixframework $VERSION..."
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-${VERSION}.ez

ENV APP_HOME /usr/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

CMD ["/bin/sh"]
