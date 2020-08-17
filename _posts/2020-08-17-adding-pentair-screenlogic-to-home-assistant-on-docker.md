---
title: "Adding a Pentair Screenlogic System to Home Assistant with Docker"
layout: post
tags: dev ha docker
---

## Summary

The [Pentair](https://www.pentair.com/) pool and spa equipment company creates a control system for their system called [IntelliTouch](https://www.pentair.com/en/products/pool-spa-equipment/pool-automation/intellitouch_systems.html) and to interface with it via TCP/IP you buy and install their [ScreenLogic](https://www.pentair.com/en/products/pool-spa-equipment/pool-automation/screenlogic2_interfaceforintellitouchandeasytouchautomationsystems.html) system.  The IntelliTouch system is RF based and the ScreenLogic system helps convert the RF situation into something much more manageable for Home Assistant.

### How does this work?

If we work backwards from the RF at the pool equipment to Home Assistant it is easy to describe the data path.  Here it is:

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/pentair-setup.png"/>

#### Summary of the flow:

The RF from the pool equipment is gobbled up by the Pentair Screenlogic so we do not need to worry about that. The Screenlogic system allows you to use the Pentair socket service to talk to your IntelliTouch system.  To make that interface consumable we decorate that service with [node-screenlogic](https://github.com/parnic/node-screenlogic).  Next, we need something to broker communication between the `node-screenlogic` interface and HomeAssistant.  For this solution we use MQTT which is a favorite of the HA community in general.  A script subscribes and binds to the Screenlogic system via `node-screenlogic` and reports IO via MQTT.  Thus, HomeAssistant just needs to interface via MQTT for the Pentair system which is already globally supported for HomeAssistant.

#### Thus, we need to stand up the following:

+ an MQTT broker (*maybe you already have one for other HA items, you can use that*)
+ a "go-between program" using `node-screenlogic` and `mosquitto` (*I built all of this into a Docker container*)
+ finally... the circuit switches and thermostat data for HomeAssistant

### This looks hard!

At first glance this will feel like a lot moving parts.  The bulk of the moving parts are built into two Docker containers so you can set the values and let the containers do the work.

### This has to be easier

This would be a lot easier if there was a Python-based library to talk to the Pentair system because you could build a true integration in Python.  However, as of today, this is the easiest path with in place and tested components.

<hr/>

## Alright, let's do this

Okay, here is the setup we need to do
+ (A) the MQTT broker - *using Docker*
+ (B) the `node-screenlogic` and mosquitto client decorator - *using Docker*
+ (C) expose the Pentair switches and thermostat to Home Assistant - *configuration.yaml*

<hr/>

### (A) The MQTT broker

I setup my MQTT broker via Docker, the image for the docker instance is `eclipse-mosquitto` and you will want to change the port to 1883.  Personally, I execute my Docker containers via Synology for smaller containers and you can [read more about how I do it via Synology](https://chrisschuld.com/2020/08/installing-mqtt-broker-on-synology/).

**Please Note**: *I use port 1883 which is the standard for MQTT traffic*

### (B) The Decorator

The Decorator is essentially a script that works with `node-screenlogic` and the MQTT broker.  The container with all of the components is available via [`cbschuld/pentair-screenlogic`](https://hub.docker.com/repository/docker/cbschuld/pentair-screenlogic) and the [source is available on github](https://github.com/cbschuld/pentair-screenlogic).

Run this container with environment variables:
```
SCREENLOGICIP = the IP address of your Screenlogic LAN adapter
MQTTIP = IP address of your MQTT broker (*from step A above*)
MQTTPORT = 1883
MQTTUSER = the username for your MQTT broker system [*optional*]
MQTTPASS = the user's password for your MQTT broker system [*optional*]
```

### (C) HomeAssistant Setup

Using the configuration tools you can now add the switches and thermostat information to your home assistant setup.  You will add this content into your `configuration.yaml` file.  Here is the config file (*please note that you will likely need to adjust some of these based on your setup - if you review the logs or output of the docker container in step B you will see your list of circuit definitions*).

```yaml
# You can create more switches for other circuits in you pool controller (lights, jets, cleaner, etc.)  
# Just use the same convention and change the circuit ID
switch:
  - platform: mqtt
    name: pentair_pool
    command_topic: pentair/circuit/505/command
    state_topic: pentair/circuit/505/state

  - platform: mqtt
    name: pentair_spa
    command_topic: pentair/circuit/500/command
    state_topic: pentair/circuit/500/state


# If you want to set up a thermostat device in HA to control the heater on your pool or spa
climate:
  - platform: mqtt
    name: "Pool"
    min_temp: 40
    max_temp: 104
    modes:
      - "off"
      - "heat"
    current_temperature_topic: pentair/pooltemp/state
    mode_command_topic: pentair/heater/pool/mode/set
    mode_state_topic: pentair/heater/pool/mode/state
    temperature_command_topic: pentair/heater/pool/temperature/set
    temperature_state_topic: pentair/heater/pool/setpoint/state
  - platform: mqtt
    name: "Spa"
    min_temp: 40
    max_temp: 104
    modes:
      - "off"
      - "heat"
    current_temperature_topic: pentair/spatemp/state
    mode_command_topic: pentair/heater/spa/mode/set
    mode_state_topic: pentair/heater/spa/mode/state
    temperature_command_topic: pentair/heater/spa/temperature/set
    temperature_state_topic: pentair/heater/spa/setpoint/state
    
# sensors to contain the values from ScreenLogic.  If you are using the thermostat config from above you can probably skip the pooltemp and spatemp
sensor:
  - platform: mqtt
    name: pentair_pooltemp
    state_topic: pentair/pooltemp/state

  - platform: mqtt
    name: pentair_spatemp
    state_topic: pentair/spatemp/state

  - platform: mqtt
    name: pentair_airtemp
    state_topic: pentair/airtemp/state

  - platform: mqtt
    name: pentair_alkalinity
    state_topic: pentair/alkalinity/state

  - platform: mqtt
    name: pentair_calcium
    state_topic: pentair/calcium/state

  - platform: mqtt
    name: pentair_cyanuricacid
    state_topic: pentair/cyanuricacid/state

  - platform: mqtt
    name: pentair_ph
    state_topic: pentair/ph/state

  - platform: mqtt
    name: pentair_orp
    state_topic: pentair/orp/state

  - platform: mqtt
    name: pentair_saltppm
    state_topic: pentair/saltppm/state

  - platform: mqtt
    name: pentair_saltcellstatus
    state_topic: pentair/saltcellstatus/state

  - platform: mqtt
    name: pentair_saltcelllevel1
    state_topic: pentair/saltcelllevel1/state

  - platform: mqtt
    name: pentair_saltcelllevel2
    state_topic: pentair/saltcelllevel2/state

  - platform: mqtt
    name: pentair_saturation
    state_topic: pentair/saturation/state
  
  - platform: mqtt
    name: pentair_pump0watts
    state_topic: pentair/pump/0/watts/state

  - platform: mqtt
    name: pentair_pump0rpm
    state_topic: pentair/pump/0/rpm/state
  
   - platform: mqtt
    name: pentair_pump0gpm
    state_topic: pentair/pump/0/gpm/state
  
   - platform: mqtt
    name: pentair_pump1watts
    state_topic: pentair/pump/1/watts/state
  
  - platform: mqtt
    name: pentair_pump1rpm
    state_topic: pentair/pump/1/rpm/state
  
  - platform: mqtt
    name: pentair_pump1gpm
    state_topic: pentair/pump/1/gpm/state
  
  - platform: mqtt
    name: pentair_pump2watts
    state_topic: pentair/pump/2/watts/state
  
  - platform: mqtt
    name: pentair_pump2rpm
    state_topic: pentair/pump/2/rpm/state
  
  - platform: mqtt
    name: pentair_pump2gpm
    state_topic: pentair/pump/2/gpm/state

# Use scripts to send lighting commands to ScreenLogic via MQTT.
script:
  pentair_lights_off:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 0
  pentair_lights_on:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 1
  pentair_lights_party:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 5
  pentair_lights_romance:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 6
  pentair_lights_caribbean:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 7
  pentair_lights_american:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 8
  pentair_lights_california_sunset:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 9
  pentair_lights_royal:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 10
  pentair_lights_blue:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 13
  pentair_lights_green:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 14
  pentair_lights_red:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 15
  pentair_lights_white:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 16
  pentair_lights_purple:
    sequence:
      - service: mqtt.publish
        data_template:
          topic: pentair/light/command
          payload: 17

# ScreenLogic lighting controls using buttons and switches. You could also use an input select to consolidate the color and mode options.
cards:
  - type: entities
    title: Lights
    show_header_toggle: false
    entities:
      - entity: script.pentair_lights_on
        type: button
        name: All Lights
        icon: mdi:lightbulb
        action_name: 'ON'
        tap_action:
          action: call-service
          service: script.pentair_lights_on
      - type: button
        entity: script.pentair_lights_off
        name: All Lights
        icon: mdi:lightbulb-off
        action_name: 'OFF'
        tap_action:
          action: call-service
          service: script.pentair_lights_off
      - entity: switch.pool_light
        name: Pool
        icon: mdi:lightbulb
      - entity: switch.spa_light
        name: Spa
        icon: mdi:lightbulb
      - entity: switch.bench_light
        name: Bench
        icon: mdi:lightbulb
  - type: horizontal-stack
    title: Light Colors
    cards:
      - type: vertical-stack
        cards:
          - type: entity-button
            entity: script.pentair_lights_red
            name: Red
            icon: mdi:radiobox-marked
            tap_action:
              action: call-service
              service: script.pentair_lights_red
          - type: entity-button
            entity: script.pentair_lights_purple
            name: Purple
            icon: mdi:radiobox-marked
            tap_action:
              action: call-service
              service: script.pentair_lights_purple
      - type: vertical-stack
        cards:
          - type: entity-button
            entity: script.pentair_lights_green
            name: Green
            icon: mdi:radiobox-marked
            tap_action:
              action: call-service
              service: script.pentair_lights_green
          - type: entity-button
            entity: script.pentair_lights_white
            name: White
            icon: mdi:radiobox-marked
            tap_action:
              action: call-service
              service: script.pentair_lights_white
      - type: vertical-stack
        cards:
          - type:  entity-button
            entity: script.pentair_lights_blue
            name: Blue
            icon: mdi:radiobox-marked
            tap_action:
              action: call-service
              service: script.pentair_lights_blue
  - type: horizontal-stack
    title: Light Modes
    cards:
      - type: vertical-stack
        cards:
          - type: entity-button
            entity: script.pentair_lights_party
            name: Party
            icon: mdi:party-popper
            tap_action:
              action: call-service
              service: script.pentair_lights_party
          - type: entity-button
            entity: script.pentair_lights_american
            name: American
            icon: mdi:flag
            tap_action:
              action: call-service
              service: script.pentair_lights_american
      - type: vertical-stack
        cards:
          - type: entity-button
            entity: script.pentair_lights_romance
            name: Romance
            icon: mdi:heart
            tap_action:
              action: call-service
              service: script.pentair_lights_romance
          - type: entity-button
            entity: script.pentair_lights_california_sunset
            name: California Sunset
            icon: mdi:weather-sunset
            tap_action:
              action: call-service
              service: script.pentair_lights_california_sunset
      - type: vertical-stack
        cards:
          - type: entity-button
            entity: script.pentair_lights_caribbean
            name: Caribbean
            icon: mdi:palm-tree
            tap_action:
              action: call-service
              service: script.pentair_lights_caribbean
          - type: entity-button
            entity: script.pentair_lights_royal
            name: Royal
            icon: mdi:crown
            tap_action:
              action: call-service
              service: script.pentair_lights_royal
```


## Special Thanks

The work here is hugely influenced by [Brian Woodworth's](https://github.com/bwoodworth)'s work via [https://github.com/bwoodworth/hassio-addons](https://github.com/bwoodworth/hassio-addons) and the guts of the decorator is empowered greatly by the work of [Chris Pickett's](https://www.parnic.com/) [node-screenlogic](https://github.com/parnic/node-screenlogic).

A huge thanks to these folks for simplifying the automation of the Pentair system.