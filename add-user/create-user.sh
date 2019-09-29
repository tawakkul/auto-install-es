#!bin/sh
group=$1
group=$2
pass=$3

#only root cat add user to the system.
if [ $(id -u) -eq 0 ];then
	echo "User is root , you can go ahead!"
else
	echo "Only root may add a user to the system"
	exit 2
fi


#create group if not exists.
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ];then
	groupadd $group
	echo "group $group is created!"
else
	echo "group is exists , skiped from creating group!"
fi

#create user if not exists
egrep "^$user" /etc.passwd >& /dev/null
if [ $? -ne 0 ]
then
	epass=$(perl -e 'print crypt($ARGV[0], "password")' $pass)
	useradd-m  -g $group -p $epass $user
	echo "user $user created and added to the group $group ,user pass word is $pass"
else
	echo "user exists! detecting the home derectory."
	if [ -d "/home/$user" ];then
		echo "directory exists."
	else
		mkdir -p "/home/$user"
		echo "directory /home/$user created."
	fi
fi


