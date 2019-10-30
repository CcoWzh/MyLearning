# 论文简记

#### 1 比特币：一种点对点电子货币系统 

中本聪的论文，区块链的开山之作

#### 2 The Byzantine Generals Problem

最早提出拜占庭问题的论文，这个问题是在1982年由Lamport, Shostak, Pease提出，后少人问津。

#### 3 Practical Byzantine Fault Tolerance

PBFT算法，实用拜占庭容错算法。该算法是Miguel Castro（卡斯特罗）和Barbara Liskov（利斯科夫）在1999年提出来的，解决了原始拜占庭容错算法效率不高的问题，算法的时间复杂度是O(n^2)，使得在实际系统应用中可以解决拜占庭容错问题。该论文发表在1999年的操作系统设计与实现国际会议上（OSDI99）。其中Barbara Liskov就是提出了著名的里氏替换原则（LSP）的人，2008年图灵奖得主。

#### 4 In Search of an Understandable Consensus Algorithm(Extended Version)

Raft算法，斯坦福大学教授Diego Ongaro等人在2014年发表的新的分布式协议 

这是翻译论文地址是 ： https://www.cnblogs.com/linbingdong/p/6442673.html

#### 5 Algorand : scaling Byzantine agreements for cryptocurrencies

Algorand是图灵奖得主Micali教授提出的一种新的共识算法，和目前流行的DPOS+BFT共识相比，最主要的创新是是`抽签算法`， 即，使用了`VRF` 随机可验证函数

#### 6 Verifiable Random Functions

随机可验证函数的原论文

#### 7 RapidChain: Scaling Blockchain via Full Sharding

对区块链扩容思考，使用分片的思想提升交易的速度