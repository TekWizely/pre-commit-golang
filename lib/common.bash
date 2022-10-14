# shellcheck shell=bash

: "${use_dot_dot_dot:=1}"
: "${error_on_output:=0}"
: "${ignore_file_pattern_array:=}"

##
# prepare_file_hook_cmd
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
#   ENV_VARS: List of variables to assign+export before invoking command
#   OPTIONS : List of options to pass to command
#   FILES   : List of files to process, filtered against ignore_file_pattern_array
#
# NOTE: We consume the first (optional) '--' we encounter.
#       If you want to pass '--' to the command, you'll need to use 2 of them
#       in hook args, i.e. "args: [..., '--', '--']"
#
function parse_file_hook_args {
	# Look for '--hook:*' options up to the first (optional) '--'
	# Anything else (including '--' and after) gets saved and passed to next step
	# Positional order of saved arguments is preserved
	#
	local ENV_REGEX='^[a-zA-Z_][a-zA-Z0-9_]*=.*$'
	ENV_VARS=()
	local __ARGS=()
	while [ $# -gt 0 ] && [ "$1" != "--" ]; do
		case "$1" in
			--hook:env:*)
				local env_var="${1#--hook:env:}"
				if [[ "${env_var}" =~ ${ENV_REGEX} ]]; then
					ENV_VARS+=("${env_var}")
				else
					printf "ERROR: Invalid hook:env variable: '%s'\n" "${env_var}" >&2
					exit 1
				fi
				shift
				;;
			--hook:*)
				printf "ERROR: Unknown hook option: '%s'\n" "${1}" >&2
				exit 1
				;;
			*) # preserve positional arguments
				__ARGS+=("$1")
				shift
				;;
		esac
	done
	set -- "${__ARGS[@]}" "${@}"
	unset __ARGS
	OPTIONS=()
	# If arg doesn't pass [ -f ] check, then it is assumed to be an option
	#
	while [ $# -gt 0 ] && [ "$1" != "--" ] && [ ! -f "$1" ]; do
		OPTIONS+=("$1")
		shift
	done

	local all_files
	all_files=()
	# Assume start of file list (may still be options)
	#
	while [ $# -gt 0 ] && [ "$1" != "--" ]; do
		all_files+=("$1")
		shift
	done

	# If '--' next, then files = options
	# NOTE: We consume the '--' here
	#
	if [ "$1" == "--" ]; then
		shift
		# Append to previous options
		#
		OPTIONS+=("${all_files[@]}")
		all_files=()
	fi

	# Any remaining arguments are assumed to be files
	#
	all_files+=("$@")

	# Filter out vendor entries and ignore_file_pattern_array
	#
	FILES=()
	local file pattern
	ignore_file_pattern_array+=( "vendor/*" "*/vendor/*" "*/vendor" )
	for file in "${all_files[@]}"; do
		for pattern in "${ignore_file_pattern_array[@]}"; do
			if [[ "${file}" == ${pattern} ]] ; then # pattern => unquoted
				continue 2
			fi
		done
		FILES+=("${file}")
	done
}

##
# parse_repo_hook_args
# Creates global vars:
#   ENV_VARS: List of variables to assign+export before invoking command
#   OPTIONS : List of options to pass to command
#
# NOTE: For consistency with file hooks,
#       we consume the first (optional) '--' we encounter.
#       If you want to pass '--' to the command, you'll need to use 2 of them
#       in hook args, i.e. "args: [..., '--', '--']"
#
function parse_repo_hook_args {
	# Look for '--hook:*' options up to the first (optional) '--'
	# Consumes the first '--', treating anything after as OPTIONS
	# Positional order of OPTIONS is preserved
	#
	local ENV_REGEX='^[a-zA-Z_][a-zA-Z0-9_]*=.*$'
	ENV_VARS=()
	OPTIONS=()
	while [ $# -gt 0 ]; do
		case "$1" in
			--hook:env:*)
				local env_var="${1#--hook:env:}"
				if [[ "${env_var}" =~ ${ENV_REGEX} ]]; then
					ENV_VARS+=("${env_var}")
				else
					printf "ERROR: Invalid hook:env variable: '%s'\n" "${env_var}" >&2
					exit 1
				fi
				shift
				;;
			--hook:*)
				printf "ERROR: Unknown hook option: '%s'\n" "${1}" >&2
				exit 1
				;;
			--) # consume '--' and stop loop
				shift
				break
				;;
			*) # preserve positional arguments
				OPTIONS+=("$1")
				shift
				;;
		esac
	done
	# Any remaining items also considered OPTIONS
	#
	OPTIONS+=("$@")
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
