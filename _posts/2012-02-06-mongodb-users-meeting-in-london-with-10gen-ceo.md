---
layout: post
title: "MongoDB Users Meeting in London with 10gen CEO"
category: database
tags: [NoSQl, London, MongoDB]
---
最初是 10gen 发来的邮件说，CEO Dwight Merriman（他也是 MongoDB 最早的作者） 会出席 MongoDB 用户的伦敦聚会，并做一次 presentation，内容是使用 MongoDB 的一些 tricks。我看到标题就激动了，立刻把这件事放在行程表上。

原来 Dwight 不仅仅只是出席一次聚会，他会在伦敦呆 6 个月，原因很简单：[Silicon Roundabout](http://en.wikipedia.org/wiki/Old_Street_Roundabout#Silicon_Roundabout)，一个伦敦科技创业公司聚集的地方。10gen 自己的办公室也在这附近，就在 [Museum of London](http://www.museumoflondon.org.uk/) 的正对面。 不得不说，MongoDB 真是经营有方。后来的 presentation 里，某位公司的员工就说，他们在设计 schema 的时候就经常会去
10gen 的 office 寻求帮助。其实能与业界频繁接触绝对是好事，很多问题，在设计阶段是根本无法考虑到的，只有用到生产中才能遇见。

好，说说 presentation 内容吧。Dwight 的内容毫无疑问是摆在最后的。

第一个是 10gen 的工程师（他是 PHP Driver 的作者）说 PHP Driver，我没仔细听。但是他阐述了 10gen 在写 Driver 时候的一个原则，那就是除了语言的自身语法，让所有语言的 driver 都一样，并且最重要的是和 JS console 也一样。他在现场问了谁在用 PHP，目测大约一半人举了手，还算是不少。

第二个演讲的是来自 [Canonical](http://www.canonical.com/) 的工程师，Mark Baker。他演示了 [juju](https://juju.ubuntu.com/) 这个管理工具，几分钟内在 AWS 上部署了几台基于 MongoDB 的服务器，看上去非常方便。Mark 在介绍的时候就说: It is hard to manage your deployment in cloud computing environment, so we came up with this to relief your work. 不过也不知道谁在生产环境中用过这个分布式的包管理系统，它的可靠性如何。

第三个演讲来自 [rangespan](http://www.rangespan.com/)，工程师的名字没记住。公司成立是因为 Jeff Bezos 不答应他们做一项业务，所以这帮 Amazon 前员工就自己出来做了。他们用 MongoDB 里的 [oplog](http://www.mongodb.org/display/DOCS/Replica+Sets+-+Oplog) 来实现 pub/sub model，挺有创意的想法。具体实施就是，在对数据做 replica 后，他们监听 oplog，并在一个时间间隔对 oplog 实行一次 tail。因为 oplog 本身是是一个 capped collection，所以所有
records 的排序是按照插入时间排序的。所以他们 tail 到的数据也都是最新的。他们用 Python 来做这件事情，因此使用了
generator。然后把抓到的数据放在一个 json 里 post 到 [Apache Solr](http://lucene.apache.org/solr/#intro)。

最后，是 Dwight 老师的 presentation。总体上有些失望，因为相比以前，没说什么新内容，但比我看的其他 slides 更具体，所以还算有价值。

他抛出的第一个概念就是: *为什么使用 BSON*？

用 BSON 的最大坏处是占空间，我做过实验，一张有一千万条 records 的表（collection），两个都不包括 index，MySQL 大概占480MB 的空间，而 MongoDB 却占到 880MB 之巨，近乎两倍。Dwight 的解释是，使用 BSON 能加快 scan 的速度，在对一个 record 检索时，能省略过一些大的 objects，比如一些二进制文件。所以所有 record 的 field name 都储存在 BSON 里。因此，Dwight 也给出建议，在存储海量数据时，适用短的 field name 来节省空间。

Dwight 这说出了在 2.0 里的一个重要新 feature，**那就是 index 放弃使用 BSON，（可能确实之前人们对 MongoDB 吃存储空间意见太大），而转用占用空间更小的数据格式。他给出的数据是，新的格式能够节省 25%  的空间，并且增加 20% 的性能。**

Dwight 还讨论了 record 在插入新数据后的情况。新数据插入后，一个 record 的 size 自然增加，所以会导致原来分配的存储空间不够，因此数据需要转移到一个更大的空间。如果经常这样迁移一个 record，又有 index 指向这个 record，index 也需要重新再建，整个数据库的性能会急剧下降。所以 MongoDB 使用 [padding factor](http://www.mongodb.org/display/DOCS/Padding+Factor) 来解决这个问题。但这又带来了新问题，如果做了 replica set，Primary nodes 里的 padding factor 会与 secondary nodes
里的不同。说到这时，我背后一个大叔举起了手，深情的说：谢谢你创造 MongoDB，我很喜欢。我给个建议吧，你用一个 pointer 指向那个新的存储空间的地址就完事了。Dwight 老师听闻一笑，说，this could be a good way to solve it, I will think about it. 后来身后的一个胖叔也举起手介绍了 MySQL 的解决方法，不过我没听清。

剩下的内容都是他或者其他 10gen 员工之前在各种场合讲过的，比如 index 的增加会降低写的性能，比如 index 和 RAM 的关系，这个 stackoverflow [页面](http://stackoverflow.com/questions/2811299/mongodb-index-ram-relationship) 回答的很好。（两个答案都好）

最后 Dwight 老师说了如何 cash 的问题，因为 MongoDB 使用了 Memory-Mapped，所以 cache 是交给 OS 做的（采用 LRU 策略）。所以对一些数据可以尽量的将他们放到同一个 page （4K）上。他用了 Twitter 作为例子，所有的 tweet 是一个 collection，如果单从 author 去找他最近发过的 tweets，可能会访问磁盘上多个地方。如果新建一个 collection，每个文档是某一用户最近发的 tweet，那么查询效率和 cache 效率都会高很多。但是 Dwight 也说，这会增加 programmer
的许多额外工作，所以 don't do it until you really have to. 

嗯，差不多就是这些内容。

说些题外话，这次 meeting 是通过 [meetup](http://www.meetup.com/) 组织的，体验非常好，无论是 web 端还是 Android 客户端。

{% include JB/setup %}
