_cavez::find_dir_up() {
	[[ / == "$2" ]] && return
	[[ -d "$2/$1" ]] && printf "%s\n" "$(realpath "$2/$1")" && return
	_cavez::find_dir_up "$1" "$(dirname "$2")"
}

_cavez::conda_flavour() {
	[[ -n "$CAVEZ_CONDA_FLAVOUR" ]] && ${CAVEZ_CONDA_FLAVOUR} "$@" && return
	type conda > /dev/null && conda "$@" && return
	type mamba > /dev/null && mamba "$@" && return
	type micromamba > /dev/null && micromamba "$@" && return
	echo "Cannot find any flavour of conda"
}

_cavez::auto_activate_conda_env() {
	local found_env_dir
	found_env_dir="$(_cavez::find_dir_up "${CAVEZ_VENV_DIR_NAME:-.venv}" "$PWD")"

	if [[ -n "$_CAVEZ_AUTO_ACTIVATED_ENV" ]] && [[ "$_CAVEZ_AUTO_ACTIVATED_ENV" != "$found_env_dir" ]]; then
		_cavez::conda_flavour deactivate
		unset _CAVEZ_AUTO_ACTIVATED_ENV
	fi

	if [[ -n "$found_env_dir" ]] && [[ "$_CAVEZ_AUTO_ACTIVATED_ENV" != "$found_env_dir" ]]; then
		_cavez::conda_flavour activate "$found_env_dir"
		export _CAVEZ_AUTO_ACTIVATED_ENV="$CONDA_PREFIX"
	fi
}

_cavez::auto_activate_conda_env
chpwd_functions+=(_cavez::auto_activate_conda_env)

alias cavez-create-new-env='micromamba create -p ./"${CAVEZ_VENV_DIR_NAME:-.venv}"'
