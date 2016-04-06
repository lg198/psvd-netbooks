#!/bin/sh

# see if this works
echo "Hello!" > /root/works1

# grab our firstboot script
/usr/bin/curl -o /root/firstboot https://raw.githubusercontent.com/lg198/pvsd-netbooks/master/postinstall/firstboot.sh
chmod +x /root/firstboot

# create a service that will run our firstboot script
cat > /etc/init.d/firstboot <<EOF
### BEGIN INIT INFO
# Provides:        firstboot
# Required-Start:  $networking
# Required-Stop:   $networking
# Default-Start:   2 3 4 5
# Default-Stop:    0 1 6
# Short-Description: A script that runs once
# Description: A script that runs once
### END INIT INFO

cd /root ; /usr/bin/nohup sh -x /root/firstboot &


EOF

# install the firstboot service
chmod +x /etc/init.d/firstboot
update-rc.d firstboot defaults

# see if this works part 2
echo "Hi!" > /root/works2
