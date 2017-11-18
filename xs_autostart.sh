#!/bin/sh
# XenServer autostart script
# Use at your own risks
# Do not use with VMs using HA.
# Instructions:
# 1. Put this script in /root
# 2. Give execution permission: "chmod +x /root/xs_autostart.sh"
# 3. Add "@reboot /root/xs_autostart.sh" in root's crontab
# 4. Add the "autostart" to VM needing it
# 5. Add "autostart" in the descriptions of vApps needing it
# 6. [Optional] Configure /etc/ssmtp/ssmtp.conf to receive an email when the script runs
# AutoStart VM's that are tagged with autostart tag
# Script created by Raido Consultants - http://www.raido.be
TAG="autostart" # helper function
function xe_param()
{
  PARAM=$1
  while read DATA; do
    LINE=$(echo $DATA | egrep "$PARAM")
    if [ $? -eq 0 ]; then
      echo "$LINE" | awk 'BEGIN{FS=": "}{print $2}'
    fi
  done
} # Get all VMs
sleep 20
VMS=$(xe vm-list is-control-domain=false | xe_param uuid); for VM in $VMS; do
  echo "Raido AutoStart Script : Checking VM $VM"
  VM_TAGS="$(xe vm-param-get uuid=$VM param-name=tags)";
  if [[ $VM_TAGS == *$TAG* ]];then
    echo "starting VM $VM"
    sleep 20
    xe vm-start uuid=$VM
  fi
done
# Get all Applicances
sleep 20
VAPPS=$(xe appliance-list | xe_param uuid); for VAPP in $VAPPS; do
  echo "Raido AutoStart : Checking vApp $VAPP"
  VAPP_TAGS="$(xe appliance-param-get uuid=$VAPP param-name=name-description)"; 
  if [[ $VAPP_TAGS == *$TAG* ]];then
   echo "starting vApp $VAPP"
   xe appliance-start uuid=$VAPP
   sleep 20
  fi
done

