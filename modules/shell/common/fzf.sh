if [ "$IS_ZSH" = "true" ]; then
  {{#if (eq DOD_DISTRIBUTION_NAME 'arch')}}
  source /usr/share/fzf/completion.zsh
  source /usr/share/fzf/key-bindings.zsh
  {{/if}}
  {{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
  source /usr/share/doc/fzf/examples/completion.zsh
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  {{/if}}
  {{#if (eq DOD_DISTRIBUTION_NAME 'fedora')}}
  source /usr/share/fzf/shell/key-bindings.zsh
  {{/if}}
fi

if [ "$IS_BASH" = "true" ]; then
  {{#if (eq DOD_DISTRIBUTION_NAME 'arch')}}
  source /usr/share/fzf/completion.bash
  source /usr/share/fzf/key-bindings.bash
  {{/if}}
  {{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
  source /usr/share/doc/fzf/examples/key-bindings.bash
  {{/if}}
  {{#if (eq DOD_DISTRIBUTION_NAME 'fedora')}}
  source /usr/share/fzf/shell/key-bindings.bash
  {{/if}}
fi

{{#if (or (eq DOD_DISTRIBUTION_NAME 'fedora') (eq DOD_DISTRIBUTION_NAME 'arch'))}}
export FZF_DEFAULT_COMMAND='fd -H -I'
{{/if}}
{{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
export FZF_DEFAULT_COMMAND='fdfind -H -I'
{{/if}}
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
{{#if (or (eq DOD_DISTRIBUTION_NAME 'fedora') (eq DOD_DISTRIBUTION_NAME 'arch'))}}
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_ALT_C_COMMAND='fd -H -I --type d'
export FZF_ALT_C_OPTS="--preview 'eza --long --tree --level=1 --color=auto --icons=auto --group-directories-first -- {}'"
{{/if}}
{{#if (eq DOD_DISTRIBUTION_NAME 'ubuntu')}}
export FZF_CTRL_T_OPTS="--preview '([[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'"
export FZF_ALT_C_COMMAND='fdfind -H -I --type d'
export FZF_ALT_C_OPTS="--preview 'exa --long --tree --level=1 --color=auto --icons --group-directories-first -- {}'"
{{/if}}
