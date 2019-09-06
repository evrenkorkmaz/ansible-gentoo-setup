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
### Configure Ansible Host file 

```
nano /etc/ansible/hosts 
```
Add this lines end  of the hosts file 
User must be root and define gentoo ip addres
```
[servers]
gentoo ansible_ssh_host=xx.xx.xx.xx ansible_ssh_user=root
```
Save and exit

### Test Ansible Connection
```
ansible gentoo -m ping 
```
Output :
```
gentoo | SUCCESS => {
 “changed”: false,
 “ping”: “pong”
}
gentoo | SUCCESS => {
 “changed”: false,
 “ping”: “pong”
}
```
If you see this output, it is connected

Now run .yml file with ansible-playbook
```
ansible-playbook gentoo-setup.yml
```
If you take any error check host and src line in gentoo-setup.yml file
