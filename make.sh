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
rm -f /etc/sarls/$procname
echo '#! /bin/sh' >> /etc/sarls/$procname
echo 'if /etc/init.d/'$procname' status | grep -q "'$procnote'";' >> /etc/sarls/$procname
echo 'then' >> /etc/sarls/$procname
echo 'echo "service '$procname' is not running, restarting.."' >> /etc/sarls/$procname
echo '/etc/init.d/'$procname' restart' >> /etc/sarls/$procname
echo 'else' >> /etc/sarls/$procname
echo 'echo "service '$procname' is running."' >> /etc/sarls/$procname
echo 'fi' >> /etc/sarls/$procname

# Create crontab for running auto restart file, run every 5 minutes
if crontab -l || grep -q "'$procname'";
then
crontab -l | { cat; echo "*/5 * * * * sh /etc/sarls/$procname > /dev/null 2>&1"; } | crontab -
fi
echo "Cron Script Simple Auto Restart Linux Service Is Finish"
echo "Cron file placed in /etc/sarls/$procname"
