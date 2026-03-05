#!/usr/bin/env bash
# Use legacy binary name if it exists; otherwise use the new binary name.
if command -v gocritic >/dev/null 2>&1; then
  binary_name="gocritic"
else
  binary_name="go-critic"
fi

cmd=("$binary_name" check)
. "$(dirname "${0}")/lib/cmd-files.bash"
