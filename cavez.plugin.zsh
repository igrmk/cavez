_cavez::find_up() {
	[[ / == "$2" ]] && return 1 || [[ -e "$2/$1" ]] && echo "$2/$1" && return || _cavez::find_up "$1" "$(dirname "$2")"
}

if type conda > /dev/null; then
	alias _cavez::conda_implementation=conda
elif type mamba > /dev/null; then
	alias _cavez::conda_implementation=mamba
elif type micromamba > /dev/null; then
	alias _cavez::conda_implementation=micromamba
else
	alias _cavez::conda_implementation=conda
fi

_cavez::auto_activate() {
	local found="$(_cavez::find_up "${CAVEZ_VENV_DIR_NAME:-.venv}" "$PWD")"
	[[ -n "$found" ]] && local found="$(realpath "$found")"

	if [[ -n "$_CAVEZ_AUTO_ACTIVATED" ]] && [[ "$_CAVEZ_AUTO_ACTIVATED" != "$found" ]]; then
		_cavez::conda_implementation deactivate
		unset _CAVEZ_AUTO_ACTIVATED
	fi

	if [[ -n "$found" ]] && [[ "$_CAVEZ_AUTO_ACTIVATED" != "$found" ]]; then
		_cavez::conda_implementation activate "$found"
		export _CAVEZ_AUTO_ACTIVATED="$CONDA_PREFIX"
	fi
}

_cavez::auto_activate
chpwd_functions+=(_cavez::auto_activate)
