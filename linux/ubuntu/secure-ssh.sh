#secure-ssh.sh
#author mshapiro2025
# creates a new ssh user using $username parameter
# adds a public key from the local repo or curled from the remote repo
# removes roots ability to ssh in

read -p "Input the username for your new SSH user: " username
read -p "Enter the password for your new SSH user: " password
useradd -m $username
mkdir /home/$username/.ssh
cp /sys265/linux/public-keys/id_rsa.pub /home/$username/.ssh/authorized_keys
chmod 700 /home/$username/.ssh
chmod 600 /home/$username/.ssh/authorized_keys
chown -R $username:$username /home/$username/.ssh
if  [[ !  -f "/public-keys/id_rsa.pub" ]]
then
  git clone https://github.com/mshapiro2025/sys265/public-keys
fi
exit
if grep -Fxq "#PermitRootLogin yes" /etc/ssh/sshd_config
then
  sed -i "s/#PermitRootLogin yes/PermitRootLogin no" /etc/ssh/sshd_config
elif grep -Fxq "PermitRootLogin yes" /etc/ssh/sshd_config
then
  sed -i "s/PermitRootLogin yes/PermitRootLogin no" /etc/ssh/sshd_config
fi

