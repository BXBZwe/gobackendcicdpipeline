# We will use the official Golang Docker image
FROM golang:1.20-alpine AS builder

# Set the /app folder as the working directory
# All subsequent commands will be executed in this folder
WORKDIR /app

# Copy all files from the current directory
# where we run the docker build command
# into the /app folder in the Docker image
COPY . /app/

# Build the application within the Docker image
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o gocicd main.go

# Declare the final step
# Still use the official Golang Docker image
FROM golang:1.20-alpine

# Copy the build result from the previous step
# into the /usr/local/bin directory
COPY --from=builder ./app/ /usr/local/bin

# Declare the command to be executed when
# we run the 'docker run' command
ENTRYPOINT ["gocicd"]