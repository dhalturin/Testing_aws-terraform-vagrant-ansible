# Create and deploy AWS instances

## Requirements

- ansible
- terraform
- vagrant
- inspec

Versions of tested:

Ansible:

> ansible --version
> ansible 2.4.3.0
> config file = /Users/dhalturin/repos/iqoption/teams/webteam/infrastructure/fininfo/ansible.cfg
> configured module search path = [u'/Users/dhalturin/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
> ansible python module location = /Library/Python/2.7/site-packages/ansible
> executable location = /usr/local/bin/ansible
> python version = 2.7.10 (default, Aug 17 2018, 17:41:52) [GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)]

Terraform:

> terraform --version
> Terraform v0.11.10

Vagrant:

> vagrant --version
> Vagrant 2.1.0

Inspec:

> inspec --version
> 3.0.12

# Prepare, deploy and tested instances

Show help message:

```
./run.sh
Choose type to run

Use:
    ./run.sh [type] - vagrant, terraform
Cleaning up
```
