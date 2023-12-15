# Use a specific version of the official Golang Docker image
FROM golang:1.18 AS builder

# Set the working directory
WORKDIR /app

# Copy the source code into the container
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o golangcicdpipeline .

# Use a lightweight base image
FROM alpine:latest

# Install certificates for secure communication
RUN apk --no-cache add ca-certificates

# Set the working directory in the container
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/golangcicdpipeline .

# Declare the command to run the application
ENTRYPOINT ["./golangcicdpipeline"]
