---
layout: post
title: "Weekly Reading #1"
description: ""
category: 
tags: []
---

{% include JB/setup %}

I've been away for almost a month! I was busy with moving house and travelling in Hokkaido. 

As promised, I am going to publish the little project I've been working on. 

[http://housing.andyh.io](housing.andyh.io)

This is a simple dashboard to show the house prices of Tokyo. It should be pretty straightforward to use. Although it might need some explanation on how the prices work.

The price is based on the whole flat/house since it's difficult to parse/calculate the price per metre square. Because I am only interested in the trends of the prices, the current price model should be good enough to reflect them.

The web app is running inside Docker containers using Docker Machine + DigitalOcean. Redis is chosen as datastore and Nginx is used to route the request to the upstream Go server. 

Ok, that's it. Let me share some interesting readings.

# Dapper, a Large-Scale Distributed Systems Tracing Infrastructure

[http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/36356.pdf](http://static.googleusercontent.com/media/research.google.com/en//pubs/archive/36356.pdf)

This is an old paper(2010). It explained Google's internal distributed tracing system. The idea is quite simple actually. A context is attach to the requests as identity. The trace data is written to local log files and then is pulled from production. Later the data will be written to data store so that the overhead of tracking is minimised in production. There are some open source implementation based on Dapper, e.g. [https://github.com/openzipkin/zipkin](https://github.com/openzipkin/zipkin) from Twitter. 

# How long does it take to make a context switch?

[http://blog.tsunanet.net/2010/11/how-long-does-it-take-to-make-context.html](http://blog.tsunanet.net/2010/11/how-long-does-it-take-to-make-context.html)

1. Context with is expensive
   
2. Avoid cache pollution (No thread migration between cores)
   
   `That's why not creating more active threads than there are hardware threads available is so important, because in this case it's easier for the Linux scheduler to keep re-scheduling the same threads on the core they last used ("weak affinity"`

Happy new year!

