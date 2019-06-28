#!/usr/bin/env bash
set -e
for file in "$@"; do
	golint -set_exit_status "${file}"
done
