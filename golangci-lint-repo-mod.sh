#!/usr/bin/env bash

export GO111MODULE=on

# '-' and '--' are optional argument markers for parity with file scripts
# Remove them if present
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
	fi
fi

errCode=0
# Assume parent folder of go.mod is module root folder
#
for sub in $(find . -name go.mod | xargs -n1 dirname | sort -u) ; do
	pushd "${sub}" >/dev/null
	golangci-lint run "$@" ./...
	if [ $? -ne 0 ]; then
		errCode=1
	fi
	popd >/dev/null
done
exit $errCode
