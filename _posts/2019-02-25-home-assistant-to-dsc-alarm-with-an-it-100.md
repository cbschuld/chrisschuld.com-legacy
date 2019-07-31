---
title: Home Assistant with a DSC Alarm, an IT-100 board and a Raspberry Pi
layout: post
tags: home-automation dsc
---

Using Home Assistant with a DSC alarm is great because the components for the DSC are generally inexpensive and the access to the sensor status is dependable and simplistic.  Connecting the DSC to Home Assistant is not as easy as one would think.  Definitely not as easy as plugging in a cable however, it is generally straight forward.

There are three paths for this:

+ Purchase an [Eyez-On Envisalink EVL-4EZR](https://amzn.to/2E6YINH) IP Interface Module
+ Purchase an [IT-100 board](https://amzn.to/2BPi9KB) from DSC/Tyco and decorate in front of it with a computer (Raspberry PI in this case)
+ Purchase an [IT-100 board](https://amzn.to/2BPi9KB) and develop your own binary sensor event hooks using the serial data from the [IT-100 board](https://amzn.to/2BPi9KB) and send them into Home Assistant (so much work)

When I built my house few years ago the best solution (at the time) was an IT-100 board built by the folks at Tyco/DSC that would provide a serial based connection to the keypad in the DSC 1832.  The board has been in my alarm for years and I wanted to connect it to Home Assistant (*finally*).  Thus, I went with the second concept to use the IT-100 board.

The entire process was sped up significantly by some software written by Paul Hobbs ([SolidElectronics](https://github.com/SolidElectronics/) on github).  Paul's python script takes sensor status data and simplistic IO from the IT-100 board and converts it to an alias of the Envisalink EVL-4.

So...

Here is how I did it; and it is working flawlessly.

### The Overview
+ Purchase and Install the [IT-100 board](https://amzn.to/2BPi9KB)
+ Purchase and Install a [DB9 to USB cable](https://amzn.to/2T3JZxp) (*I found [this cable](https://amzn.to/2T3JZxp) to work perfectly and not all of them work so it's nice to have a reference*)
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

```shell
cd $HOME
git clone https://github.com/SolidElectronics/evl-emu.git
```

Edit the evl-emu.py file to update the system IP (*look for the NETWORK_HOST variable*)
```shell
vi $HOME/evl-emu/evl-emu.py
```

#### Now we are going to make Paul's script run all the time...

Let's establish the emulator as a service on the system using systemd.  To do this we are going to create the following file for describing the service (*I have commands below that will do all of the work for you*):


`/etc/systemd/system/evl-emu.service`
```ini
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

```shell
sudo chmod +x /home/pi/evl-emu/evl-emu.py
sudo touch /etc/systemd/system/evl-emu.service
echo -e "[Unit]\nDescription=Envisalink Emulator\n\n[Service]\nType=simple\nRestart=always\nUser=pi\nExecStart=/home/pi/evl-emu/evl-emu.py\n\n[Install]\nWantedBy=multi-user.target" | sudo tee /etc/systemd/system/evl-emu.service
sudo chmod 644 /etc/systemd/system/evl-emu.service
sudo systemctl daemon-reload
sudo systemctl enable evl-emu.service
```

Next, we can start the service.  To **start the service**:
```shell
sudo systemctl start evl-emu.service
```

If you ever need to **stop the service**:
```shell
sudo systemctl stop evl-emu.service
```

Also, if you ever need or want to **look at the logs** and info coming from the python script you can do that with:
````shell
sudo journalctl -f -u evl-emu.service
````

Okay, now we have the service decorator running and we need to update Home Assistant to work with the decorator.

### Update Home Assistant to work with 'decorator'

First, you need to understand all of your zones and what "type" of zones they are.  Create a table of your zones and determine what type of zone they are.  Types are determined by this list which defines the type of [Device Class](https://www.home-assistant.io/components/binary_sensor/):

+ None: Generic on/off. This is the default and doesn’t need to be set.
+ battery: *On* means low, *Off* means normal
+ cold: *On* means cold, *Off* means normal
+ connectivity: *On* means connected, *Off* means disconnected
+ door: *On* means open, *Off* means closed
+ garage_door: *On* means open, *Off* means closed
+ gas: *On* means gas detected, *Off* means no gas (clear)
+ heat: *On* means hot, *Off* means normal
+ light: *On* means light detected, *Off* means no light
+ lock: *On* means open (unlocked), *Off* means closed (locked)
+ moisture: *On* means moisture detected (wet), *Off* means no moisture (dry)
+ motion: *On* means motion detected, *Off* means no motion (clear)
+ moving: *On* means moving, *Off* means not moving (stopped)
+ occupancy: *On* means occupied, *Off* means not occupied (clear)
+ opening: *On* means open, *Off* means closed
+ plug: *On* means device is plugged in, *Off* means device is unplugged
+ power: *On* means power detected, *Off* means no power
+ presence: *On* means home, *Off* means away
+ problem: *On* means problem detected, *Off* means no problem (OK)
+ safety: *On* means unsafe, *Off* means safe
+ smoke: *On* means smoke detected, *Off* means no smoke (clear)
+ sound: *On* means sound detected, *Off* means no sound (clear)
+ vibration: *On* means vibration detected, *Off* means no vibration (clear)
+ window: *On* means open, *Off* means closed


Here is an example of a list of zones:

```yaml
zones:
  1:
    name: 'Front Door'
    type: 'door'
  2:
    name: 'Den Door'
    type: 'door'
  3:
    name: 'Guest Door'
    type: 'door'
  4:
    name: 'Casita Door'
    type: 'door'
  5:
    name: 'Casita Bathroom'
    type: 'window'
  6:
    name: 'Guest Bathroom'
    type: 'window'
  7:
    name: 'Mechanical Room'
    type: 'door'
  8:
    name: 'Master Windows'
    type: 'window'
  9:
    name: 'Master Door'
    type: 'door'
  10:
    name: 'Glass Slider'
    type: 'door'
  11:
    name: 'Back Door'
    type: 'door'
```


Create a file in your Home Assistant that looks like this (but include your zones and include your code) and call the file `envisalink.yaml`

```
  host: 127.0.0.1
  panel_type: DSC
  user_name: user
  password: pass
  code: '0000'
  zones:
    1:
      name: 'Front door'
      type: 'door'
    2:
      name: 'Garage back door'
      type: 'door'
    3:
      name: 'Living Room Windows'
      type: 'window'
    4:
      name: 'Family Room Motion'
      type: 'motion'
  partitions:
    1:
      name: 'Alarm'
```

As an example here is a [24 zone sample file](/public/documents/envisalink.txt).

Next, add the following to your `configuration.yaml` file:

```yaml
envisalink: !include envisalink.yaml
```

After you restart your Home Assistant you will be able to monitor the sensors from your alarm as well as activate the alarm panel!!

<img src="/public/images/hassio-with-alarm-from-dsc-it-100.png" class="screenshot">
