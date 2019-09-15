#!/usr/bin/env bash

export GO111MODULE=off

FILES=()

# Build file list while looking for optional argument marker
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	FILES+=("$1")
	shift
done

# Remove argument marker if present
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
	fi
fi

errCode=0
for sub in $(echo "${FILES}" | xargs -n1 dirname | sort -u); do
	go test "$@" "./${sub}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
