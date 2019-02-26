---
title: Home Assistant with a DSC Alarm and an IT-100 board
layout: post
tags: ha dsc
---

Using Home Assistant with a DSC alarm is great because the components for the DSC are inexpensive and the access is dependable and simplistic.  Connecting the DSC to Home Assistant is not as easy as pluggin in a cable but it is generally straight forward.

There are three paths for this:

+ Purchase an Envisalink EVL-4 IP Interface Module
+ Purchase an IT-100 board from DSC/Tyco and decorate in front of it with a computer (Raspberry PI as an example)
+ Purchase an IT-100 board and develop your own binary event hooks using the serial data from the IT-100 (so much work)

When I built my house few years ago the best solution (at the time) was an IT-100 board built by the folks at Tyco/DSC that would provide a serial based connection to the keypad in the DSC 1832.  The board has been in my alarm for years and I wanted to connect it to Home Assistant (finally).  There are a few different ways to do this.  I could have:

+ 

cd $HOME
git clone https://github.com/SolidElectronics/evl-emu.git

Edit the evl-emu.py file to update the system IP (*look for and update NETWORK_HOST*)
```
vi $HOME/evl-emu/evl-emu.py
```


```
[Unit]
Description=Envisalink Emulator

[Service]
Type=simple
Restart=always
User=pi
ExecStart=/home/pi/evl-emu/evl-emu.py

[Install]
WantedBy=multi-user.target
```

sudo chmod +x /home/pi/evl-emu/evl-emu.py
sudo touch /etc/systemd/system/evl-emu.service
echo -e "[Unit]\nDescription=Envisalink Emulator\n\n[Service]\nType=simple\nRestart=always\nUser=pi\nExecStart=/home/pi/evl-emu/evl-emu.py\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/evl-emu.service
sudo chmod 644 /etc/systemd/system/evl-emu.service

sudo systemctl daemon-reload
sudo systemctl enable evl-emu.service
sudo systemctl start evl-emu.service
sudo systemctl stop evl-emu.service
sudo journalctl -f -u evl-emu.service