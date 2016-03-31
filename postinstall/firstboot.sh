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

# Install Kerberos, without it asking annoying questions
sudo apt-get install krb5-user

# Todo: Integrate configuration files
pvsd_base="https://raw.githubusercontent.com/lg198/pvsd-netbooks/master/ad/"
