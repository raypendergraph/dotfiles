setopt AUTO_CD 
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt HIST_SAVE_NO_DUPS
setopt PUSHD_SILENT

HISTFILE="${HOME}/.histfile"
HISTSIZE=5000
SAVEHIST=5000

bindkey -v
fpath=(${ZDOTDIR}/.zfunc ${fpath})
zstyle :compinstall filename '${ZDOTDIR}/.zshrc'
zstyle ':completion:*' menu select

# Begin custom setup
_comp_options+=(globdots)

source "${ZDOTDIR}/aliases"
source "${ZDOTDIR}/setup.zsh"

# To prevent stupid untrusted paths warning. I don't control whene everyone calls compinit. 
if [[ $(uname) == "Darwin" ]]; then
   alias compinit='compinit -u -i'
fi
source "${HOME}/.zi/bin/zi.zsh"
(( ${+_comps} )) && _comps[zi]=_zi

source "${ZDOTDIR}/functions.zsh"
autoload -Uz compinit && compinit

# Enabling and setting git info var to be used in prompt config.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
# This line obtains information from the vcs.
zstyle ':vcs_info:git*' formats "(%b) "
precmd() {
    vcs_info
}
# Enable substitution in the prompt.
setopt prompt_subst

# Config for the prompt. PS1 synonym.
prompt='${vcs_info_msg_0_}%2/ $'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Prompt Configuration
# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
# Enable substitution in the prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd)
add-zsh-hook precmd vcs_info
# add ${vcs_info_msg_0} to the prompt
# e.g. here we add the Git information in red  
PROMPT='%1~ %F{red}${vcs_info_msg_0_}%f %# '

# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
