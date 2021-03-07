#!/usr/bin/env bash
set -e

tmpfile=$(mktemp /tmp/go-build.XXXXXX)
cmd=(go build -o ${tmpfile})

export GO111MODULE=off

OPTIONS=()
# Build options list, ignoring '-', '--', and anything after
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	OPTIONS+=("$1")
	shift
done

"${cmd[@]}" "${OPTIONS[@]}" ./...
