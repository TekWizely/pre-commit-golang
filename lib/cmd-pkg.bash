# shellcheck shell=bash

. "$(dirname "${0}")/lib/common.bash"

prepare_file_hook_cmd "$@"

export GO111MODULE=off
error_code=0
for sub in $(printf "%q\n" "${FILES[@]}" | xargs -n1 dirname | sort -u); do
	if [ "${error_on_output:-}" -eq 1 ]; then
		output=$("${cmd[@]}" "${OPTIONS[@]}" "./${sub}" 2>&1)
		if [ -n "${output}" ]; then
			printf "%s\n" "${output}"
			error_code=1
		fi
	elif ! "${cmd[@]}" "${OPTIONS[@]}" "./${sub}"; then
		error_code=1
	fi
done
exit $error_code
