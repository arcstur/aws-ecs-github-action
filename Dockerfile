FROM rust:latest as builder
WORKDIR /app
COPY Cargo.toml .
COPY ./src/ ./src/
RUN cargo build --release

FROM debian:bullseye-slim
WORKDIR /app
RUN apt-get update && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/aws-ecs-fargate-action .
CMD ["./aws-ecs-fargate-action"]
