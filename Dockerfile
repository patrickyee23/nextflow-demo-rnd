FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        awscli \
        r-base \
    && rm -rf /var/lib/apt/lists/*
