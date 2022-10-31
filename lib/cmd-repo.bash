# shellcheck shell=bash

# shellcheck source=./common.bash
. "$(dirname "${0}")/lib/common.bash"

prepare_repo_hook_cmd "$@"

# Add target after options
#
if [[ ${#target[@]} -gt 0 ]]; then
	OPTIONS+=("${target[@]}")
fi
if [ "${error_on_output:-}" -eq 1 ]; then
	output=$(/usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" 2>&1)
	if [ -n "${output}" ]; then
		printf "%s\n" "${output}"
		exit 1
	fi
else
	/usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}"
fi
