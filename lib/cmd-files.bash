# shellcheck shell=bash

# shellcheck source=./common.bash
. "$(dirname "${0}")/lib/common.bash"

# shellcheck source=./prepare-go-tool.bash
. "$(dirname "${0}")/lib/prepare-go-tool.bash"

prepare_file_hook_cmd "$@"

error_code=0
# If batch_size=0, process all files in one go
if [ "${batch_size}" -eq 0 ]; then
	batch_size=${#FILES[@]}
fi

# Handle empty FILES to avoid infinite loop if batch_size is also 0
if [ ${#FILES[@]} -gt 0 ]; then
	for ((i = 0; i < ${#FILES[@]}; i += batch_size)); do
		batch=("${FILES[@]:i:batch_size}")
		if [ "${error_on_output:-}" -eq 1 ]; then
			output=$(/usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" "${batch[@]}" 2>&1)
			if [ -n "${output}" ]; then
				printf "%s\n" "${output}"
				error_code=1
			fi
		elif ! /usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" "${batch[@]}"; then
			error_code=1
		fi
	done
fi
exit $error_code
