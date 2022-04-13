# Build the executable
FROM rust:bullseye as builder
EXPOSE 5055/tcp
EXPOSE 5055/udp

WORKDIR /app

COPY Cargo.toml ./

RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs

RUN cargo build --release

COPY ./src ./src

RUN touch src/main.rs
RUN cargo build --release

# == == ==
# Copy the executable and extra files ("static") to an empty Docker image
FROM debian:bullseye
COPY --from=builder /app/target/release/ ./app
CMD [ "./app/osc-vmix","0.0.0.0:5055","192.168.10.123:8088" ]