#shellcheck shell=bash

# Do nothing if not running interactively
case $- in
    *i*) ;;
      *) return;;
esac

is_remote() {
  local pid=$$

  while [ "$pid" -ne 1 ]; do
    local name
    name=$(ps -p "$pid" -o comm=)
    if [ "$name" = "sshd" ]; then
      return 0
    fi
    pid=$(ps -p "$pid" -o ppid=)
  done
  return 1
}

if is_remote; then
  IS_REMOTE=1
else
  IS_REMOTE=0
fi

if (( IS_REMOTE )); then
  title="\u@\h: \w"
  prompt_core="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
else
  title="\u: \w"
  prompt_core="\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
fi

export PS1="\[\e]0;${title}\a\]${debian_chroot:+($debian_chroot)}${prompt_core}\\$ "
