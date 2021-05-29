#!/usr/bin/env bash

cmd=(revive)

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
for sub in $(find_module_roots "${FILES[@]}" | sort -u) ; do
	pushd "${sub}" >/dev/null
	"${cmd[@]}" "${OPTIONS[@]}" ./...
	if [ $? -ne 0 ]; then
		errCode=1
	fi
	popd >/dev/null
done
exit $errCode
