setopt AUTO_CD 
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt HIST_SAVE_NO_DUPS
setopt PUSHD_SILENT

HISTFILE="${HOME}/.histfile"
HISTSIZE=5000
SAVEHIST=5000
export ZI="${HOME}/.zi" 

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


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
