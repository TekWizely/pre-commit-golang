#!/usr/bin/env bash
cmd=(govulncheck)
printf_module_announce="\nChecking Module: %s\n\n"
. "$(dirname "${0}")/lib/cmd-mod.bash"
