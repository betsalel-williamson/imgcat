FROM rust:1.89.0-alpine AS builder

ENV RUSTFLAGS="-C target-feature=-crt-static"
RUN apk update
RUN apk add --no-cache musl-dev
RUN apk add curl
WORKDIR /app
RUN apk add lld clang
# leverage a bind mount to avoid having to copy the source in here, letting us run without actually copying the code.
# This just downloads and builds our expected crates during the container creation instead of when we first run.
RUN --mount=type=bind,source=src,target=src \
    --mount=type=bind,source=Cargo.toml,target=Cargo.toml \
    --mount=type=bind,source=Cargo.lock,target=Cargo.lock \
    --mount=type=cache,target=/app/target/ \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    cargo build --release

FROM builder AS dev
CMD ["cargo", "run"]

FROM rust:1.89.0 AS builder-prod
RUN strip target/release/imgcat

FROM rust:1.89.0-alpine AS runtime
RUN apk add --no-cache libgcc
# app specific environment variables
ENV APP_ENVIRONMENT=prod
# copy the binary, and config folders
COPY --from=builder /app/target/release/imgcat .

ENTRYPOINT ["/imgcat"]