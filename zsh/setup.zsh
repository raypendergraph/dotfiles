# A lock file for some heavy setup procedures. Each procedure installs other things so those things
# should be removed when the DOT_LOCK file is sourced. Sourcing it will delete it as well. Do this when you want to 
# re-setup the system. 
#

DOT_LOCK="${HOME}/.dotlock"
function setup {
   if [[ $(uname) == "Darwin" ]]; then
      alias compinit='compinit -u -i'
   fi

   # Setup Zi - installed with sh -c "$(curl -fsSL get.zshell.dev)" --
   ZI_DIR="${HOME}/.zi"
   if [ ! -f "${ZI_DIR}/bin/zi.zsh" ]; then
      print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
      command mkdir -p "${ZI_DIR}" && command chmod go-rwX "${ZI_DIR}"
      command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "${ZI_DIR}/bin" \
      && print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" \
      || print -P "%F{160}▓▒░ The clone has failed.%f%b"

      source "${ZI_DIR}/bin/zi.zsh"

      zi pack for system-completions
      zi pack for ls_colors
      zi pack for fzf

      echo "rm -rf ${ZI_DIR}" >> "${DOT_LOCK}"

   fi
   
   echo "rm ${DOT_LOCK}" >> "${DOT_LOCK}"

}

# If the lock file is in place don't do any of this.

if [[ ! -f "${DOT_LOCK}" ]]; then
   setup
fi 
