# Gentoo Setup With Ansible 

This project for the setup Gentoo OS with Ansible. 
Copy the setup script file to Gentoo livecd enrivonment and run that script.

## Requirments

- Remote Host
- Ansible and Ansible-playbook
- Setup Script
- Ssh key

## Usage 

### First install ansible to remote host.

```
$ sudo apt-get install software-properties-common
$ sudo apt-add-repository ppa:ansible/ansible
$ sudo apt-get update
$ sudo apt-get install ansible
```
### Clone the repo

```
git clone https://github.com/evrenkorkmaz/ansible-gentoo-setup.git
```
### If u dont have any ssh key create one on remote host

```
ssh-keygen -t rsa
```
### Start a ssh service on Gentoo 
```
rc-service ssh start
```
or 
```
/etc/init.d/sshd restart
```
### Copy ssh key from remote host
Must the copy id-rsa.pub file.
This file default location in your home directory in a .ssh (hidden) folder.
Only connect with root because gentoo dont have any user yet. Before the copy key must the give the 
password to root(use passwd command on gentoo) 
Add the gentoo ip addres on this command

```
ssh-copy-id -i key-directory root@xx.xx.xx.xx
```



