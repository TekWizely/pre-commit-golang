# shellcheck shell=bash

# shellcheck source=./common.bash
. "$(dirname "${0}")/lib/common.bash"

prepare_repo_hook_cmd "$@"

if [ "${use_dot_dot_dot:-}" -eq 1 ]; then
	OPTIONS+=('./...')
fi
export GO111MODULE=on
error_code=0
# Assume parent folder of go.mod is module root folder
#
for file in $(find . -name go.mod | sort -u); do
  if is_path_ignored_by_dir_pattern "${file}" || is_path_ignored_by_file_pattern "${file}"; then
    continue
  fi
  sub=$(dirname "${file}")
	pushd "${sub}" > /dev/null || exit 1
	if [ "${error_on_output:-}" -eq 1 ]; then
		output=$(/usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}" 2>&1)
		if [ -n "${output}" ]; then
			printf "%s\n" "${output}"
			error_code=1
		fi
	elif ! /usr/bin/env "${ENV_VARS[@]}" "${cmd[@]}" "${OPTIONS[@]}"; then
		error_code=1
	fi
	popd > /dev/null || exit 1
done
exit $error_code
