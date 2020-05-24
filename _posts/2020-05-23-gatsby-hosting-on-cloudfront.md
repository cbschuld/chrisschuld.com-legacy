---
title: "Hosting Gatsby Sites on AWS CloudFront"
layout: post
tags: dev gatsby aws
---

*Gatsby is a free and open source framework based on React JS that helps you build incredibly fast websites which you can export in mostly HTML and CSS (and React where you need it).  It's magical!*

### Gatsby Application "Builds"

When Gatsby builds your web/application/site you will notice it builds most of your site in HTML and CSS which is both SEO friendly and fast to the browser.  You can then upload your site to S3 and it will work great.  If you upload your site to CloudFront is may work if you travel directly to the *index.html* file - BUT - when you try to refresh a page in your site it will not work.  That is due to how CloudFront manages the root files.

### S3 vs CloudFront Access Denied 

When you host a Gatsby program on S3 is works perfectly but when you move it to CloudFront you probably get the nasty "AccessDenied" error.  This is because the behavior of CloudFront's default root object is quite different from the behavior of Amazon S3 index documents and how it deals with root objects. When you configure an Amazon S3 bucket as a website and specify the index document, Amazon S3 returns the index document even if a user requests a different subdirectory.  This is absolutely not how CloudFront works thus you get the "AccessDenied" error ([more information](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/DefaultRootObject.html)).

### Lambda to the Rescue

Thankfully with Lambda@Edge we have a chance to get "in front" of the request and change/mutate it before it arrives looking for a file.  We can run a fast lambda function, mutate the request and have the Gatsby Application working perfectly from CloudFront.  Here is how we do it...

# Hosting a Gatsby site on CloudFront in S3

Okay, here we go...

## 1. Create an S3 bucket

In S3 create a bucket for your site, I am fan of calling the bucket the domain you are hosting.  This makes organizational sense to me.  **Also, make sure you select the option to allow public traffic.**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-create-bucket.jpg"/>

## 2. Set the Bucket to act as website

In S3 click on the bucket, then on **Properties** and then on **Static Website Hosting**.  Enable it and set **index.html** as both the index and the error document name.

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-static-website-s3.jpg"/>

## 3. Build your Gatsby project

In this example I created a sample application that we can use to test.  The source is available on Github [https://github.com/cbschuld/gatsby-example.chrisschuld.com](https://github.com/cbschuld/gatsby-example.chrisschuld.com).  The simple Gatsby application illustrates a few pages and this helps explain the difference between hosting on S3 and CloudFront.  After your project is ready you will want to build the project.  You can view it on the [finished CloudFront location](https://gatsby-example.chrisschuld.com/).  It uses [Gatsby](https://www.gatsbyjs.org/), [React](https://reactjs.org/) and [Tailwind](https://tailwindcss.com/).

To build your application/site run:

```zsh
npm run build
```

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-build-application.jpg"/>

## 4. Upload your Gatsby build path

After the build the first step is to sync our files up to S3.  We can easily do this with the AWS CLI.  Make sure you have the AWS CLI - to install on a Mac you can use Brew `brew install awscli`

```zsh
cd /var/www/gatsby-example.chrisschuld.com

aws s3 sync --acl public-read $BASEDIR/build/ s3://gatsby-example.chrisschuld.com/ --profile=cbschuld
```

## 5. SSL Certificate and CloudFront

Next, we need to make sure you have a certificate for your domain in the **Certificate Manager** (or ACM).  If you do not have one for your domain you will want to add one if you intend on hosting content via HTTPS.

After the certificate is in place you are ready to add a **Cloud Front Distribution** click on **CloudFront** and then on **Create Distribution**.  From there select **Web** and set the **Origin Domain Name** to the S3 bucket you created.  Next, set the HTTP and HTTPS settings which fit what you are looking for.  Add your domain to the **Alternate Domain Names (CNAMEs)** and select your certificate from the ACM (if you are doing SSL).  Then hit **Create Distribution**.  Next, take note of the Distribution ID/slug.

## 6. Route53

Now, head over to Route53 and alias your domain name to your CloudFront instance.  You will create a new record in **Route53** for your domain and then select **Alias** and point that to your distribution number.  It will appear in the drop down.

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-route53-alias.jpg"/>

## 7. Lambda@Edge

Next, head over to **Lambda** and click to add a function.  Create a function from scratch call it `originMutation` and then move to the edit screen.  From here we have a few different operations we need to do (and I will go into detail on each one):

+ Put the Node source into the function editor and save it
+ Update the Role to accept trust from **edgelambda.amazonaws.com**
+ Push the function to the Edge for the CloudFront distribution you created above

### 7.1 - Drop in the Node

Here is the simple function to put into your lambda function - it simply tacks on the index.html where necessary

```node
exports.handler = (event, context, callback) => {
  const request = event.Records[0].cf.request;
  const uri = request.uri;

  if (uri.endsWith('/')) {
    request.uri += 'index.html';
  } else if (!uri.includes('.')) {
    request.uri += '/index.html';
  }

  callback(null, request);
};
```

### 7.2 - Update the Role

Next, click on the **Permissions** tab and then click on the **Role**.

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-role.jpg"/>

When the role editor appears, click on the **Trust Relationships** tab

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-role-edit-trust.jpg"/>

Now, update the policy to have both **lambda.amazonaws.com** and **edgelambda.amazonaws.com** in the **Service**:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

### 7.3 push the code

Back in the Lambda editor/viewer click on **Actions** and then on **Deploy to Lambda@Edge**

<img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-deploy-lambda-edge.jpg"/>


## CloudFront Deploying

Next, return to CloudFront (it will say "Deploying" now because it is updating the edge points with your lambda function - magic right?!?).  After it says the Distribution is **Deployed** it will work for you.  Post deployment you will have your Gatsby application/site running via SSL/HTTPS on CloudFront without any **AccessDenied** errors! 🚀

## Video Walk-through 👍

Prefer videos and want to watch how to do it... here I walk through the entire thing for you:

<a href="https://youtu.be/Md284rou07I"><img class="screenshot" src="https://s3-us-west-2.amazonaws.com/chrisschuld.com/images/gatsby-cloudfront-hosting-video-screenshot.jpg"/></a>

