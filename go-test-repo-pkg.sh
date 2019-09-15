#!/usr/bin/env bash
set -e

export GO111MODULE=off

# '-' and '--' are optional argument markers for parity with file scripts
# Remove them if present
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
	fi
fi

go test "$@" ./...
