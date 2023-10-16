CAVEZ / Conda Automatic Virtual Environments for Zsh
====================================================

This is another tool that automatically switches a Python virtual environment based on the directory you are in.
This tool only works if the following assumptions are met:
  * The virtual environment is stored in the project directory
  * The virtual environment directory is named either `.venv`
    or the name you specified in `CAVEZ_VENV_DIR_NAME` environment variable

This tool works with conda, mamba, and micromamba.
You can specify the conda flavor in the CAVEZ_CONDA_FLAVOUR environment variable.
If this variable is not set, the tool will try to automatically detect which flavor is installed.

Why another tool?

  * I use Micromamba implementation of Conda, which is rarely supported by other similar tools
  * I prefer to keep a virtual environment in the project directory,
    e.g. `micromamba create -p ./.venv`,
    which is rarely supported by other similar tools as well
  * This implementation is dead simple
  * It doesn't override `cd`, which I find clumsy

Dependencies
------------

  * This is a plugin for Oh My Zsh, so the latter should be installed.
  * Any implementation of Conda should be installed, e.g. Conda itself, Mamba or Micromamba.

Installation
------------

[ZPlug](https://github.com/zplug/zplug)

    zplug "igrmk/cavez"

[Antigen](https://github.com/zsh-users/antigen)

    antigen bundle "igrmk/cavez"

[Zgen](https://github.com/tarjoilija/zgen)

    zgen load "igrmk/cavez"

[zinit](https://github.com/zdharma-continuum/zinit)

    zinit wait lucid for igrmk/cavez

[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

Copy this repository to `$ZSH_CUSTOM/plugins`, where `$ZSH_CUSTOM` is the directory with custom plugins of oh-my-zsh
[(read more)](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization/):

    git clone "https://github.com/igrmk/cavez.git" "$ZSH_CUSTOM/plugins/cavez"

Then add "cavez" to your plugins. For example, add this line to your `.zshrc`. Make sure it is **before** the line
`source $ZSH/oh-my-zsh.sh`.

    plugins+=(cavez)

Manual Installation
-------------------

Source the plugin shell script in your `~/.zshrc` profile. For example

    source $HOME/cavez/cavez.plugin.zsh

Thanks to Michael Aquilina for this project https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.
I've just copied installation instructions from it.

Configuration
-------------

| Environment variable  | Description                                                      |
| --------------------- | ---------------------------------------------------------------- |
| `CAVEZ_VENV_DIR_NAME` | The name of a directory containing a virtual environment         |
| `CAVEZ_VERBOSE`       | Report any actions performed by CAVEZ if the value equals "true" |

Powerlevel10k
-------------

If you are using the [Powerlevel10k](https://github.com/romkatv/powerlevel10k) Zsh theme and want to show only the important part of the Conda prefix, you can update your `~/.p10k.zsh` config file.
Override the following variable to do it:

    typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='$(
      if [[ "${CONDA_DEFAULT_ENV}" == */.venv ]]; then
        basename "${CONDA_DEFAULT_ENV%/.venv}"
      else
        printf "%s" "${CONDA_DEFAULT_ENV}"
      fi
    )'
