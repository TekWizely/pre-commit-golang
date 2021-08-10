#!/usr/bin/env bash
error_on_output=1
cmd=(eval echo "$PWD" " : ")
. "$(dirname "${0}")/lib/cmd-mod.bash"
