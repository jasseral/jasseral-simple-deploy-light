README.md

 ansible-configuration:
    steps:
      - run:
          name: Set additional configuration
          command: |
            SHELL_CONFIG=/etc/profile
            echo "ENVIRONMENT=$(deploy/target_environment.rb)" >> $SHELL_CONFIG
            sed -i "/- hosts:/a\  no_log: yes" ansible/playbooks/site.yml
            echo -e $ANSIBLE_VAULT_PASSWORD > ansible/.vault_pass.txt && unset ANSIBLE_VAULT_PASSWORD