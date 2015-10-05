---
layout: post
title: "Weekly Reading #40"
description: ""
category: 
tags: [tech]
---

{% include JB/setup %}

Inspired by [@fleure](http://www.douban.com/people/fleure/), I’ll give a summary over what I’ve read in the past week. They can be academic papers or articles. 

# Eric Brewer talks about Kubernetes and CAP

[https://medium.com/s-c-a-l-e/google-systems-guru-explains-why-containers-are-the-future-of-computing-87922af2cf95](https://medium.com/s-c-a-l-e/google-systems-guru-explains-why-containers-are-the-future-of-computing-87922af2cf95)

There are two important things in an Internet company: 1. People 2. Machines. It’s probably equally important on how to manage them.

# A Critique of the CAP Theorem

[http://arxiv.org/pdf/1509.05393v2.pdf](http://arxiv.org/pdf/1509.05393v2.pdf)

I put the two CAP related articles together for in interesting read. This paper tries to give a rigid definition of CAP in order to resolve the confusion over the years.

# Solving the Mystery of Link Imbalance: A Metastable Failure State at Scale

[https://code.facebook.com/posts/1499322996995183/solving-the-mystery-of-link-imbalance-a-metastable-failure-state-at-scale/](https://code.facebook.com/posts/1499322996995183/solving-the-mystery-of-link-imbalance-a-metastable-failure-state-at-scale/)

This is probably the most interesting read last week. Essentially, Facebook hacked their own switches and selected a dumb algorithm for routing. As a result, it was really hard for them to debug and find the solution. It made me think at the hardware layer in my own cache project at work.

# Ruby Metaprogramming

[http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/](http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/)

Understood Ruby Metaprogramming a bit. 