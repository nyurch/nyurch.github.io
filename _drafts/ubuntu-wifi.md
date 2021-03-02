---
layout: post
title: Налаштування WiFi через термінал Ubuntu.
category: [LINUX]
---

![atom logo](/assets/media/rrr.png?style=head)  
ls /sys/class/net

sudo nano /etc/netplan/50-cloud-init.yaml

# This file is generated from information provided by the datasource. Changes
# to it will not persist across an instance reboot. To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            optional: true
    version: 2
    wifis:
        wlan0:
            dhcp4: true
            optional: true
            access-points:
                "SSID_name":
                    password: "WiFi_password"

sudo netplan generate
sudo netplan apply

Possible troubleshooting

Failed to start netplan-wpa-wlan0.service: Unit netplan-wpa-wlan0.service not found.
sudo systemctl start wpa_supplicant

shutdown now
sudo netplan generate
sudo netplan apply



Warning: The unit file, source configuration file or drop-ins of netplan-wpa-wlan0.service changed on disk. Run 'systemctl daemon-reload' to reload units.

It is not crtical
