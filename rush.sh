#!/bin/bash

if ! hash ansible-playbook 2>/dev/null; then
    echo -e "\nAnsible is not installed. See: http://docs.ansible.com/ansible/intro_installation.html\n"
    exit 1
fi

usage() {
    cat << EOF

Usage: $0 [option]
    
    Options:
        -r  Run the master playbook.
        -u  Update everything, overwriting all local changes.
        -s  Display the git status of everything.
        -h  Display usage.

EOF
}

hard_update_submodules() {
    git submodule foreach git fetch -a && \
    git submodule foreach git reset --hard && \
    git submodule foreach git pull
}

hard_update_all() {
    git fetch -a && \
    git reset --hard && \
    git pull && \
    hard_update_submodules
}

check_status_submodules() {
    git submodule foreach git fetch -a && \
    git submodule foreach git status
}

check_status_all() {
    git fetch -a && \
    git status && \
    check_status_submodules
}

run_playbook() {
    ANSIBLE_SSH_PIPELINING=True ansible-playbook -i hosts -u root master.yml
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

case "$1" in
    '-r')
        run_playbook
        ;;
    '-u')
        hard_update_all
        ;;
    '-s')
        check_status_all
        ;;
    *)
        usage
        exit 1
        ;;
esac
