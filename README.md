# Protoc + Docker
All inclusive protoc suite, powered by Docker and Alpine Linux.

## Introduce
- only support golang
-  Support go-micro generation

## What's included:
- protobuf 3.6.01
- gRPC 1.16.0

- Go related tools compiled with 1.8.1, gRPC support is built-in:
  - github.com/golang/protobuf/protoc-gen-go
  - github.com/micro/protoc-gen-micro

## Supported languages
- Go

## Usage
```
$ docker run --rm conciseliu/docker-protoc protoc --help
Usage: /usr/bin/protoc [OPTION] PROTO_FILES
```

Don't forget you need to bind mount your files:
```
$ docker run --rm -v $(pwd):$(pwd) -w $(pwd) conciseliu/docker-protoc protoc --go_out=./ --micro_out=./ *.proto 
```


## Image Size
The current image is about ~91mb