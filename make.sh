#!/bin/bash
# Script SARLS (Simple Auto Restart Linux Service) by Indoworx
# www.indoworx.com

# Get Data from input
read -p "Enter linux service name to monitor:" procname
read -p "Enter notification if the service is stopped (example: not running)" procnote

# Create cron auto restart file for auto restart the service
if [ ! -d "/etc/sarls" ]; then
mkdir /etc/sarls
fi
cat <<'EOF' >> /etc/sarls/$procname
#! /bin/sh
SNAME=$procname
SERVICE=/etc/init.d/$SNAME
if $SERVICE status | grep -q "$procnote";
then
echo "service $SNAME is not running, restarting.."
$SERVICE restart
else
echo "service $SNAME is running."
fi
EOF

# Create crontab for running auto restart file, run every 5 minutes
crontab -l | { cat; echo "*/5 * * * * sh /etc/sarls/$procname > /dev/null 2>&1"; } | crontab -

echo "Cron Script Simple Auto Restart Linux Service Is Finish"
echo "Cron file placed in /etc/sarls/$procname"
