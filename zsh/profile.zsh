setopt interactivecomments

if [[ ! -o interactive ]]; then
    return
fi
get_parent_dir() {
    local path="$1"
    cd "$(dirname "$path")" >/dev/null 2>&1 && pwd
}
SCRIPT_DIR="$(get_parent_dir "${(%):-%x}")" # look into ${0:a:h}, unclear what difference is
#endregion
#region Prompt
function is_remote() {
    # Short circuit if possible
    if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        return 0
    fi

    # Step 2: Walk the process tree looking for sshd
    local pid=$$
    local ppid name

    while [[ "$pid" -ne 1 ]]; do
        # Get PPID and command name for the current PID
        read ppid name <<<"$(ps -e -o pid=,ppid=,comm= 2>/dev/null | awk -v pid="$pid" '$1 == pid { print $2, $3 }')"

        [[ -z "$ppid" ]] && break

        if [[ "$name" == "sshd" ]]; then
            return 0
        fi

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
#endregion
#region App options and aliases
if command -v batcat >/dev/null 2>&1; then
    alias bat='batcat'
fi
if command -v rg >/dev/null 2>&1; then
    rgConfigFile="$(realpath "$SCRIPT_DIR/../config/.ripgreprc")"
    export RIPGREP_CONFIG_PATH="$rgConfigFile"
fi
#endregion
#region Late commands
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi
#endregion
