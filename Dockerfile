FROM ubuntu:14.04 AS unzipper

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    bsdtar

COPY . .

RUN bsdtar --strip-components=1 -xvf redis.zip -C redis

WORKDIR redis

FROM unzipper AS builder

RUN apt-get install -y --no-install-recommends \
    build-essential

RUN make


FROM builder AS tester

RUN apt-get install -y --no-install-recommends \
    tcl

RUN make test


FROM tester AS runner

WORKDIR src

EXPOSE 6379

ENTRYPOINT ./redis-server

