#! /bin/bash

test -z $1 && echo Usage: 'ops/build.sh <tagging_version>' && exit 1

VERSION=$1

echo "Building alpine-elixir-phoenix:$VERSION..."

docker build --build-arg VERSION=$VERSION -t albertc/alpine-elixir-phoenix:$VERSION .
docker tag albertc/alpine-elixir-phoenix:$VERSION albertc/alpine-elixir-phoenix:$VERSION
