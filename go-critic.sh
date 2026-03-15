#!/usr/bin/env bash

# Default to newer name
# If not found, but old name found, us it
# If neither found, leave newer for error reporting
gocritic_bin='go-critic'
if ! command -v go-critic &> /dev/null && command -v gocritic &> /dev/null; then
	gocritic_bin='gocritic'
fi

cmd=("${gocritic_bin}" check)
. "$(dirname "${0}")/lib/cmd-files.bash"
