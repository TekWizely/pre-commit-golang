#!/usr/bin/env bash
cmd=(revive)
if [ -f "revive.toml" ]; then
	cmd+=( "-config=revive.toml" )
fi
. "$(dirname "${0}")/lib/cmd-repo-mod.bash"
