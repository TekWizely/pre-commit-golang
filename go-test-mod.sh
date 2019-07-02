#!/usr/bin/env bash

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
	  echo "${path}"
	done
}

errCode=0
for sub in $(find_module_roots "$@" | sort -u) ; do
	pushd "${sub}" >/dev/null
	go test ./...
	if [ $? -ne 0 ]; then
		errCode=1
	fi
	popd >/dev/null
done
exit $errCode
