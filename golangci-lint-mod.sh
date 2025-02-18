#!/usr/bin/env bash
cmd=(golangci-lint run)
cmd_cwd_arg="--path-prefix={{sub}}"
. "$(dirname "${0}")/lib/cmd-mod.bash"
