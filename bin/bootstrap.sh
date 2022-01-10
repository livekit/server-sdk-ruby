#!/usr/bin/env bash

echo "Ensure protoc and Go are installed"

go install github.com/twitchtv/twirp-ruby/protoc-gen-twirp_ruby@latest
