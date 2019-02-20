---
title: KVBA (Key / Value Storage with Basic Auth)
layout: project
---

# KVBA (Key / Value Storage with Basic Auth)

[View KVBA on GitHub](https://github.com/cbschuld/kvba)

> A [serverless](https://serverless.com/) based AWS lambda and api gateway enabled key/value store with Basic HTTP Authorization and weak obfuscated account creation.  All keys are partitioned by user scope thus each user maintains their own domain of keys.  Cross-Origin resource sharing (CORS) is also available via the serverless to add protection for call origin.

## Endpoints
**/auth** via **POST** (for account creation and verification)

**/set** via **POST** to add a value to the key/value store

**/get** via **GET** to retrieve a value from the key/value store

## Building
```
export AWS_PROFILE=YOUR_AWS_PROFILE
export AWS_DEFAULT_REGION=us-west-2
npm install
```

### Creating your own
+ Add your profile to the serverless.yml file
+ Add your domains to the serverless if you intend to manage the domains and API gateway with serverless
+ Update the serverless.yml file with other options for your domain(s)
