#!/usr/bin/env bash
. "${HOME_PATH}/colors.sh"
HOOKS=()
HOOKS+=(pre-commit)
HOOKS+=(prepare-commit-msg)
HOOKS+=(commit-msg)
HOOKS+=(post-commit)
HOOKS+=(pre-rebase)
HOOKS+=(post-rewrite)
HOOKS+=(post-checkout)
HOOKS+=(post-merge)
HOOKS+=(applypatch-msg)
HOOKS+=(post-update)
HOOKS+=(pre-applypatch)
HOOKS+=(pre-push)
HOOKS+=(pre-rebase)
HOOKS+=(update)
function inArray # hasKey:  inArray "myKey" "${!myArray[@]}"
{                #hasValue: inArray "myVal" "${myArray[@]}"
  local e
  for e in "${@:2}"; do
    [[ "$e" == "$1" ]] && return 0;
  done
  return 1
}
function fatal(){
    echo -e $@
    exit 1
}

COLS="$(tput cols)"
if (( COLS <= 0 )) ; then
    COLS="${COLUMNS:-80}"
fi

hr() {
    local WORD="$1"
    if [[ -n "$WORD" ]] ; then
        local LINE=''
        while (( ${#LINE} < COLS ))
        do
            LINE="$LINE$WORD"
        done

        echo "${LINE:0:$COLS}"
    fi
}

