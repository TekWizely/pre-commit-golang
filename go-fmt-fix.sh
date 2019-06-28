#!/usr/bin/env bash
set -e
for file in "$@"; do
	gofmt -l -w "${file}"
done
