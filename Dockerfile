FROM rust:buster as massbit-build

ARG COMMIT_SHA=unknown
ARG REPO_NAME=unknown
ARG BRANCH_NAME=unknown
ARG TAG_NAME=unknown

ADD .. /massbitprotocol
#    && cargo clean \    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
RUN cd /massbitprotocol \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libssl-dev libudev-dev zlib1g-dev libpq-dev \
    && rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && rustup component add rustfmt \
    && RUSTFLAGS="-g" cargo build --release \
    && strip -g  /massbitprotocol/target/release/chain-reader \
    && strip -g  /massbitprotocol/target/release/index-manager-main \
    && strip -g  /massbitprotocol/target/release/analytics
