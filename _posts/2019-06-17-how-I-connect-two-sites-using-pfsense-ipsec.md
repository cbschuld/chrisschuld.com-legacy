---
title: How to connect two pfSense routers via IPSec
layout: post
tags: networking pfsense
---

**Challenge Summary:** I work from two different physical locations. Both locations have traditional retail Internet service providers (ISPs). What makes traveling between two locations tricky is access to local network items such as shared drives, sensor devices, servers, etc. What I really want is one big network and not have two unique networks.

**Solution:** My networks at each location are both routed using pfSense (community edition). I bond both pfSense instances together via an IPSec tunnel and both networks are accessible via the two pfSense gateways/routers.

**Caveats:** I am a software engineer by trade, I know just enough networking to be dangerous and all of my education is based on working through problems I encountered in normal course of other projects.

First, before we begin, everything I learned to set this up I learned from reading the docs over at Netgate. The [write-up to do this on Netgate](https://docs.netgate.com/pfsense/en/latest/book/ipsec/site-to-site.html) is really good. It can be used as a reference for sure. This article is self-fulfilling provides me a fast paint-by-number way to rebuild my setup if I ever need to.

Both of my physical locations have small [/24](https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing) networks.

Location Alpha | 10.0.0.0/24
Location Bravo | 10.1.0.0/24

Both of them the router sits at the dot one.

pfSense Location @ Alpha | 10.0.0.1/24
pfSense Location @ Bravo | 10.1.0.1/24

## Dyanmic DNS and the FQDN

Do yourself a huge favor and setup fully qualified domain names (FQDN) for each of your locations. I do this via Route53 in AWS but there are a lot of 3rd party solutions that work great. Do no proceed until you have FQDNs for each location. I'll refer to these as "FQDN for Location A" and "FQDN for Location B"

## Twice?

You need to do these steps essentially twice, one on each pfSense instance. One at **Location A** and one at **Location B**. In each case I'll show a screen shot and a table that shows what values I used to link the routers and create the tunnel.

# Step 1 - the P1s

First, click on **VPN → IPSec** on each
![](/public/images/pfsense/ipsec-vpn-ipsec.png)
Next, on each, click on **Add P1**

## General Information

![](/public/images/pfsense/ipsec-p1-general-information.png)

| General Information  | Location A                     | Location B                     |
| -------------------- | ------------------------------ | ------------------------------ |
| Disabled             | _unchecked_                    | _unchecked_                    |
| Key Exchange version | IKEv2                          | IKEv2                          |
| Internet Protocol    | IPv4                           | IPv4                           |
| Interface            | WAN                            | WAN                            |
| Remote Gateway (red) | FQDN of Location B             | FQDN of Location A             |
| Description (yellow) | IPSec Location A to Location B | IPSec Location B to Location A |

## Phase 1 Proposal (Authentication)

![](/public/images/pfsense/ipsec-p1-proposal.png)

| Phase 1 Proposal (Authentication) | Location A                                                           | Location B                         |
| --------------------------------- | -------------------------------------------------------------------- | ---------------------------------- |
| Authentication Method             | Mutual PSK                                                           | Mutual PSK                         |
| My identifier                     | My IP address                                                        | My IP address                      |
| Peer identifier                   | Peer IP address                                                      | Peer IP address                    |
| Pre-Shared Key                    | Tap "Generate new Pre-Shared Key a few times, select one and save it | Copy the key from the other router |

| Phase 1 Proposal (Encryption Algorithm) | Location A                          | Location B                          |
| --------------------------------------- | ----------------------------------- | ----------------------------------- |
| Encryption Algorithm                    | AES, 256 bits, SHA256, 14(2048 bit) | AES, 256 bits, SHA256, 14(2048 bit) |
| Lifetime (Seconds)                      | 28800                               | 28800                               |

## Advanced Options

![](/public/images/pfsense/ipsec-p1-advanced-options.png)
**Leave all of the options as the default**

**Hit Save and create the P1 on each of the devices**

# Adding a Phase Two to each Phase One

Return back to the list of Phase One(s) and expand the P2. Hit Add.

## General Information

![](/public/images/pfsense/ipsec-p2-general-information.png)

| General Information   | Location A                                                          | Location B                     |
| --------------------- | ------------------------------------------------------------------- | ------------------------------ |
| Disabled              | _unchecked_                                                         | _unchecked_                    |
| Mode                  | Tunnel IPv4                                                         | Tunnel IPv4                    |
| Local Network         | LAN subnet                                                          | LAN subnet                     |
| NAT/BINAT translation | None                                                                | None                           |
| Remote Network (red)  | The network of the **opposite** network - so network for Location B | Network of Location A          |
| Description (yellow)  | IPSec Location A to Location B                                      | IPSec Location B to Location A |

## Phase 2 Proposal (SA/Key Exchange)

![](/public/images/pfsense/ipsec-p2-general-information.png)

| Phase 2 Proposal (SA/Key Exchange) | Location A                                                                       | Location B                     |
| ---------------------------------- | -------------------------------------------------------------------------------- | ------------------------------ |
| Protocol                           | ESP                                                                              | ESP                            |
| Encryption Algorithms              | AES256-GCM (128 bits)                                                            | AES256-GCM (128 bits)          |
| Hash Algorithms                    | _empty_                                                                          | _empty_                        |
| PFS key group                      | you can really choose any; just make sure they align, netgate suggests none here | just mirror the other location |

## Phase 2 Proposal (SA/Key Exchange)

![](/public/images/pfsense/ipsec-p2-advanced.png)

Here you will want to put an address on the remote LAN to ping to "keep alive" the tunnel, I am lame and I put the address of the pfsense box on the remote network to use for the ICMP packet. Thus, I put 10.0.0.1 and 10.1.0.1 in the respective opposite routers.

**Next, apply the settings**

Next, travel to **Status → VPN** from there you'll see the ability to "Connect" and test out the link.

When you click _Connect_ it should connect and then you should be able to ping assets from both networks from both locations. There are a lot of advanced topics such as static routes but since you are most likely using the pfSense router as a gateway at both sites the routing should happen _automagically_. In my experience the speed is incredible and I am using to residential connections and it works amazingly well.

Finally, an edit by a reader, Rasmus Hansen, who pointed out that you should add a firewall rule to allow the traffic to flow in the IPsec tunnel. Here is how you apply that traffic rule. Click on **Firewall** --> **Rules** --> **IPsec** --> **Add**. Then, fill in the following:

<img class="screenshot" src="/public/images/pfsense/ipsec-fw-rules.png"/>
<img class="screenshot" src="/public/images/pfsense/ipsec-fw-rule.png"/>

I suspect mileage may vary here but good luck!
