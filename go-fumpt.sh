#!/usr/bin/env bash
error_on_output=1
cmd=(gofumpt -l -d)
. "$(dirname "${0}")/lib/cmd-files.bash"
