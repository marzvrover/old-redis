FROM ubuntu:14.04 AS builder

COPY . .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libjemalloc-dev

RUN make


FROM builder AS tester

RUN apt-get install -y --no-install-recommends \
    tcl

RUN make test


FROM tester AS runner

WORKDIR src

EXPOSE 6379

ENTRYPOINT ./redis-server

# CMD tail -f /dev/null
