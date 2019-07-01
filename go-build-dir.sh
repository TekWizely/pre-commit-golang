#!/usr/bin/env bash
errCode=0
for sub in $(echo "$@" | xargs -n1 dirname | sort -u); do
	go build "./${sub}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
