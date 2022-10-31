# shellcheck shell=bash

# shellcheck source=./common.bash
. "$(dirname "${0}")/lib/common.bash"

prepare_file_hook_cmd "$@"

error_code=0
for file in "${FILES[@]}"; do
	if [ "${error_on_output:-}" -eq 1 ]; then
		output=$(/usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" "${file}" 2>&1)
		if [ -n "${output}" ]; then
			printf "%s\n" "${output}"
			error_code=1
		fi
	elif ! /usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" "${file}"; then
		error_code=1
	fi
done
exit $error_code
