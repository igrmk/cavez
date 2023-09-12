CAVEZ / Conda Automatic Virtual Environments for ZSH
====================================================

This is another tool that automatically switches a Python virtual environment based on the directory you are in.
This tool only works if the following assumptions are met:
  * The virtual environment is stored in the project directory
  * The virtual environment directory is named `.venv` by default,
    but you can specify a different name using the `CAVEZ_VENV_DIR_NAME` environment variable

Why another tool?

  * I use Micromamba implementation of Conda, which is rarely supported by other similar tools
  * I prefer to keep a virtual environment in the project directory,
    e.g. `micromamba create -c conda-forge -p ./.venv python=3.11`,
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