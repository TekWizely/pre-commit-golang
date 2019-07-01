#!/usr/bin/env bash
errCode=0
pkg=$(go list) # repo root package
for sub in $(echo "$@" | xargs -n1 dirname | sort -u); do
	go test "${pkg}/${sub}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
