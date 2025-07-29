# shellcheck shell=bash

: "${use_dot_dot_dot:=1}"
: "${error_on_output:=0}"
: "${ignore_pattern_array:=}"
: "${ignore_file_pattern_array:=}"
: "${ignore_dir_pattern_array:=}"
ignore_dir_pattern_array+=("vendor")

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
# is_path_ignored_by_pattern
#
# Determines whether a given path matches an ignored pattern.
#
# Arguments:
#   $1 - The path to check against the ignored patterns.
#
# Globals:
#   ignore_pattern_array - An array of ignored file patterns used for matching.
#
# Returns:
#   0 (success) if the path matches an ignored file pattern and should be ignored.
#   1 (failure) otherwise.
#
is_path_ignored_by_pattern() {
	local path="$1"
	local pattern
	for pattern in "${ignore_pattern_array[@]}"; do
		# shellcheck disable=SC2254  # Patterns should be unquoted
		case "$path" in
			$pattern)
				return 0
				;;
		esac
	done

	return 1
}

##
# is_path_ignored_by_file_pattern
#
# Determines whether a given path matches an ignored file pattern.
#
# Arguments:
#   $1 - The path to check against the ignored patterns.  Assumed to be a full file path.
#
# Globals:
#   ignore_file_pattern_array - An array or string of ignored file patterns used for matching.
#
# Returns:
#   0 (success) if the path matches an ignored file pattern and should be ignored.
#   1 (failure) otherwise.
#
is_path_ignored_by_file_pattern() {
	local path="$1"
	local pattern
	for pattern in "${ignore_file_pattern_array[@]}"; do
		# If empty, then skip.  TODO Error?
		if [[ -z "$pattern" ]]; then
			continue
		fi
		# Rule: Pattern is just a filename (no slashes) → match against filename portion of path
		if [[ "$pattern" == "$(basename "$pattern")" ]]; then
			# shellcheck disable=SC2254  # Patterns should be unquoted
			case "$(basename "$path")" in
				$pattern)
					return 0
					;;
			esac
		else
			# If pattern starts with './' then normalize it to just '/'
			if [[ "$pattern" == ./* ]]; then
				pattern="${pattern#.}" # Remove leading '.'
			fi
			# Rule: Pattern starts with '/' → must match the beginning of the path
			if [[ "$pattern" == /* ]]; then
				pattern="${pattern#/}" # Remove leading slash
				# shellcheck disable=SC2254  # Patterns should be unquoted
				case "$path" in
					$pattern)
						return 0
						;;
				esac
			else
				# Rule: Pattern without leading slash → match anywhere in the path
				# shellcheck disable=SC2254  # Patterns should be unquoted
				case "$path" in
					$pattern | */$pattern)
						return 0
						;;
				esac
			fi
		fi
	done

	return 1
}

##
# is_path_ignored_by_dir_pattern
#
# Determines whether a given path matches an ignored directory pattern.
#
# Arguments:
#   $1 - The path to check against the ignored patterns.  Assumed to be a directory path (i.e. `$(dirname "${file}")`).
#        Accepts '', '.', '/' as 'root' directory for matching purposes.
#
# Globals:
#   ignore_dir_pattern_array - An array or string of ignored directory patterns used for matching.
#
# Returns:
#   0 (success) if the path matches an ignored directory pattern and should be ignored.
#   1 (failure) otherwise.
#
is_path_ignored_by_dir_pattern() {
	local path="$1"
	# If path = '' || '.' then assume '/' (root)
	if [[ -z "$path" || "$path" == '.' ]]; then
		path='/'
	fi
	local pattern
	for pattern in "${ignore_dir_pattern_array[@]}"; do
		# If empty, then skip.  TODO Error?
		if [[ -z "$pattern" ]]; then
			continue
		fi
		# If pattern = '/' || '.' || './' || '*' then it matches everything
		if [[ "$pattern" == '/' || "$pattern" == '.' || "$pattern" == './' || "$pattern" == "*" ]]; then
			return 0
		fi
		# If path is '/' and we didn't match above, then skip
		if [[ "$path" == '/' ]]; then
			continue
		fi
		# Trailing '/' is optional and (generally) assumed, so remove if present
		if [[ "$pattern" == */ ]]; then
			pattern="${pattern%/}" # Remove trailing slash
		fi
		# If pattern starts with './' then normalize it to just '/'
		if [[ "$pattern" == ./* ]]; then
			pattern="${pattern#.}" # Remove leading '.'
		fi
		# Rule: Pattern starts with '/' → must match the beginning of the path
		if [[ "$pattern" == /* ]]; then
			pattern="${pattern#/}" # Remove leading slash
			# shellcheck disable=SC2254  # Patterns should be unquoted
			case "$path" in
				$pattern | $pattern/*)
					return 0
					;;
			esac
		else
			# Rule: Pattern without leading slash → match anywhere in the path
			# shellcheck disable=SC2254  # Patterns should be unquoted
			case "$path" in
				$pattern | $pattern/* | */$pattern | */$pattern/*)
					return 0
					;;
			esac
		fi
	done

	return 1
}

##
# parse_file_hook_args
# Creates global vars:
#   ENV_VARS: List of variables to assign+export before invoking command
#   OPTIONS : List of options to pass to command
#   FILES   : List of files to process, filtered against ignored dir and pattern entries
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
			--hook:ignore-pattern=*)
				local ignore_pattern="${1#--hook:ignore-pattern=}"
				if [[ -n "${ignore_pattern}" ]]; then
					ignore_pattern_array+=("${ignore_pattern}")
				else
					printf "ERROR: Empty hook:ignore-pattern argument'\n" >&2
					exit 1
				fi
				shift
				;;
			--hook:ignore-file=*)
				local ignore_file="${1#--hook:ignore-file=}"
				if [[ -n "${ignore_file}" ]]; then
					ignore_file_pattern_array+=("${ignore_file}")
				else
					printf "ERROR: Empty hook:ignore-file argument'\n" >&2
					exit 1
				fi
				shift
				;;
			--hook:ignore-dir=*)
				local ignore_dir="${1#--hook:ignore-dir=}"
				if [[ -n "${ignore_dir}" ]]; then
					ignore_dir_pattern_array+=("${ignore_dir}")
				else
					printf "ERROR: Empty hook:ignore-dir argument'\n" >&2
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

	# Filter out ignored dir and pattern entries
	#
	FILES=()
	local file
	for file in "${all_files[@]}"; do
		local file_dir
		file_dir=$(dirname "${file}")
		if is_path_ignored_by_dir_pattern "${file_dir}" || is_path_ignored_by_file_pattern "${file}" || is_path_ignored_by_pattern "${file}"; then
			continue
		fi
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
			--hook:ignore-pattern=*)
				local ignore_pattern="${1#--hook:ignore-pattern=}"
				if [[ -n "${ignore_pattern}" ]]; then
					ignore_pattern_array+=("${ignore_pattern}")
				else
					printf "ERROR: Empty hook:ignore-pattern argument'\n" >&2
					exit 1
				fi
				shift
				;;
			--hook:ignore-dir=*)
				local ignore_dir="${1#--hook:ignore-dir=}"
				if [[ -n "${ignore_dir}" ]]; then
					ignore_dir_pattern_array+=("${ignore_dir}")
				else
					printf "ERROR: Empty hook:ignore-dir argument'\n" >&2
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
# NOTE: Assumes path-list has already been filtered by ignore-checks.
#
function find_module_roots() {
	local path
	for path in "$@"; do
		if [ "${path}" == "" ]; then
			path="."
		elif [ -f "${path}" ]; then
			path=$(dirname "${path}")
		fi
		while [ "${path}" != "." ] && [ ! -f "${path}/go.mod" ]; do
			path=$(dirname "${path}")
		done
		if [ -f "${path}/go.mod" ]; then
			# TODO pattern-ignore check for go.mod ?
			printf "%s\n" "${path}"
		fi
	done
}
