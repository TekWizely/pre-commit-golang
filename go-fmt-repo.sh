#!/usr/bin/env bash
error_on_output=1
cmd=(gofmt -l -d)
target=(.)
. "$(dirname "${0}")/lib/cmd-repo.bash"
