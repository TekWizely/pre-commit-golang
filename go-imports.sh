#!/usr/bin/env bash
# shellcheck disable=SC2034  # vars used by sourced script
error_on_output=1
cmd=(goimports -l -d)
# shellcheck source=lib/cmd-files.bash
. "$(dirname "${0}")/lib/cmd-files.bash"
