#!/bin/bash

# This is the PVSD Netbook post-installation script! Yay!

if [ "$EUID" -ne 0 ]
  then echo "This script must be run as root. Prepend the command with \"sudo\"."
  exit
fi

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
sudo apt-get --yes --force-yes install krb5-user sudo curl winbind libpam-winbind libnss-winbind libpam-krb5 chromium xdotool

# Integrate configuration files
pvsd_base="https://raw.githubusercontent.com/lg198/pvsd-netbooks/master/post"

# Download and install config files
curl -o /etc/krb5.conf $pvsd_base/krb5.conf
curl -o /etc/nsswitch.conf $pvsd_base/nsswitch.conf
curl -o /etc/samba/smb.conf $pvsd_base/samba/smb.conf
curl -o /etc/pam.d/common-session $pvsd_base/pam.d/common-session

curl -o /root/passthebutter $pvsd_base/passthebutter
chmod +x /root/passthebutter

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

# TODO:
#   - Download wallpaper.png and logo.png
#   - Place them in /lib/plymouth/themes/xubuntu-logo/

#   - Move to /usr/share/themes
#   - Git clone https://github.com/baurigae/polar-night.git
#   - Change /etc/lightdm/lightdm-gtk-greeter.conf "theme-name" to "polar-night"
#   - In same file, add "hide-user-image=true"
