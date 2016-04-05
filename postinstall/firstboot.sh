#!/bin/bash

# This is the PVSD Netbook installation first boot script! Yay!

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
sudo apt-get --yes --force-yes install krb5-user sudo curl winbind libpam-winbind libnss-winbind libpam-krb5 chromium

# Integrate configuration files
pvsd_base="https://raw.githubusercontent.com/lg198/pvsd-netbooks/master/ad"

# Download and install config files
curl -o /etc/krb5.conf $pvsd_base/krb5.conf
curl -o /etc/nsswitch.conf $pvsd_base/nsswitch.conf
curl -o /etc/samba/smb.conf $pvsd_base/samba/smb.conf
curl -o /etc/pam.d/common-session $pvsd_base/pam.d/common-session

# Restart to load new configs
sudo service smbd restart
sudo service nmbd restart
sudo service winbind restart

# TODO: Generate Kerberos ticket
