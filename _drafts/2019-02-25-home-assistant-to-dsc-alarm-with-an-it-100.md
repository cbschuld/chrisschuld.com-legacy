---
title: Home Assistant with a DSC Alarm, an IT-100 board and a Raspberry Pi
layout: post
tags: ha dsc
---

Using Home Assistant with a DSC alarm is great because the components for the DSC are generally inexpensive and the access to the sensor status is dependable and simplistic.  Connecting the DSC to Home Assistant is not as easy as one would think.  Definitely not as easy as plugging in a cable however, it is generally straight forward.

There are three paths for this:

+ Purchase an Envisalink EVL-4 IP Interface Module
+ Purchase an IT-100 board from DSC/Tyco and decorate in front of it with a computer (Raspberry PI in this case)
+ Purchase an IT-100 board and develop your own binary sensor event hooks using the serial data from the IT-100 and send them into Home Assistant (so much work)

When I built my house few years ago the best solution (at the time) was an IT-100 board built by the folks at Tyco/DSC that would provide a serial based connection to the keypad in the DSC 1832.  The board has been in my alarm for years and I wanted to connect it to Home Assistant (finally).  Thus, I went with the second case.

The entire process was sped up significantly by some software written by Paul Hobbs (SolidElectronics on github).  Paul's python script takes sensor status data and simplistic IO from the IT-100 board and converts it to an alias of the Envisalink EVL-4.

So...

Here is how I did it; and it is working flawlessly.

### The Overview
+ Purchase and Install the IT-100 board
+ Purchase and Install a DB9 to USB cable (*I found this cable to work perfectly and not all of them work so it's nice to have a reference*)
+ Setup a Raspberry Pi to "decorate" the IT-100 board (*I used the B+ model for mine*)
+ Setup the software on the Raspberry
+ Update Home Assistant to work with 'decorator'

### Purchase and Install the IT-100 board

The IT-100 board is easy to install if you have a bit of background with the DSC alarms.  You need to add the IT-100 to the keypad bus and it auto-installs itself as keypad #8 on the system.  Make sure the board is on stand offs in the DSC box as well and follow the install directions from the IT-100 board.  After the install is complete if you check the Module Supervision mode on the DSC you will see a keypad on #8.

You can check Module Supervision mode via:

```
*8 5555 903 [wait for display] #
```
*where 5555 is your installer code*

### Purchase and Install a DB9 to USB cable

The DB9 serial cable can cause you fits (at least in my experience - amazon reviews are your friend in this case).  I found this cable to work perfectly:

I routed my cable down out of the back of my DSC box into a Structured Wiring box.  In there I will put the Raspberry Pi.

### Setup a Raspberry Pi

I added Raspbian Stretch to a Raspberry Pi B+ Model and switched off the GUI.  From there I setup a static IP address on my DHCP server so I always know where the decorator is at.  Part of the process of Raspbian installing is updating the software.  Make sure you let it fully update as well.

> Make sure the Raspberry Pi is on a static IP address and note the IP; you'll need it in a bit

After I have the system is done updating we install the emulation software.  The software you get using git from Paul's repo.  Here are the commands.

Login to the Pi using the "pi" user:

```
cd $HOME
git clone https://github.com/SolidElectronics/evl-emu.git
```

Edit the evl-emu.py file to update the system IP (*look for the NETWORK_HOST variable*)
```
vi $HOME/evl-emu/evl-emu.py
```

#### Now we are going to make Paul's script run all the time...

Let's establish the emulator as a service on the system using systemd.  To do this we are going to create the following file for describing the service (*I have commands below that will do all of the work for you*):

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

All of this can be automated in a few commands.  This assumes you have the vanilla Raspbian install.  Here are the commands to run:

```
sudo chmod +x /home/pi/evl-emu/evl-emu.py
sudo touch /etc/systemd/system/evl-emu.service
echo -e "[Unit]\nDescription=Envisalink Emulator\n\n[Service]\nType=simple\nRestart=always\nUser=pi\nExecStart=/home/pi/evl-emu/evl-emu.py\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/evl-emu.service
sudo chmod 644 /etc/systemd/system/evl-emu.service
sudo systemctl daemon-reload
sudo systemctl enable evl-emu.service
```

To start the service:
```
sudo systemctl start evl-emu.service
```

To stop the service:
```
sudo systemctl stop evl-emu.service
```

If you ever need or want to look at the logs and info coming from the python script you can do that with:
````
sudo journalctl -f -u evl-emu.service
````

### Update Home Assistant to work with 'decorator'

