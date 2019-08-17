#/usr/bin/env bash

prefix="content/posts/" # the directory from where to start

RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

_hued () {
    # Ref: https://askubuntu.com/a/707643
    local cur
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    k=0
    for j in $( compgen -f "${prefix}/${cur}" ); do # loop trough the possible completions
        [ -d "${j}" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
        COMPREPLY[k++]=${j#$prefix/} # remove the directory prefix from the array
    done
    return 0
}

hued () {
    if [[ $1 = "--help" ]] || [[ $# -eq 0 ]]; then
        echo -e "usage: hued <filename>."
        echo -e "The <filename> need under \"${prefix}\" dir."
        echo -e "\ne.g, hued ouo.md"
        return 0
    fi
    if [ ! -d "./${prefix}" ]; then
        echo -e "${RED}error: \"${prefix}\" dir not found${NC}"
        return 1
    fi
    filename=$@
    # Add prefix directory name
    # Ref: https://stackoverflow.com/a/38558776/6734174
    set -- "${@/#/${prefix}}"
    if [ ! -f $@ ]; then
        echo -e "${GREEN}hugo new posts/${filename}${NC}"
        hugo new "posts/${filename}"
    fi
    if [[ -n $@ ]]; then
        vim "$@"
        echo "< vim" $@ " >"
    fi
}

complete -o default -F _hued hued
