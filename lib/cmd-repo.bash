# shellcheck shell=bash

. "$(dirname "${0}")/lib/common.bash"

prepare_repo_hook_cmd "$@"

if [ "${error_on_output:-}" -eq 1 ]; then
	output=$("${cmd[@]}" "${OPTIONS[@]}" 2>&1)
	if [ -n "${output}" ]; then
		echo -n "${output}"
		echo "" # newline
		exit 1
	fi
else
	"${cmd[@]}" "${OPTIONS[@]}"
fi
