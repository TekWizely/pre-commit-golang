#!/usr/bin/env bash
cmd=(revive)
if [ -f "revive.toml" ]; then
	cmd+=("-config=revive.toml")
fi
ignore_file_pattern_array=("revive.toml")
. "$(dirname "${0}")/lib/cmd-files.bash"
