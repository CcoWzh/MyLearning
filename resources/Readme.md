# 论文简记

#### 1  The Byzantine Generals Problem

​	最早提出拜占庭问题的论文，这个问题是在1982年由Lamport, Shostak, Pease提出，后少人问津。

#### 2 Practical Byzantine Fault Tolerance

​	实用拜占庭容错算法。该算法是Miguel Castro（卡斯特罗）和Barbara Liskov（利斯科夫）在1999年提出来的，解决了原始拜占庭容错算法效率不高的问题，算法的时间复杂度是O(n^2)，使得在实际系统应用中可以解决拜占庭容错问题。该论文发表在1999年的操作系统设计与实现国际会议上（OSDI99）。其中Barbara Liskov就是提出了著名的里氏替换原则（LSP）的人，2008年图灵奖得主。

#### 3 In Search of an Understandable Consensus Algorithm(Extended Version)

​	因为 Paxos 难懂，难实现，所以斯坦福大学教授Diego Ongaro等人在2014年发表了新的分布式协议 Raft。

​	这是翻译论文地址是 ： https://www.cnblogs.com/linbingdong/p/6442673.html

#### 4 Consensus of Subjective Probabilities The Pari-Mutuel Method

​	共识问题是社会科学和计算机科学等领域的经典问题, 已经有很长的研究历史. 目前有记载的文献至少可以追溯到 1959 年, 兰德公司和布朗大学的埃德蒙· 艾森伯格 (Edmund Eisenberg) 和大卫· 盖尔 (David Gale) 发表的“Consensus of subjective probabilities: the Pari-Mutuel method", 主要研究针对某个特定的概率空间, 一组个体各自有其主观的概率分布时, 如何形成一个共识概率分布的问题
#### 5 Algorand : scaling Byzantine agreements for cryptocurrencies

​	Algorand是图灵奖得主Micali教授提出的一种新的共识算法，论文地址：
​	https://people.csail.mit.edu/nickolai/papers/gilad-algorand.pdf

​	和目前流行的DPOS+BFT共识相比，最主要的创新是将proposer和validator的选举随机化：

- proposer：根据随机数选出26个左右的proposer，从中挑选数值最小的节点出块
- validator：按照持有token的比例，通过抽签决定

​	因此，algorand的核心其实是`抽签算法`
