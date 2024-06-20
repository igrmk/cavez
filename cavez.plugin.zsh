_cavez::log() {
	[[ "$CAVEZ_VERBOSE" == true ]] && printf "CAVEZ: " && printf "$@"
}

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

	# Deactivate the virtual environment on leaving a directory
	if {
		[[ -n "$_CAVEZ_AUTO_ACTIVATED_ENV" ]] &&
		[[ "$_CAVEZ_AUTO_ACTIVATED_ENV" == "$CONDA_PREFIX" ]] &&
		[[ "$CONDA_PREFIX" != "$found_env_dir" ]]
	}; then
		_cavez::log "Deactivating virtual environment %s...\n" "$CONDA_PREFIX"
		_cavez::conda_flavour deactivate
		unset _CAVEZ_AUTO_ACTIVATED_ENV
	fi

	# Forget that the environment has been activated if a user manually activates another one
	if {
		[[ -n "$_CAVEZ_AUTO_ACTIVATED_ENV" ]] &&
		[[ "$_CAVEZ_AUTO_ACTIVATED_ENV" != "$CONDA_PREFIX" ]]
	}; then
		unset _CAVEZ_AUTO_ACTIVATED_ENV
	fi

	# Activate the virtual environment on entering a directory
	if {
		[[ -n "$found_env_dir" ]] &&
		[[ "$_CAVEZ_AUTO_ACTIVATED_ENV" != "$found_env_dir" ]]
	}; then
		_cavez::log "Activating virtual environment %s...\n" "$found_env_dir"
		_cavez::conda_flavour activate "$found_env_dir"
		_CAVEZ_AUTO_ACTIVATED_ENV="$CONDA_PREFIX"
	fi
}

_cavez::auto_activate_conda_env

if [[ -z "$CAVEZ_SKIP_HOOK_INIT" || "$CAVEZ_SKIP_HOOK_INIT" != true ]]; then
	chpwd_functions+=(_cavez::auto_activate_conda_env)
else
	_cavez::log "Initialization skipped\n"
fi

alias cavez-activate='_cavez::conda_flavour activate ./"${CAVEZ_VENV_DIR_NAME:-.venv}"'
alias cavez-create-new-env='_cavez::conda_flavour create -p ./"${CAVEZ_VENV_DIR_NAME:-.venv}" && cavez-activate'

cavez-create-new-env-from-file() {
	_cavez::conda_flavour create -p ./"${CAVEZ_VENV_DIR_NAME:-.venv}" --file "$1" && cavez-activate
}

