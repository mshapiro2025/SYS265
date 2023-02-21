#secure-ssh.sh
#author mshapiro2025
# creates a new ssh user using $username parameter
# adds a public key from the local repo or curled from the remote repo
# removes roots ability to ssh in

read -p "Input the username for your new SSH user: " username
useradd -m $username
mkdir /home/$username/.ssh
mkdir /home/$username/.ssh/authorized-keys
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized-keys
chown -R $username:$username /home/$username/.ssh
if  [[ !  -f "/home/shapiro/SYS265/linux/public-keys/id_rsa.pub" ]]
then
  git pull
  cp /home/shapiro/SYS265/linux/public-keys/id_rsa.pub /home/$username/.ssh/authorized-keys/id_rsa.pub
else
  cp /home/shapiro/SYS265/linux/public-keys/id_rsa.pub /home/$username/.ssh/authorized-keys/id_rsa.pub
fi
chown 600 /home/$username/.ssh/authorized-keys/id_rsa.pub
if grep -Fx "#PermitRootLogin yes" /etc/ssh/sshd_config
then
  sed -i "s/#PermitRootLogin yes/PermitRootLogin no/I" /etc/ssh/sshd_config
  systemctl restart sshd
fi
