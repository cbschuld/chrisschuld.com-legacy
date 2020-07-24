---
title: "Retrieving Parameters in the AWS Parameter Store with Node/Typescript"
layout: post
tags: dev aws serverless
---

### Summary

If you are storing secrets (passwords/keys) in AWS you can use a few different methods.  *Please do not keep in them in your repos or in your source code!*  Two popular methods on AWS are Parameters in the [SSM Parameter store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) OR using the [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/).  The Parameter store is free but there is no SLA on performance.  The Secrets Manager is expensive.

### Parameter Store

First, create a parameter (encrypted or not).  You do this from SSM --> Parameter Store --> Create.  
<img class="screenshot" alt="aws-parameter-store" src="https://user-images.githubusercontent.com/231867/88430052-a5537300-cdac-11ea-95cf-4c7401271368.png"/>

### Obtain the value using Node

Here is a library I created [stored on gist](https://gist.github.com/cbschuld/938190f81d00934f7a158ff223fb5e02)

```typescript
import { SSM } from "aws-sdk";

const getParameterWorker = async (name:string, decrypt:boolean) : Promise<string> => {
    const ssm = new SSM();
    const result = await ssm
    .getParameter({ Name: name, WithDecryption: decrypt })
    .promise();
    return result.Parameter.Value;
}

export const getParameter = async (name:string) : Promise<string> => {
    return getParameterWorker(name,true);
}

export const getEncryptedParameter = async (name:string) : Promise<string> => {
    return getParameterWorker(name,true);
}
```

### Using the function(s)

```typescript
import { getEncryptedParameter } from "./parameterStore";
.
.
.
  const twilioSID = await getEncryptedParameter("TWILIO_ACCOUNT_SID");
.
.
.

```