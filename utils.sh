#!/bin/bash

args="$@"
user="$(whoami)"

function extractGui() {
    cmd="$@"
    gui=""
    for arg in $(echo $cmd); do
        [ "$arg" == "--gui" ] && gui=$arg && break;
    done

    echo $gui
}

function runAsRoot() {
    cmd="$@"
    if [ "$user" != "root" ]; then 
        if [ "$(extractGui $cmd)" == '--gui' ]; then
            exec pkexec bash -c "$cmd"
        else 
            exec sudo bash -c "$cmd"
        fi;
    fi;
}

function notRecognized {
    echo "action $1 was not recogninzed" && exit 1
}

function open {
    xdg-open $1
}

cliBin=/usr/bin/loginized-cli
completion=/etc/bash_completion.d
cliCompletion=$completion/loginized-cli-prompt

function installCli {
    cli=$(echo $1 | cut -d ',' -f 1)
    cliPrompt=$(echo $1 | cut -d ',' -f 2)

    #echo "$cli $cliPrompt"

    if [[ "$cli" != "" && "$cliPrompt" != "" ]]; then
        test ! -d $completion && mkdir -p $completion
        ln -s $cli $cliBin
        ln -s $cliPrompt $cliCompletion
    fi
}

function removeCli {
    unlink $cliBin
    unlink $cliCompletion
}

function main {
    case $1 in
        open)
            open $2
        ;;
        install-cli)
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                installCli $2
            fi;
        ;;
        remove-cli)
            runAsRoot $0 $args
            if [ "$user" == "root" ]; then
                removeCli $2
            fi;
        ;;
        *)
            notRecognized $1
        ;;
    esac
}

# extract gui from args
argList=""
for arg in $(echo $args); do
    [ $arg != "--gui" ] && argList="$argList $arg"
done

main $argList
