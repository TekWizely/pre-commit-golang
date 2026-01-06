# shellcheck shell=bash
__USE_GO_TOOL=0
__GO_TOOL_ARGS=()
# Check for go-tool args
# Naked args can *only* appear at the FRONT
#
while [ $# -gt 0 ] && [ "$1" != "--" ]; do
	case "$1" in
		--go-tool)
			__USE_GO_TOOL=1
			shift
			;;
		--go-tool-mod=*)
			modfile="${1#--go-tool-mod=}"
			if [ -n "${modfile}" ]; then
				__USE_GO_TOOL=1
				__GO_TOOL_ARGS+=("-modfile=${modfile}")
			fi
			shift
			;;
		--go-tool-arg:*)
			arg="${1#--go-tool-arg:}"
			if [ -n "${arg}" ]; then
				__USE_GO_TOOL=1
				__GO_TOOL_ARGS+=("${arg}")
			fi
			shift
			;;
		*) # preserve positional arguments
			break
			;;
	esac
done
# '--hook:go-tool', '--hook:go-tool-mod', and '--hook:go-tool-arg' can appear anywhere before (the optional) '--'
# Anything else (including '--' and after) gets saved and passed to next step
# Positional order of saved arguments is preserved
#
__ARGS=()
while [ $# -gt 0 ] && [ "$1" != "--" ]; do
	case "$1" in
		--hook:go-tool)
			__USE_GO_TOOL=1
			shift
			;;
		--hook:go-tool-mod=*)
			modfile="${1#--go-tool-mod=}"
			if [ -n "${modfile}" ]; then
				__USE_GO_TOOL=1
				__GO_TOOL_ARGS+=("-modfile=${modfile}")
			fi
			shift
			;;
		--hook:go-tool-arg:*)
			arg="${1#--go-tool-arg:}"
			if [ -n "${arg}" ]; then
				__USE_GO_TOOL=1
				__GO_TOOL_ARGS+=("${arg}")
			fi
			shift
			;;
		*) # preserve positional arguments
			__ARGS+=("$1")
			shift
			;;
	esac
done
set -- "${__ARGS[@]}" "${@}"
unset __ARGS

# Prepend go tool invocation to start of cmd array
if [ "${__USE_GO_TOOL:-}" -eq 1 ]; then
	new_cmd=("go" "tool")

	# Go tool args
	if [ "${#__GO_TOOL_ARGS[@]}" -gt 0 ]; then
		new_cmd+=( "${__GO_TOOL_ARGS[@]}" )
	fi

	# Original cmd
	if [ "${#cmd[@]}" -gt 0 ]; then
		new_cmd+=( "${cmd[@]}" )
	fi

	# Set cmd to the new array
	cmd=( "${new_cmd[@]}" )

	unset new_cmd
fi

unset __USE_GO_TOOL
unset __GO_TOOL_ARGS
