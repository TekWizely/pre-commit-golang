#!/usr/bin/env bash

tmpfile=$(mktemp -d /tmp/go-build.XXXXXX)
cmd=(go build -o ${tmpfile})

export GO111MODULE=off

OPTIONS=()
# If arg doesn't pass [ -f ] check, then it is assumed to be an option
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ] && [ ! -f "$1" ]; do
	OPTIONS+=("$1")
	shift
done

FILES=()
# Assume start of file list (may still be options)
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	FILES+=("$1")
	shift
done

# If '--' next, then files = options
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
		# Append to previous options
		#
		OPTIONS=("${OPTIONS[@]}" "${FILES[@]}")
		FILES=()
	fi
fi

# Any remaining arguments are assumed to be files
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
