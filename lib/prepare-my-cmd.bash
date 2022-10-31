# shellcheck shell=bash
use_dot_dot_dot=0
# Check for error-on-output
# '--error-on-output' can *only* appear at the FRONT
# !! NOTE: This is DEPRECATED and will be removed in a future version !!
#
if [[ "${1:-}" == "--error-on-output" ]]; then
	error_on_output=1
	shift
fi
# '--hook:error-on-output' can appear anywhere before (the optional) '--'
# Anything else (including '--' and after) gets saved and passed to next step
# Positional order of saved arguments is preserved
#
_ARGS=()
while [ $# -gt 0 ] && [ "$1" != "--" ]; do
	case "$1" in
		--hook:error-on-output)
			error_on_output=1
			# We continue (vs break) in order to consume multiple occurrences
			# of the arg. VERY unlikely but let's be safe.
			#
			shift
			;;
		*) # preserve positional arguments
			__ARGS+=("$1")
			shift
			;;
	esac
done
set -- "${__ARGS[@]}" "${@}"
unset __ARGS

cmd=()
if [ -n "${1:-}" ]; then
	cmd+=("${1}")
	shift
fi
