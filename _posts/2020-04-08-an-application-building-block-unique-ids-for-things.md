---
title: "An application building block: unique IDs for things"
layout: post
tags: software node
---

Ready to build that next startup?  Awesome!  When you start building a new project, especially if it is API based, there is almost an immediate need for identification. If you are building software for humans you are going to need some type of unique identifier.  You need something unique to relate calls back to your persisted data.  There are a lot of options: auto-incremented numbers, GUID/UUID, or hashes (md5, sha).

## Auto Incremented Numbers

Auto incremented numbers are definitely the best for overall database performance.  If we think specifically about RDBMS systems the auto-incremented columns are going to give you the best leverage for database speed.  What you gain is system performance specifically in indexing and scans.  What you lose is security through obfuscation.

If you choose to go with simplistic with database-driven automatically incremented numbers you do end up with extremely transparent endpoints.
```
https://my.amazing.service.io/user/3
```

Estimating the URL necessary to get user number 4’s information is not something that is going to tax you mentally.  I am sure your application will be secure and the customer will be greeted with a 403 HTTP result.  There are other disadvantages too.  You will be disclosing your numbering scheme to the user, if you have multiple customers on a single system you will disclose the size of your operation.  I am not a fan of using the incrementing number system for my public keying.

## GUID / UUID System

In the last decade I have witnessed a huge increase in availability and usage of globally unique identifiers.  If I go back far enough (I am old) we simply did not have storage space for these identifiers.  I still remember when I saw my first GUID out of Microsoft when they started using the DCE format.  These identifiers were massive and the storage space required for them was extreme when you were previously jailed to a 16bit integer (or less).

There are a lot of different formats and versions of the UUID / GUID system and I will not deep dive into them here.  If you have trouble sleeping [I suggest RFC4122](https://tools.ietf.org/html/rfc4122).  For UUIDs there are four standard versions.  Each version calculates the UUID based on different things:

+ Version 1 – date/time capture with a MAC address seeding
+ Version 2 – date/time capture, with MAC address seeding and an applied local domain
+ Version 3 – name based (think namespace with md5)
+ Version 4 – random
+ Version 5 – it is version 3 but uses sha-1 instead of md5

A UUID takes up 36 characters with their familiar dashes or 32 characters if you remove the dashes.

If you opt to go with a UUID / GUID for your unique identifier you will gain some level of security through obfuscation if you chose the right version of the UUID generation. 
```
https://my.amazing.service.io/user/6d72ee7e2c6e40af83f2e4cf1b99f127
```

I use UUIDs so often in my daily work that I have a command line alias to hand me v4 UUIDs on command

```sh
uuid='uuidgen | tr -d '\''\\n'\'' | tr '\''[:upper:]'\'' '\''[:lower:]'\''  | pbcopy && pbpaste && echo'
```

The huge disadvantage with UUID / GUID based identifiers is speed of lookup, indexing and general storage persistence.  As soon as you need to persist the information into storage or memory of any type you are going to fill up your heap space faster than if you used another solution like incrementing integers.

## Hash Keys

Another keying idea would be to hash some type of unique information in a table and use the hash for keying.  The challenge with a hash model is what data do you hash?  Do you end up creating an auto-incrementing key and then hashing that?  If so could your hashes be considered deterministic and thus killing any level of gained obfuscation?  Using this model you may end up disclosing your true key as the base of the system is using a system that has been ultimately hacked. There are a number of available decryption systems for md5 and in 2017 it was announced that SHA-1 had been hacked as well.

## Best Choice

It is my opinion the best choice overall for keying is UUID.  I prefer v4 for UUID because I gain additional security through obfuscation and the persistent cost is low such that I would rather purchase the business acceleration by tossing a few more vCPU cycles at it.  Additionally, it adds another layer of security on an application on top of the security provisions already established.  The cost I am paying for is performance.  The question is, how bad is that performance and do benefits outweigh the cost?

## Cost of Best Choice: Performance

The largest cost to using a longer key is storage performance and retrieval.  The core reason is simply a root cause of the length of the key.  The larger the key the longer the storage and retrieval time.  It is not a linear experience but there is a relationship.  Percona did a [great article on the topic in 2019](https://www.percona.com/blog/2019/11/22/uuids-are-popular-but-bad-for-performance-lets-discuss/)
 where they showed the performance time impact using longer keys. It is a great read.  There are a lot of solutions to deal with the impact to persistence.  The Percona article goes into a few of the solutions such as time-combing the UUIDs (called COMB) or using namespace incrementing UUIDs.  All of these increase the performance of the persistence.  The cost is a loss of some obfuscation.  If you end up using, for example, MySQL’s UUID function you end up with v1 UUIDs which are closely related UUID results.  MySQL does this to help with persistence speed and indexing speed.

```
53ed6a15-79de-11ea-a54e-06361eb6aa50
53ed6a23-79de-11ea-a54e-06361eb6aa50
53ed6a27-79de-11ea-a54e-06361eb6aa50 
```

## The Real Truth

The truth of the matter with performance is that with startups these can always be future problems and acceptable technical debt.  Few people are going to launch the next Twitter or Facebook.  The reality is that 99% of the time the costing to have longer-than-desired lookup times is not something that will grind your business to a halt.  Do not allow yourself to analyze your cycles into a proverbial corner where you are not completing features.

## My Suggestion: PKs, UUIDs, v4, and Base-58

I use a combination of an auto-incrementing primary key, a unique v4 generated UUID and I store and expose that key in base-58.  This gives me a lot of advantages.

### PKs - Auto-Incrementing Integer

I use an auto-incrementing number to gain the index power of a primary key for joins on my tables.  Those indexes are short and sweet and are powerful for table joins.  I tend to use a lot of graphql or single-key multiple-join style requests.  With that style of request, I am typically looking up a single UUID then joining tables to send a single result set.  Thus, I gain from the speed of the PK joins based on a single incoming UUID.

### UUIDs v4

For public-facing keys I use version 4 UUIDs.  I do this solely for uniqueness and obfuscation to the user.  If they request a few different UUIDs they are not going to feel consistent.  It also hides the true age of my data source.  I am not going to have a situation where a customer can estimate usage, activity, or my customer count from my software.

```
❯ uuid; uuid; uuid; uuid;
c3f46e03-487e-4866-8bad-0f8b12217467
2854c1c8-85cc-41d2-bd1a-e2c75730ab9e
16df5da0-08b3-4b62-a44f-64fd50fcc7d4
a82da042-5a7d-44ad-8908-80260a6950f7
```

### Base-58 – My Shrink

I know from my own research and underscored by the [Percona article](https://www.percona.com/blog/2019/11/22/uuids-are-popular-but-bad-for-performance-lets-discuss/) if I shrink my key representation by a few characters I will gain a performance advantage.  If I take a base-16 UUID and I change the representation of it to base-58 I can shrink my storage demand by almost 1/3.  I go from a 32-character storage demand to a 22-character storage demand.

I do this in NodeJS, for example, using my library here: [uuid-base58](https://www.npmjs.com/package/uuid-base58)

```js
import { uuid58 } from "uuid-base58";

const id = uuid58();
```

## Example Table:

An example table in my solution might look like this:

**User**

|Column | MySQL Type (eg)| Example Data           |
|-------|----------------|------------------------|
| pk    | bigint(11)     | 849                    |
| id    | char(22)       | Hu88dFwakgpn22nasSSAsC |
| first | varchar(32)    | Chris                  |
| last  | varchar(32)    | Schuld                 |
| email | varchar(128)   | cbschuld@gmail.com     |

## You Can... Store it as binary

Yes, one could absolutely store a UUID in binary.  You can store a UUID in a 16-byte string integer.  The challenge comes when you are doing simple debugging.  Every request, every database request requires you to translate it to a readable word and then back to binary.  I have NOT had a situation where this performance hit was something I was willing to replace with ease of use.

In [MySQL 8.0](https://dev.mysql.com/doc/refman/8.0/en/miscellaneous-functions.html) you have some new functions you can use: [`BIN_TO_UUID` and `UUID_TO_BIN`](https://dev.mysql.com/doc/refman/8.0/en/miscellaneous-functions.html#function_bin-to-uuid
).

A lot of my recent work is based on MySQL 5.7 (shout-out to [Amazon Aurora](https://aws.amazon.com/rds/aurora/)) and these functions are not available thus you need to use `UNHEX`.

```sql
SELECT HEX(uuid) FROM MyTable;

SELECT * FROM MyTable WHERE HEX(uuid) = "a82da0425a7d44ad8908-80260a6950f7";
```

## Final Thoughts

There are a lof of different ways to create unique identifiers for objects in software.  My solution is by no means the ultimate and is just my opinion - in fact - I am confident the technical arguments that could spin from the content above are far-reaching.  Regardless of how you decide to do it go build something great!
