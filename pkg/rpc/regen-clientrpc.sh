#!/bin/sh

BINDIR=$(mktemp -d)

build_protoc_gen_go() {
    mkdir -p $BINDIR
    export GOBIN=$BINDIR
    go install github.com/golang/protobuf/protoc-gen-go
}

generate() {
    protoc --go_out=. --go-grpc_out=. poker.proto
}

# Build the bins from the main module, so that clientrpc doesn't need to
# require all client and tool dependencies.
(cd .. && build_protoc_gen_go)
GENPATH="$BINDIR:$PATH"
PATH=$GENPATH generate
