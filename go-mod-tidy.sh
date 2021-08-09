#!/usr/bin/env bash
use_dot_dot_dot=0
cmd=(go mod tidy)
. "$(dirname "${0}")/lib/cmd-mod.bash"
