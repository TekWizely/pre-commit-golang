# shellcheck shell=bash

: "${use_dot_dot_dot:=1}"
: "${error_on_output:=0}"

##
# prepare_repo_hook_cmd
#
function prepare_file_hook_cmd {
	verify_hook_cmd
	parse_file_hook_args "$@"
}

##
# prepare_repo_hook_cmd
#
function prepare_repo_hook_cmd {
	verify_hook_cmd
	parse_repo_hook_args "$@"
}

##
# verify_hook_cmd
#
function verify_hook_cmd {
	# shellcheck disable=SC2154  # Fails if not defined by caller
	if [[ ${#cmd[@]} -eq 0 ]]; then
		printf "error: no command provided" >&2
		exit 1
	fi
	if ! type "${cmd[0]}" &> /dev/null; then
		printf "error: command not found: %s" "${cmd[0]}" >&2
		exit 1
	fi
}

##
# parse_file_hook_args
# Creates global vars:
#   OPTIONS: List of options to passed to comand
#   FILES  : List of files to process
#
function parse_file_hook_args {
	OPTIONS=()
	# If arg doesn't pass [ -f ] check, then it is assumed to be an option
	#
	while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ] && [ ! -f "$1" ]; do
		OPTIONS+=("$1")
		shift
	done

	local all_files
	all_files=()
	# Assume start of file list (may still be options)
	#
	while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
		all_files+=("$1")
		shift
	done

	# If '--' next, then files = options
	#
	if [ $# -gt 0 ]; then
		if [ "$1" == "-" ] || [ "$1" == "--" ]; then
			shift
			# Append to previous options
			#
			OPTIONS+=("${all_files[@]}")
			all_files=()
		fi
	fi

	# Any remaining arguments are assumed to be files
	#
	while [ $# -gt 0 ]; do
		all_files+=("$1")
		shift
	done

	# Filter out vendor entries
	#
	FILES=()
	local file
	for file in "${all_files[@]}"; do
		if [[ "${file}" == "vendor/"* || "${file}" == *"/vendor/"* || "${file}" == *"/vendor" ]]; then
			continue
		fi
		FILES+=("${file}")
	done
}

##
# parse_repo_hook_args
# Build options list, ignoring '-', '--', and anything after
#
function parse_repo_hook_args {
	OPTIONS=()
	while [ $# -gt 0 ] && [ "$1" != "-" ] && [ "$1" != "--" ]; do
		OPTIONS+=("$1")
		shift
	done
}

##
# find_module_roots
# Walks up the file path looking for go.mod
# Prunes paths with /vendor/ in them
#
function find_module_roots() {
	local path
	for path in "$@"; do
		if [[ "${path}" == "vendor/"* || "${path}" == *"/vendor/"* || "${path}" == *"/vendor" ]]; then
			continue
		fi
		if [ "${path}" == "" ]; then
			path="."
		elif [ -f "${path}" ]; then
			path=$(dirname "${path}")
		fi
		while [ "${path}" != "." ] && [ ! -f "${path}/go.mod" ]; do
			path=$(dirname "${path}")
		done
		if [ -f "${path}/go.mod" ]; then
			printf "%s\n" "${path}"
		fi
	done
}
