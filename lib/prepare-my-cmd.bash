# shellcheck shell=bash
use_dot_dot_dot=0
while (($#)); do
	case "$1" in
		--error-on-output)
			error_on_output=1
			shift
			;;
		*)
			break
			;;
	esac
done
cmd=()
if [ -n "${1:-}" ]; then
	cmd+=("${1}")
	shift
fi
