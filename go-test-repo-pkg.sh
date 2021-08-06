#!/usr/bin/env bash
# shellcheck disable=SC2034  # vars used by sourced script
error_on_output=0
cmd=(go test)
# shellcheck source=lib/cmd-repo-pkg.bash
. "$(dirname "${0}")/lib/cmd-repo-pkg.bash"
