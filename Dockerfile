FROM rust:latest as build

# create a new empty shell project
RUN USER=root cargo new --bin osc-vmix
WORKDIR /osc-vmix

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
#RUN rm ./target/release/deps/osc-vmix*
RUN cargo build --release

# our final base
FROM rust:latest

# copy the build artifact from the build stage
COPY --from=build /osc-vmix/target/release/osc-vmix .

# set the startup command to run your binary
CMD "cargo run 0.0.0.0:5055 192.168.10.123:8088"