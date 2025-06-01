setopt interactivecomments
IS_REMOTE=0

if pstree -p | grep -qE "sshd.*\($$\)"; then
  IS_REMOTE=1
fi

if (( IS_REMOTE )); then
  title="%n@%m: %~"
  prompt_core="%F{green}%n@%m%f:%F{12}%~%f"
else
  title="%n: %~"
  prompt_core="%F{green}%n%f:%F{12}%~%f"
fi

PROMPT="%{$(print -Pn '\e]0;'${title}'\a')%}${prompt_core}%# "