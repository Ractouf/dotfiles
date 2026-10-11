#!/bin/bash 

if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    blueman-manager
else
    rfkill block bluetooth
fi