#!/usr/bin/env zsh

# Environment
[[ -f $HOME/.env.sh ]] && source "$HOME/.env.sh"
export PATH

# Stop TRAMP (in Emacs) from hanging or term/shell from echoing back commands
if [[ $TERM == dumb || -n $INSIDE_EMACS ]]; then
  unsetopt zle prompt_cr prompt_subst
  whence -w precmd >/dev/null && unfunction precmd
  whence -w preexec >/dev/null && unfunction preexec
  PS1='$ '
fi

## Bootstrap interactive session
if [[ $TERM != dumb ]]; then

  # Enable Powerlevel10k instant prompt. Should stay close to the top of
  # ~/.config/zsh/.zshrc. Initialization code that may require console input
  # (password prompts, [y/n] confirmations, etc.) must go above this block;
  # everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  ## ZSH configuration

  ## History
  HISTORY_SUBSTRING_SEARCH_PREFIXED=1
  HISTORY_SUBSTRING_SEARCH_FUZZY=1
  HISTSIZE=100000   # Max events to store in internal history.
  SAVEHIST=100000   # Max events to store in history file.
  setopt BANG_HIST                 # History expansions on '!'
  setopt EXTENDED_HISTORY          # Include start time in history records
  setopt APPEND_HISTORY            # Appends history to history file on exit
  setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
  setopt SHARE_HISTORY             # Share history between all sessions.
  setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
  setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
  setopt HIST_IGNORE_ALL_DUPS      # Remove old events if new event is a duplicate
  setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
  setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
  setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
  setopt HIST_REDUCE_BLANKS        # Minimize unnecessary whitespace
  setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
  setopt HIST_BEEP                 # Beep when accessing non-existent history.
  ## Directories
  DIRSTACKSIZE=9
  unsetopt AUTO_CD            # Implicit CD slows down plugins
  setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
  setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
  setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
  unsetopt PUSHD_TO_HOME      # Don't push to $HOME when no argument is given.
  setopt CDABLE_VARS          # Change directory to a path stored in a variable.
  setopt MULTIOS              # Write to multiple descriptors.
  unsetopt GLOB_DOTS
  unsetopt AUTO_NAME_DIRS     # Don't add variable-stored paths to ~ list

  ## Plugin configuration

  ## Bootstrap zgenom
  export ZGEN_DIR="${ZGEN_DIR:-${XDG_DATA_HOME:-~/.local/share}/zgenom}"
  if [[ ! -d "$ZGEN_DIR" ]]; then
    # Use zgenom because zgen is no longer maintained
    echo "Installing jandamm/zgenom"
    git clone https://github.com/jandamm/zgenom "$ZGEN_DIR"
  fi

  source $ZGEN_DIR/zgenom.zsh
  zgenom autoupdate   # checks for updates every ~7 days
  if ! zgenom saved; then
    echo "Initializing zgenom"
    rm -frv $ZDOTDIR/*.zwc(N) \
            $ZDOTDIR/.*.zwc(N) \
            $XDG_CACHE_HOME/zsh \
            $ZGEN_INIT.zwc

    # Oh My Zsh
    zgenom ohmyzsh

    # Be extra careful about plugin load order, or subtle breakage can emerge.
    zgenom load agkozak/zsh-z
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-completions src
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load dxrcy/zsh-history-substring-search
    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom load hlissner/zsh-autopair autopair.zsh

    zgenom save

    # Must be explicit because zgenom compile might ignore symlinks
    zgenom compile \
      $ZDOTDIR/*(-.N) \
      $ZDOTDIR/.*(-.N) \
      $ZDOTDIR/completions/_*(-.N) \
      $DOTFILES_HOME/lib/zsh/*~*.zwc(.N)
  fi

  ## Dotfiles
  IS_BASH="false"
  IS_ZSH="true"

  # fzf
  [[ -f $HOME/.fzf.sh ]] && source "$HOME/.fzf.sh"

  # Aliases
  [[ -f $HOME/.aliases.sh ]] && source "$HOME/.aliases.sh"

  # Local settings
  [[ ! -f ~/.config/zsh/.zshrc.local ]] || source ~/.config/zsh/.zshrc.local

  unset IS_BASH
  unset IS_ZSH
  autopair-init

  ## Direnv
  # Hook up direnv, if available
  if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
  fi

  # To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
  [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
fi
