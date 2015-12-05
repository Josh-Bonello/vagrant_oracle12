# vagrant_oracle12

A simple Vagrant virtual machine with Oracle Linux 7 + Oracle 12c EE with Multitenancy.

## Installation

Download Oracle 12c installation files (2 zips, x86-64 version) from
[Oracle site](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-2240591.html)
and put them into `orafiles/` directory.

Then run `vagrant up`.

## What's inside

Provisioning scripts do the following:
* Update the system
* Install a bunch of useful packages (vim, git, Python)
* Unzip and install the database
* Create a container database
* Setup the environment
* Deploy PDB management script

## Users and passwords

All Linux accounts (root, oracle, vagrant) and database accounts (sys, system) have password vagrant.

## PDB management

`/home/oracle/bin/pdb` wraps some PDB management SQL commands. `/home/oracle/bin` is added to PATH
of oracle and vagrant users, so you can just reference `pdb`.

```
$ pdb create foo      # Creates and opens a new PDB. Admin user is pdbsys/vagrant by default
                      # You can immediately connect with pdbsys/vagrant@//localhost/foo
Pluggable database created.
Pluggable database altered.
$ pdb clone foo boo   # Clones a PDB
Pluggable database created.
Pluggable database altered.
$ pdb ls              # Lists PDBs and their status
FOO			       READ WRITE
BOO			       READ WRITE
$ pdb drop boo        # Drops a PDB
Pluggable database altered.
Pluggable database dropped.
```

