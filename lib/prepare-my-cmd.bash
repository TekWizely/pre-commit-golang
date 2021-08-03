# shellcheck shell=bash
# shellcheck disable=SC2034  # vars used by lib/cmd-* scripts
error_on_output=0
if [ "${1:-}" == "--error-on-output" ]; then
	error_on_output=1
	shift
fi
cmd=()
if [ -n "${1:-}" ]; then
	cmd+=("${1}")
	shift
fi
