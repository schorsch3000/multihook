#!/usr/bin/env bash

HOME_PATH="$(dirname "$(realpath "$0")")"
. "${HOME_PATH}/utils.sh"
if [ "${MULTI_HOOKS}" != "ENABLE" ]; then
    echo -e ${FC_RED}${S_BOLD}MULTI_HOOKS${R_BOLD} is not set to ${S_BOLD}'ENABLE'${R_BOLD}, we are going to stop here.${FC_DEFAULT}
    echo You may use something like direnv to enable multihooks per dir.
    exit
fi
GIT_ROOT="$(realpath "$(git rev-parse --show-toplevel)")"
test -d "$GIT_ROOT" || fatal ${FC_RED}This is not within a git repository${FC_DEFAULT}
test -f ${GIT_ROOT}/hooks.ini || fatal ${FC_RED}There is no ${S_BOLD}hooks.ini${R_BOLD} in ${S_BOLD}"${GIT_ROOT}"${R_BOLD}${FC_DEFAULT}

HOOK_NAME="$(basename "$0")"
inArray "${HOOK_NAME}" "${HOOKS[@]}" || fatal ${FC_RED}Hook ${S_BOLD}"'$HOOK_NAME'"${R_BOLD} unknown${FC_DEFAULT}

echo -e ${FC_GREEN}Running hooks for $HOOK_NAME${FC_YELLOW}
hr -

INI_START_LINE="$(grep -n "${HOOK_NAME}" hooks.ini | sed 's/:.*//')"
echo $INI_START_LINE | grep -q [0-9] || exit 0
SECTION_STARTED=no
LN=0
(cat ${GIT_ROOT}/hooks.ini; echo)| while read line; do
    if [ "$LN" -eq "$INI_START_LINE" ] ; then
        SECTION_STARTED=yes
        ((LN++))
    else
        if [ "$SECTION_STARTED" == "no" ] ; then
            ((LN++))
            continue;
        fi
    fi
    echo $line | egrep -q '^\[' && break

    key=$(echo $line | sed 's/=.*//' | xargs)
    val=$(echo $line | sed 's/^[^=]*=//' | xargs)
    echo $line | grep -q "^#"  && continue
    echo $line | grep -q "^$"  && continue
    if [ $# -eq 0 ] ; then
    echo -e ${FC_GREEN}$key\(${FC_YELLOW}\`${val}\`${FC_GREEN}\):${FC_DEFAULT}
    else
        echo -e ${FC_GREEN}$key\(${FC_YELLOW}\`${val} "$@"\`${FC_GREEN}\):${FC_DEFAULT}
    fi;
    echo
    $val "$@"

    RETVAL=$?
    if [ $RETVAL -ne 0 ] ; then
        echo -e ${FC_RED}Command ${S_BOLD}"'${val}'"${R_BOLD} failed with exit code: ${S_BOLD}${RETVAL}${R_BOLD}${FC_DEFAULT}
        exit ${RETVAL}
    fi
    echo -e ${FC_YELLOW}
    hr -
    echo -en ${FC_DEFAULT}
done
echo -en ${FC_DEFAULT}${R_BOLD}
exit 0