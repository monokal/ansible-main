#!/bin/bash

precheck() {
  if ! hash ansible-playbook > /dev/null 2>&1; then
      echo -e "\nAnsible is not installed. See: http://docs.ansible.com/ansible/intro_installation.html\n"
      exit 1
  fi
}

usage() {
    cat << EOF

Usage: $0 [option]
    
    Options:
        -c | --check       Run the master playbook but make no changes.
        -r | --run         Run the master playbook.
        -u | --update      Update everything, overwriting all local changes.
        -s | --status      Display the git status of everything.
        -h | --help        Display usage.

EOF

  exit 1
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
    git submodule foreach git fetch -a > /dev/null 2>&1 && \
    git submodule foreach git status
}

check_status_all() {
    git fetch -a > /dev/null 2>&1 && \
    git status && \
    check_status_submodules
}

check_playbook() {
    ANSIBLE_SSH_PIPELINING=True ansible-playbook --check --ask-become-pass -i hosts master.yml
}

run_playbook() {
    ANSIBLE_SSH_PIPELINING=True ansible-playbook --ask-become-pass -i hosts master.yml
}

if [ $# -ne 1 ]; then
    usage
fi

precheck

case "$1" in
    '-c'|'--check')
        check_playbook
        ;;
    '-r'|'--run')
        run_playbook
        ;;
    '-u'|'--update')
        hard_update_all
        ;;
    '-s'|'--status')
        check_status_all
        ;;
    *)
        usage
        ;;
esac
