#!/usr/bin/env bash

cmd=(go vet)

export GO111MODULE=on

OPTIONS=()
# Build options list, ignoring '-', '--', and anything after
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	OPTIONS+=("$1")
	shift
done

errCode=0
# Assume parent folder of go.mod is module root folder
#
for sub in $(find . -name go.mod | xargs -n1 dirname | sort -u) ; do
	pushd "${sub}" >/dev/null
	"${cmd[@]}" "${OPTIONS[@]}" ./...
	if [ $? -ne 0 ]; then
		errCode=1
	fi
	popd >/dev/null
done
exit $errCode
