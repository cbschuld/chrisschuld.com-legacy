---
title: "Send an SMS message with Twilio from CloudWatch via SNS"
layout: post
tags: dev twilio aws serverless
---

### Summary

GRRRR my app just blew up, a CloudWatch alarm triggered!  I need the alert on my phone.  In this example we will use [Twilio](https://www.twilio.com/) to send an SMS message to my phone with the details.  (Source code for this is here: )

### CloudWatch Alarms

If you are hosting apps/projects in AWS you will eventually find a need for CloudWatch alarms.  With all things software there are a lot of different ways to elevate an alert from CloudWatch to messaging services *(eg Slack, SMS, etc)*.  When a CloudWatch alarms triggers it produces a JSON payload with the alarm info baked in the payload.  We will use that JSON payload and [Twilio](https://www.twilio.com/) to push the info to a phone via SMS *(or several numbers)*.

### Twilio

You will need a [Twilio](https://www.twilio.com/) account for this example and you'll need a Twilio SID and Auth Token.  I use Twilio for all of my SMS/Voice needs to it's a natural fit to have them send me the SMS message via one of my numbers.

### Serverless (serverless.com)

I use the [serverless.com](https://www.serverless.com/) environment for nearly all of my serverless management.  The system is incredibly good and there are a lot of developers in the ecosystem to help out.

I also build all of my serverless using [Typescript](https://www.typescriptlang.org/) thus you will see me use the template for Typescript.

I am going to call this `sns-to-twilio-sms` so we can start with the following command(s):

```zsh
cd /projects
serverless create --path sns-to-twilio-sms --name sns-to-twilio-sms --template=aws-nodejs-typescript
cd sns-to-twilio-sms
npm install
npm i twilio
```

*Note: not only do we create the serverless project but we also install the assets and add Twilio's SDK into the project*

### serverless.yml file

First, adjust the serverless file to manage the SNS directly.  Typically you'll already have an SNS topic for your alert structure so you'll want to include the ARN for the SNS topic directly.

```yaml
service:
  name: sns-to-twilio-sms

custom:
  webpack:
    webpackConfig: ./webpack.config.js
    includeModules: true

plugins:
  - serverless-webpack

provider:
  name: aws
  region: us-west-2
  runtime: nodejs12.x
  profile: isn
  environment:
    AWS_NODEJS_CONNECTION_REUSE_ENABLED: 1
    TWILIO_ACCOUNT_SID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    TWILIO_AUTH_TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    TWILIO_PHONE_NUMBER: +1XXX5551234

functions:
  send:
    handler: handler.send
    events:
      - sns: arn:aws:sns:us-west-2:xxxxxxxxxx:AlertAllThePeeps
```

### handler.ts

Next, we'll adjust the handlers to call Twilio to make send the SMS message:

```typescript
import { SNSHandler, SNSEvent } from "aws-lambda";
import "source-map-support/register";
import { Twilio } from "twilio";

export const send: SNSHandler = async (event: SNSEvent) => {
  await Promise.all(event.Records.map((record) => {
    const subject = record.Sns.Subject;

    // CloudWatch Alarm Destructuring
    const {
      AlarmName: alarmName,
      NewStateValue: stateValue,
      NewStateReason: reason,
    } = JSON.parse(record.Sns.Message);

    const message = `[${subject}]: ${stateValue}: ${alarmName} (${reason})`;

    const client = new Twilio(
      process.env.TWILIO_ACCOUNT_SID,
      process.env.TWILIO_AUTH_TOKEN
    );

    return client.messages.create({
      body: message,
      to: "+1XXX5554321",
      from: process.env.TWILIO_PHONE_NUMBER,
    });
  }));
};
```

After those files are complete you may need to bump `tsconfig.json` to allow for imports `allowSyntheticDefaultImports`.  Now you are ready to publish the function via serverless.

Finish the job with:
```zsh
sls deploy --stage=prod
```

Next time you publish a CloudWatch alert to your SNS topic it will send you a text via Twilio.
