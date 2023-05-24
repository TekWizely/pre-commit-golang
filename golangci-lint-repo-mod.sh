#!/usr/bin/env bash
cmd=(golangci-lint run)
cmd_pwd_arg="--path-prefix"
. "$(dirname "${0}")/lib/cmd-repo-mod.bash"
