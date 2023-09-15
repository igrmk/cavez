_cavez_find_up() {
	[[ / == "$2" ]] && return 1 || [[ -e "$2/$1" ]] && echo "$2/$1" && return || _cavez_find_up "$1" "$(dirname "$2")"
}

if type conda > /dev/null; then
	alias _cavez_conda_implementation=conda
elif type mamba > /dev/null; then
	alias _cavez_conda_implementation=mamba
elif type micromamba > /dev/null; then
	alias _cavez_conda_implementation=micromamba
else
	alias _cavez_conda_implementation=conda
fi

export _CAVEZ_AUTO_ACTIVATED=0

_cavez_auto_activate() {
	found="$(_cavez_find_up "${CAVEZ_VENV_DIR_NAME:-.venv}" "$PWD")"
	if [[ $? -eq 0 ]]; then
		if [[ "$_CAVEZ_AUTO_ACTIVATED" == 0 ]]; then
			_cavez_conda_implementation activate "$found"
			export _CAVEZ_AUTO_ACTIVATED=1
		fi
	elif [[ "$_CAVEZ_AUTO_ACTIVATED" == 1 ]]; then
		_cavez_conda_implementation deactivate
		export _CAVEZ_AUTO_ACTIVATED=0
	fi
}

_cavez_auto_activate
chpwd_functions+=(_cavez_auto_activate)
