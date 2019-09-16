#!/usr/bin/env bash

cmd=(goimports -l -d)

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
for file in "${FILES[@]}"; do
	output=$("${cmd[@]}" "${OPTIONS[@]}" "${file}" 2>&1)
	if [ ! -z "${output}" ]; then
		echo -n "${output}"
		errCode=1
	fi
done
exit $errCode
