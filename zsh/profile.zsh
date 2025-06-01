setopt interactivecomments
IS_REMOTE=false
if pstree -p | grep -E --quiet --extended-regexp ".*sshd.*\($$\)"; then
  IS_REMOTE=true
fi

if [[ "$IS_REMOTE" == true ]]; then
  title="%n@%m: %~"
  prompt_core="%F{green}%n@%m%f:%F{12}%~%f"
else
  title="%n: %~"
  prompt_core="%F{green}%n%f:%F{12}%~%f"
fi

PROMPT="%{$(print -Pn '\e]0;'${title}'\a')%}${prompt_core}%# "