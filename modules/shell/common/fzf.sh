{{#if (eq DOD_DISTRIBUTION_NAME 'gentoo')}}
if [ "$IS_ZSH" = "true" ]; then
    source /usr/share/zsh/site-functions/_fzf
    source /usr/share/fzf/key-bindings.zsh
fi

if [ "$IS_BASH" = "true" ]; then
    source /usr/share/bash-completion/completions/fzf
    source /usr/share/fzf/key-bindings.bash
fi
{{/if}}
{{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
if [ "$IS_ZSH" = "true" ]; then
    source /usr/share/doc/fzf/examples/completion.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

if [ "$IS_BASH" = "true" ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
{{/if}}

{{#if (eq DOD_DISTRIBUTION_NAME 'gentoo')}}
export FZF_DEFAULT_COMMAND='fd -H -I'
{{/if}}
{{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
export FZF_DEFAULT_COMMAND='fdfind -H -I'
{{/if}}
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
{{#if (eq DOD_DISTRIBUTION_NAME 'gentoo')}}
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_ALT_C_COMMAND='fd -H -I --type d'
export FZF_ALT_C_OPTS="--preview 'eza --long --tree --level=1 --color=auto --icons=auto --group-directories-first -- {}'"
{{/if}}
{{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_ALT_C_COMMAND='fdfind -H -I --type d'
export FZF_ALT_C_OPTS="--preview 'exa --long --tree --level=1 --color=auto --icons --group-directories-first -- {}'"
{{/if}}
