#/usr/bin/env bash

prefix="content/posts/" # the directory from where to start

_hued () {
    # Ref: https://askubuntu.com/a/707643
    local cur
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    k=0
    for j in $( compgen -f "$prefix/$cur" ); do # loop trough the possible completions
        [ -d "$j" ] && j="${j}/" || j="${j} " # if its a dir add a shlash, else a space
        COMPREPLY[k++]=${j#$prefix/} # remove the directory prefix from the array
    done
    return 0
}

hued () {
    if [[ $1 = "--help" ]] || [[ $# -eq 0 ]]; then
        echo -e "usage: hued <filename>.\n\ne.g, hued ouo.md"
        return 0
    fi
    # Add prefix directory name
    # Ref: https://stackoverflow.com/a/38558776/6734174
    set -- "${@/#/${prefix}}"
    if [[ -n $@ ]]; then
        vim "$@"
    fi
}

complete -o default -F _hued hued
