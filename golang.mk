# This Makefile describes the behavior of a node that was written on golang.
include git.mk


# Get the go bin path.
GO := $(shell which go)
ifeq ($(GO),)
	# Case when bainary is not installed. We have target below for installing stable version.
	GO := /usr/local/go/bin/go
endif


# Set golang global env variables.
export GOPRIVATE=gitea.boomfunc.io,github.com/boomfunc


# Find source files (using find instead of wildcard resolves any depth issue).
GO_SOURCE_FILES := $(shell find * -type f -name '*.go')
GO_TEST_SOURCE_FILES := $(shell find * -type f -name '*_test.go')


.PHONY: golang-fmt
golang-fmt: $(GO) $(GO_SOURCE_FILES)
	#### Node( '$(NODE)' ).Call( '$@' )
	$(GO) fix ./...
	$(GO) fmt ./...
	$(GO) vet ./...


# Performance section. Testing, benchmarking, profiling, tracing, debugging, etc.
.PHONY: golang-test
golang-test: $(GO) $(GO_TEST_SOURCE_FILES)
	#### Node( '$(NODE)' ).Call( '$@' )
	$(GO) test -race -cover -coverprofile=coverage.out \
		-ldflags="$(foreach ldflag,$(GOLANG_TEST_LDFLAGS),-X '$(ldflag)')" \
		./...
	$(GO) tool cover -html=coverage.out -o=coverage.html


# Build and run section. Convert source code to executable and provide process.
# Provide multiple options for building (bin, lib, etc).

# Calculate build variables.
TIMESTAMP := $(shell date +%s)
VERSION := LOCAL


# Targets for building executable binaries.
$(BASE)-Linux-x86_64: $(GO) $(GO_SOURCE_FILES)
	#### Node( '$(NODE)' ).Call( '$@' )
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(GO) build \
		-v \
		-ldflags="$(foreach ldflag,$(GOLANG_BUILD_LDFLAGS),-X '$(ldflag)')" \
		-o $(BASE)-Linux-x86_64


# Targets for building golang plugin libraries.
$(BASE)-Linux-x86_64-plugin.so: $(GO) $(GO_SOURCE_FILES)
	#### Node( '$(NODE)' ).Call( '$@' )
	GOOS=linux GOARCH=amd64 $(GO) build \
		-v \
		-buildmode=plugin \
		-ldflags="$(foreach ldflag,$(GOLANG_BUILD_LDFLAGS),-X '$(ldflag)')" \
		-o $(BASE)-Linux-x86_64-plugin.so
