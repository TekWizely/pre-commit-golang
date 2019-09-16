#!/usr/bin/env bash

cmd=(go test)

export GO111MODULE=off

FILES=()
# Build potential options list (may just be files)
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	FILES+=("$1")
	shift
done

OPTIONS=()
# If '--' next, then files = options
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
		OPTIONS=("${FILES[@]}")
		FILES=()
	fi
fi

# Any remaining items are files
#
while [ $# -gt 0 ]; do
	FILES+=("$1")
	shift
done

errCode=0
for sub in $(echo "${FILES[@]}" | xargs -n1 dirname | sort -u); do
	"${cmd[@]}" "${OPTIONS[@]}" "./${sub}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
