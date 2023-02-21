#secure-ssh.sh
#author mshapiro2025
# creates a new ssh user using $username parameter
# adds a public key from the local repo or curled from the remote repo
# removes roots ability to ssh in

read -p "Input the username for your new SSH user: " username
useradd -m -s /bin/bash $username
#mkdir /home/$username/.ssh
#chmod 700 /home/$username/.ssh
#chmod 600 /home/$username/.ssh/authorized_keys
#chown -R $username:$username /home/$username/.ssh
if  [[ !  -f "/home/shapiro/SYS265/linux/public-keys/id_rsa.pub" ]]
then
  git pull
  mkdir /home/$username/.ssh
  cp /home/shapiro/SYS265/linux/public-keys/id_rsa.pub /home/$username/.ssh/authorized_keys
  chmod 700 /home/$username/.ssh
  chmod 600 /home/$username/.ssh/authorized_keys
  chown -R $username:$username /home/$username/.ssh
else
  mkdir /home/$username/.ssh
  cp /home/shapiro/SYS265/linux/public-keys/id_rsa.pub /home/$username/.ssh/authorized_keys
  chmod 700 /home/$username/.ssh
  chmod 600 /home/$username/.ssh/authorized_keys
  chown -R $username:$username /home/$username/.ssh
fi
#chmod 600 /home/$username/.ssh/authorized_keys/id_rsa.pub
#chown $username:$username /home/$username/.ssh/authorized_keys/id_rsa.pub
if grep -Fx "#PermitRootLogin yes" /etc/ssh/sshd_config
then
  sed -i "s/#PermitRootLogin yes/PermitRootLogin no/I" /etc/ssh/sshd_config
  systemctl restart sshd
fi
