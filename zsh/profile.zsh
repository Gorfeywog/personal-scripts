setopt interactivecomments

if [[ ! -o interactive ]]; then
  return
fi

function is_remote() {
  local pid=$$
  local name ppid

  while [[ $pid -ne 1 ]]; do
    name=$(ps -p $pid -o comm= 2>/dev/null)
    if [[ "$name" == "sshd" ]]; then
      return 0
    fi
    ppid=$(ps -p $pid -o ppid= 2>/dev/null)
    [[ -z "$ppid" ]] && break
    pid=$ppid
  done

  return 1
}

if is_remote; then
  IS_REMOTE=1
else
  IS_REMOTE=0
fi

if (( IS_REMOTE )); then
  title="%n@%m: %~"
  prompt_core="%F{green}%n@%m%f:%F{12}%~%f"
else
  title="%n: %~"
  prompt_core="%F{green}%n%f:%F{12}%~%f"
fi

PROMPT="%{$(print -Pn '\e]0;'${title}'\a')%}${prompt_core}%# "
