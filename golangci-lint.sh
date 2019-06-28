#!/usr/bin/env bash
set -e
for file in "$@"; do
	golangci-lint run "${file}"
done
