#!/usr/bin/env bash
set -e
for file in "$@"; do
	gocritic check "${file}"
done
