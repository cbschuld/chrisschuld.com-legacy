---
title: "Installing an MQTT Broker with Synology (Mosquitto on Docker)"
layout: post
tags: dev ha
---

### Summary

An MQTT Broker allows software to communicate through messaging.  One of the popular broker apps is [Eclipse Mosquitto](https://mosquitto.org/).  For Home Automation you will find a lot of the applications interact through an MQTT so if you are going to deep dive into HA eventuall you are going to need an MQTT broker in your network.

### Using Synology

Synology builds the ultimate "set and forget" style NAS systems.  One of the great things about later generation DSMs is running Docker on the Synology directly.  In this example we will use Docker on the Synology to run Mosquitto.

### Installing Docker

On the Synology NAS use the package manager to install [Docker](https://www.docker.com/)

### Find and Download the Image

In the **Docker App** on the **Synology** DSM click on **Registry**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-docker-overview.png" alt="docker overview"/>

Next, search for **mosquitto** and look for **eclipse-mosquitto**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-search-mosquitto.png" alt="search for mosquitto"/>

Select to **Download** the image and select the **latest** tag and hit **Select**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-download-tag.png" alt="container overview"/>

After it is downloaded click **Launch**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-post-download-of-mosquitto.png" alt="download mosquitto"/>

In the *Create Container* information screen which appears when you click launch you will accept the defaults for the first screen and hit **Next**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-mosquitto-setup1.png" alt="setup mosquitto - step 1"/>

In the second screen **UNCHECK** the option to **Run this container after the wizard is finished** (becuase we are going to change the port) and then hit **Apply**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-mosquitto-setup-port.png" alt="change the port"/>

Next, click on the **Container** tab on the left hand side and you'll see the *eclipse-mosquitto1* container now.  

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-container.png" alt="container overview"/>

Click, **Edit** and edit the settings.  Change the incoming port from **Auto** to the default MQTT port of **1883**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-update-port.png" alt="mqtt updating the port"/>

Next, hit the start switch so the container starts up.

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-mosquitto-running.png" alt="mosquitto is running"/>

Finally, the MQTT broker should be running which you can test using the [mqtt client](https://hivemq.github.io/mqtt-cli/docs/installation/packages.html).

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/mqtt-working.png" alt="mqtt working in shell"/>
