#!/usr/bin/env bash
error_on_output=1
cmd=(goreturns -l -d .)
. "$(dirname "${0}")/lib/cmd-repo.bash"
