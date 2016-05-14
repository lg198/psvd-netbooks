#!/bin/bash

######################################################
# This is the PVSD Netbook post-installation script. #
# This script can be found at https://git.io/vw4nY.  #
# To download, use curl -L to follow redirect.       #
######################################################

pvsd_base="https://raw.githubusercontent.com/lg198/pvsd-netbooks/master/post"

# ===[ Install packages and configuration files ]===

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "This script must be run as root. Prepend the command with \"sudo\"."
  exit
fi

# Ask for hostname
oldhstname=$(cat /etc/hostname)
read -p "Enter computer hostname: " hstname
sudo rm /etc/hostname
echo "$hstname" > /etc/hostname
sudo sed -ri "s/$oldhstname/$hstname/g" /etc/hosts


# Load empty kerberos defaults to quiet install dialog
cat > krb5.seed << EOF

krb5-config krb5-config/add_servers boolean false
krb5-config krb5-config/add_servers_realm string
krb5-config krb5-config/admin_server string
krb5-config krb5-config/read_conf boolean
krb5-config krb5-config/kerberos_servers string
krb5-config krb5-config/default_realm string
EOF

debconf-set-selections ./krb5.seed
rm krb5.seed

# Install Kerberos, without it asking annoying questions
sudo apt-get --yes --force-yes install krb5-user sudo curl winbind libpam-winbind libnss-winbind libpam-krb5 chromium-browser

# Download and install config files
curl -o /etc/krb5.conf $pvsd_base/krb5.conf
curl -o /etc/nsswitch.conf $pvsd_base/nsswitch.conf
curl -o /etc/samba/smb.conf $pvsd_base/samba/smb.conf
curl -o /etc/pam.d/common-session $pvsd_base/pam.d/common-session

# Restart to load new configs
sudo service smbd restart
sudo service nmbd restart
sudo service winbind restart

# Create kerberos ticket
sudo kinit macjoin@PVSD.ORG

# Refresh cache
sudo net cache flush

# Join network
sudo net ads join -k

# Restart services
sudo service winbind restart
sudo service smbd restart
sudo service nmbd restart

##################
# VARIOUS THINGS #
##################

# Connect to wireless network
read -p "Enter the PV-Mobile password: " npass
nmcli dev wifi connect PV-Mobile password $npass
read -p "Press enter when the wireless network is established."

# Give ladmin network permissions
sudo usermod -G netdev -a ladmin

# Prevent access to the terminal
sudo chmod o-x /usr/bin/xfce4-terminal
sudo chmod o-x /usr/bin/xterm

# Set up panel
sudo mkdir --parents /etc/skel/.config/xfce4/xfconf/xfce-perchannel
sudo curl -o /etc/skel/.config/xfce4/xfconf/xfce-perchannel/xfce4-panel.xml $pvsd_base/xfce4-panel.xml


###############
#  ASTHETICS  #
###############

sudo apt-get --yes --force-yes install git

# Install custom logo and wallpaper
cd /lib/plymouth/themes/xubuntu-logo/
sudo curl -o wallpaper.png $pvsd_base/wallpaper.png
sudo curl -o logo.png $pvsd_base/logo.png

# Install desktop background
cd /usr/share/xfce4/backdrops
sudo curl -o pvsd-desktop.png $pvsd_base/desktop.png
sudo ln -sf pvsd-desktop.png xubuntu-wallpaper.png

# Install polar-night
cd /usr/share/themes/
sudo git clone https://github.com/baurigae/polar-night.git

# Configure polar-night
cd /etc/lightdm/
sudo sed -ri 's/^(theme-name)=[^\n]+/\1=polar-night/' lightdm-gtk-greeter.conf
echo "hide-user-image=true" >> lightdm-gtk-greeter.conf

# Configure lightdm greeter
cd /etc/lightdm/lightdm.conf.d
echo "greeter-hide-users=true" >> 10-xubuntu.conf
echo "greeter-show-manual-login=true" >> 10-xubuntu.conf

##########
# REBOOT #
##########

sudo shutdown -r 0
