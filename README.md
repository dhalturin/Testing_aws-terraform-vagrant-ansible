# Create and deploy AWS instances

## Requirements

- ansible
- terraform
- vagrant
- inspec

Versions of tested:

Ansible:

```
ansible --version
ansible 2.4.3.0
config file = None
configured module search path = [u'/Users/dhalturin/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
ansible python module location = /Library/Python/2.7/site-packages/ansible
executable location = /usr/local/bin/ansible
python version = 2.7.10 (default, Aug 17 2018, 17:41:52) [GCC 4.2.1 Compatible Apple LLVM 10.0.0 (clang-1000.0.42)]
```

Terraform:

```
terraform --version
Terraform v0.11.10
```

Vagrant:

```
vagrant --version
Vagrant 2.1.0
```

Inspec:

```
inspec --version
3.0.12
```

# Prepare, deploy and tested instances

Show help message:

```
./run.sh
Choose type to run

Use:
    ./run.sh [type] - vagrant, terraform
Cleaning up
```

# Command result

```
./run.sh vagrant
Using vagrant
Bringing machine 'app01' up with 'virtualbox' provider...
Bringing machine 'pgsql01' up with 'virtualbox' provider...
Bringing machine 'pgsql02' up with 'virtualbox' provider...
==> app01: Importing base box 'debian/stretch64'...
...
Success
Run: ansible
Installing requirements: Success
...
ansible-playbook 2.4.3.0
PLAY RECAP ****************************************************************
app01.paxful.lo            : ok=56   changed=22   unreachable=0    failed=0
pgsql01.paxful.lo          : ok=31   changed=18   unreachable=0    failed=0
pgsql02.paxful.lo          : ok=33   changed=18   unreachable=0    failed=0
...
Run test for group: pgsql
Test start for pgsql01.paxful.lo

Profile: InSpec Profile (pgsql)
Version: 0.1.0
Target:  ssh://vagrant@127.0.0.1:2211

  PostgreSQL query: \l
     ✔  output should match "^testbase|testuser"
  PostgreSQL query: \dt
     ✔  output should match "^public|data|testbase|testuser"

Test Summary: 2 successful, 0 failures, 0 skipped
Success
Test start for pgsql02.paxful.lo

Profile: InSpec Profile (pgsql)
Version: 0.1.0
Target:  ssh://vagrant@127.0.0.1:2212

  PostgreSQL query: \l
     ✔  output should match "^testbase|testuser"
  PostgreSQL query: \dt
     ✔  output should match "^public|data|testbase|testuser"

Test Summary: 2 successful, 0 failures, 0 skipped
Success
Success
Run test for group: app
Test start for app01.paxful.lo

Profile: InSpec Profile (paxful)
Version: 0.1.0
Target:  ssh://vagrant@127.0.0.1:2210

  Command: `wget -qO- http://127.0.0.1/?n=15`
     ✔  stdout should match "^0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610$"
  Command: `wget -qO- http://127.0.0.1/blacklisted -S 2>&1`
     ✔  stdout should match "^[ ]+HTTP/1.1 444"

Test Summary: 2 successful, 0 failures, 0 skipped
```
