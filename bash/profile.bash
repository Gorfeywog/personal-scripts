#shellcheck shell=bash
IS_REMOTE=0

if pstree -p | grep -qE "sshd.*\($$\)"; then
  IS_REMOTE=1
fi

if (( IS_REMOTE )); then
  title="\u@\h: \w"
  prompt_core="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
else
  title="\u: \w"
  prompt_core="\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
fi

export PS1="\[\e]0;${title}\a\]${debian_chroot:+($debian_chroot)}${prompt_core}\\$ "