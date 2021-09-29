#!/bin/sh
dir=$(dirname $(realpath $0))

cd $dir/../src \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libssl-dev libudev-dev zlib1g-dev libpq-dev \
    && rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && rustup component add rustfmt \
    && RUSTFLAGS="-g" cargo build --release --target-dir $dir/target \
    && strip -g  $dir/target/release/chain-reader \
    && strip -g  $dir/target/release/index-manager-main \
    && strip -g  $dir/target/release/analytics
