# Commands

- [Commands](#commands)
  - [Configuration-related commands](#configuration-related-commands)
  - [Ad hoc commands](#ad-hoc-commands)
    - [Default (i.e. command)](#default-ie-command)
    - [Ping](#ping)
    - [Copy](#copy)
    - [File](#file)
    - [Setup](#setup)
  - [Playbook-specific commands](#playbook-specific-commands)

## Configuration-related commands

- `ansible-config dump` — outputs current configuration settings, as seen below (note that these can be overridden by creating/editing a custom file, usually named *ansible.cfg*):
  - **DEFAULT_HOST_LIST** — the default inventory file path
  - **DEFAULT_REMOTE_USER** — the default SSH user Ansible will use to connect to remote hosts
  - **DEFAULT_BECOME_METHOD** — the default method Ansible will use for privilege escalation (e.g. `sudo`)
  - **HOST_KEY_CHECKING** — can be false in testing environments, **otherwise should be true**; verifies the identity of remote servers by comparing their unique host keys against a local database of **known hosts**
- `ansible-config dump --only-changed` — after editing *ansible.cfg*, this outputs only the configuration settings that have been changed
- `ansible-config dump --config <path to specific config file` — runs the `dump` command on a specific config file if you have multiple (e.g. for different scenarios e.g. testing vs production)
- 
## Ad hoc commands

- general syntax: `ansible [hosts/group] -m [module to be used] -a "[module arguments]"`
  - `-i <optional: given hosts path/filename>` — optional; can be added to any of the below to specify a particular inventory/hosts file be used

### Default (i.e. command)

- `ansible <given host/group> -a "<bash command to be run>"` — uses the `command` module to run a given command on given hosts with optional hosts file specified (note the lack of need for `-m command`, as this is the default module used)
- [see here for more options](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html#ansible-collections-ansible-builtin-command-module)

### Ping 

- `ansible <all/specified hosts group> -m ping` — uses the `ping` module to test Ansible's connectivity to all hosts/hosts in a group (note that `-m` is the flag when using modules in ad hoc commands e.g. `ping`)
  - note that this doesn't actually use the `ping` protocol used in Bash, it's just Ansible checking the connection between the controller and the hosts 
  - `ansible -i <given inventory/hosts filename> -m ping <all or other group of hosts>` — specifies the inventory/hosts file to be used when pinging
- [see here for more options](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ping_module.html#ansible-collections-ansible-builtin-ping-module)

### Copy

- `ansible <host(s)> -m copy -a "src=<path to file on the controller node to be copied to hosts> dest=<destination path and file name on hosts> mode=<optional: set permissions in octal 0000 format> owner=<optional: file owner> group=<optional: group owner>"` — uses the `copy` module to copy given file from controller to the path on the specified host(s), with optional permissions settings (note that `-a` is when passing arguments to an ad hoc command)
- [see here for more options](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html#ansible-collections-ansible-builtin-copy-module)

### File

- `ansible <host(s)> -m file -a "path=/tmp/test_dir state=directory mode=<octal 0000 permissions setting>"` — creates a directory with the name *test_dir* in the given destination path and applies the given permissions settings to it
- `ansible <host(s)> -m file -a "path=/tmp/test_file state=file mode=<octal 0000 permissions setting>"` — creates a file with the name *test_file* in the given destination path and applies the given permissions settings to it
- [see here for more options](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)

### Setup

- `ansible <host(s)> -m setup` — gathers facts (i.e. information) outputted as variables about target host(s), e.g. OS, RAM, storage, IP address, etc.
- `ansible <host(s)> -m setup` "filter=ansible_distribution*" — only includes specified fact (i.e. variable) in its output

## Playbook-specific commands

- `ansible-playbook <playbook name>` — runs given playbook
  - `ansible-playbook <playbook name> --syntax-check` — checks the syntax of the given playbook, outputting any errors in red
  - `-i <optional: given hosts path/filename>` — optional; can be added to a playbook command to specify a particular inventory/hosts file if you have multiple; to run one playbook using multiple inventory files, you simply add another `-i <optional: given hosts path/filename>` after the first, e.g. `ansible-playbook -i <first hosts file path> -i <second hosts file path> <playbook name>`
- `ansible-playbook -i <given hosts file if not default> <playbook name>` — runs given playbook using given hosts file
