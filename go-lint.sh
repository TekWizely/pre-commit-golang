#!/usr/bin/env bash
errCode=0
for file in "$@"; do
	golint -set_exit_status "${file}"
	if [ $? -ne 0 ]; then
		errCode=1
	fi
done
exit $errCode
