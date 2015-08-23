#!/bin/bash

if ! hash ansible 2>/dev/null; then
    echo -e "\nAnsible is not installed. See: http://docs.ansible.com/ansible/intro_installation.html\n"
    exit 1
fi

ansible-playbook -i hosts -u root master.yml
