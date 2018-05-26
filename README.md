# Elixir/Phoenix on Alpine Linux

This Dockerfile provides everything you need to run your Phoenix application in Docker out of the box.

It is based on the `elixir:alpine` image, and installs Elixir, Node.js, Hex and Rebar. It can handle compiling your Node and Elixir dependencies as part of it's build.

## Building

As a convenience, you can use the build script to build the `alpine-elixir-phoenix` image locally.

```sh
$ bin/build.sh <tagging_version>

# e.g. building phoenix:1.3.0
$ bin/build.sh 1.3.0
```

## Usage

NOTE: This image is intended to run in unprivileged environments, it sets the home directory to `/usr/app`, and makes it globally
read/writeable. If run with a random, high-index user account (say 1000001), the user can run an app, and that's about it. If run
with a user of your own creation, this doesn't apply (necessarily, you can of course implement the same behaviour yourself).
It is highly recommended that you add a `USER default` instruction to the end of your Dockerfile so that your app runs in a non-elevated context.

To boot straight to a prompt in the image:

```
$ docker run --rm -it --user=1000001 albertc/alpine-elixir-phoenix iex
Erlang/OTP 20 [erts-9.3.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.6.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)>
```

Extending for your own application:

```dockerfile
# Dockerfile
FROM albertc/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix do compile, phx.digest

USER default

CMD ["mix", "phx.server"]
```

It is recommended when using this that you have the following in `.dockerignore` when running `docker build`:

```
_build
deps
assets/node_modules
test
```

This will keep the payload smaller and will also avoid any issues when compiling dependencies.

## License

MIT