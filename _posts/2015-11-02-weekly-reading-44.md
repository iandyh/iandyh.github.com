---
layout: post
title: "Weekly Reading #44"
description: ""
category: 
tags: []
---

{% include JB/setup %}

# Yesquel: scalable SQL storagefor Web applications

[http://sigops.org/sosp/sosp15/current/2015-Monterey/106-aguilera-online.pdf](http://sigops.org/sosp/sosp15/current/2015-Monterey/106-aguilera-online.pdf)

Distributed SQL. An ambitious project. It claims it can reach around 80% of Redis performance(Which is impressively fast) in both read and write. The client of Yesquel includes an SQL query processor. The query processor uses SQL queries to manipulate order maps(k-v pairs). The order map is a form of abstraction at the storage engine which is backed by an improved distributed B tree, named YDBT.  The paper largely focuses on the interface that NoSQL cannot provide and the performance, however it didn't discuss anything related to availability, which is a crucial requirement in web applications. Looking forward to its development though.

# The network is reliable

[https://aphyr.com/posts/288-the-network-is-reliable](https://aphyr.com/posts/288-the-network-is-reliable)

It's a collection of many many production incidents reports, or a more brutal word,  postmortems. The conclusion is simple: Your network is NOT reliable and be prepared for the shit.

# Billing Incident Post-Mortem: Breakdown, Analysis and Root Cause

[https://www.twilio.com/blog/2013/07/billing-incident-post-mortem-breakdown-analysis-and-root-cause.html](https://www.twilio.com/blog/2013/07/billing-incident-post-mortem-breakdown-analysis-and-root-cause.html)

I found a Redis report from the second article. The root cause to their Redis production incident: A master was disconnected with its multiple slaves. When the connection was resumed, the multiple `sync` command overloaded the master and it failed. During the restart, the master loaded a wrong configuration file so that it started with a non-existent AOF file instead of an RDB file. As a result, all the data in master was gone. What's worse? The mis-configuration made the master become its own slave and become a read-only slave. So the master cannot be written and read. 

# The Stack That Helped Medium Drive 2.6 Millennia of Reading Time

[https://medium.com/medium-eng/the-stack-that-helped-medium-drive-2-6-millennia-of-reading-time-e56801f7c492#.icmmt1dpv](https://medium.com/medium-eng/the-stack-that-helped-medium-drive-2-6-millennia-of-reading-time-e56801f7c492#.icmmt1dpv)

Summary: Node.js for backend(Shared template backend and frontend). TinyMCE for editor(A really nice rich text editor and I have used it before. So I don't know why Basecamp needs to reinvent the [wheel](https://github.com/basecamp/trix) recently). Closure at the front-end(Google influence). DynamoDB and Redis as storage solution. Interestingly, they use Neo4j to store relations. The first company at this scale I know to use it in production. Protocol buffers to connect some Go services. Other open source tools like Datadog, ElasticSearch, logstash and Kibana can be seen too. Lots of stuff, good read.

