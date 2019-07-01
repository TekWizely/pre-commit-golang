#!/usr/bin/env bash
errCode=0
for file in "$@"; do
	goreturns -p -l -w "${file}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
