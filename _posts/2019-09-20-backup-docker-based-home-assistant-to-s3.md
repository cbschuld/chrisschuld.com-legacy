---
title: Backup Docker-based Home Assistant to S3
layout: post
tags: home-automation linux pi
---

For context I run Home Assistant via Docker (*really via docker-compose*) on a [Raspberry Pi 4](https://amzn.to/2Ok2biy).  Previously I ran it on HASSIO but ran into some outage issues with HASSIO and I desired more control.

I maintain the configuration files at `/opt/homeassistant` thus I use the following script to backup the configuration to AWS S3:

```bash
#!/bin/bash

# Script provides an AWS S3-backed backup for Docker-installed Home Assistant
# ---------------------------------------------------------------------------
# + configured via bash variables below
# + requires use of AWS credential profiles
#   https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_profiles.html

date=$(date '+%Y-%m-%d') # want hour, minute - update to '%Y-%m-%d-%H-%M'
basepath=/opt
filename=homeassistant.tar.gz

storage=STANDARD_IA
profile=homeassistantbackup
bucket=homeassistantbackup
acl=private

# ---------------------------------------------------------------------------
tar czvf ${basepath}/${date}-${filename} ${basepath}/homeassistant
aws s3 cp --profile=${profile} --storage-class ${storage} --acl ${acl} /opt/${date}-${filename} s3://${bucket}/
find ${basepath} -name "*-${filename}" -type f -mtime +30 -exec rm -f {} \;
```

You need to do a few things:
+ First, you need an [AWS credential profile](https://docs.aws.amazon.com/sdk-for-php/v3/developer-guide/guide_credentials_profiles.html)
+ Next, you'll need to make sure your pathing aligns with mine
+ Finally, I run mine twice a month because I do not mess with HomeAssistant frequently and desired the twice a month cadence

Note: this script will hold the files for 30 days on the local device before destroying them via the `find` and `exec` command.

```
# CRON things
0 2 */15 * * /bin/bash /opt/backup.sh
```