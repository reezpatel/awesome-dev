# Setup SSH
sudo apt-get install openssh-server
systemctl enable ssh

# Add Sudo User
useradd <username>
usermod -aG sudo <username>