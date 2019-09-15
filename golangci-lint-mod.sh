#!/usr/bin/env bash

export GO111MODULE=on

# Walks up the file path looking for go.mod
#
function find_module_roots() {
	for arg in "$@" ; do
	  local path="${arg}"
	  if [ "${path}" == "" ]; then
	    path="."
	  elif [ -f "${path}" ]; then
	    path=$(dirname "${path}")
	  fi
	  while [ "${path}" != "." ] && [ ! -f "${path}/go.mod" ]; do
	    path=$(dirname "${path}")
	  done
	  if [ -f "${path}/go.mod" ]; then
	  	echo "${path}"
	  fi
	done
}

FILES=()

# Build file list while looking for optional argument marker
#
while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
	FILES+=("$1")
	shift
done

# Remove argument marker if present
#
if [ $# -gt 0 ]; then
	if [ "$1" == "-" ] || [ "$1" == "--" ]; then
		shift
	fi
fi

errCode=0
for sub in $(find_module_roots "${FILES}" | sort -u) ; do
	pushd "${sub}" >/dev/null
	golangci-lint run "$@" ./...
	if [ $? -ne 0 ]; then
		errCode=1
	fi
	popd >/dev/null
done
exit $errCode
