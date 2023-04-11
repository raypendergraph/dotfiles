
setopt AUTO_CD 
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt HIST_SAVE_NO_DUPS
setopt PUSHD_SILENT

fpath=(${ZDOTDIR}/completions ${fpath})
HISTFILE=~/.config/zsh/.histfile
HISTSIZE=5000
SAVEHIST=5000
bindkey -v

zstyle :compinstall filename '${ZDOTDIR}/.zshrc'

autoload -Uz compinit
compinit -i
# End of lines added by compinstall

# Begin custom setup
_comp_options+=(globdots)

source ${ZDOTDIR}/aliases
source ${ZDOTDIR}/scripts.zsh

# Setup Zi - installed with sh -c "$(curl -fsSL get.zshell.dev)" --
if [[ ! -f ${ZDOTDIR}/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "${ZDOTDIR}/.zi" && command chmod go-rwX "${ZDOTDIR}/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "${ZDOTDIR}/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "${ZDOTDIR}/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands


zi wait lucid for \
  atinit"ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
     z-shell/F-Sy-H \
  blockf \
     zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
     zsh-users/zsh-autosuggestions
