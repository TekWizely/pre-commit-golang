#!/usr/bin/env bash
set -e
for file in "$@"; do
	goreturns -p -l -w "${file}"
done
