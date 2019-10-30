# 公钥密码RSA

### 1 介绍

1977年由美国麻省理工学院的三位教授

- ​        Ronald Rivest
- ​        Adi Shamir
- ​        Leonard Adleman

联合发明

### 2 RSA的密钥生成

选择两个大的素数

 ![](http://latex.codecogs.com/gif.latex? \\\p和q) 


计算0

                               ![](http://latex.codecogs.com/gif.latex? \\\phi(n) = (p-1)(q-1)) 

选择两个正整数e和d,满足：

$$
gcd(\phi(n),e)=1;1<e<\phi(n)\\
d \equiv e^{-1}  (mod(\phi(n)))
$$

即，***ed是(p-1)(q-1)的倍数加1***

计算

> $$
> n=p \cdot  q
> $$
>

Bob的公钥是`（n，e）`，对外公布。

Bob的私钥是`（n，d）`，自己私藏。

至于`（p，q ）`，可以是Bob的另一部分私钥，也可以是对所有人（包括Bob ）都保密的。

### 3 基本RSA的加密过程

Alice欲发送明文`m`给Bob，其中`0<m<n `

Alice用Bob的公钥`（n，e）`，计算密文c为

> $$
> c \equiv m^{e}(mod n)
> $$
>

### 4 基本RSA的解密过程

Bob 收到密文`c`后，用自己的公钥和私钥`(n,d)`，计算

$$
c^{d}(modn)=m^{ed}(modn)=m
$$
（因为 $$ed=k*(p-1)(q-1)+1$$，所以 $$m^{ed}(modn)=m$$。这是数论中的一个基本结论）

数论中，根据费马定理，有
$$
\begin{align*}
m^{(p-1)(q-1)+1}(mod n)
& \equiv m(mod n)\\
& \equiv m     &\text{(m<n,n=pq)}
\end{align*}
$$

----

### 5 基本RSA的安全性原理

攻击者Eve已经知道了Bob的公钥是`（n，e）`

> 由n的值求解（p，q）的值，即求解n的大整数分解
>
> n=pq
>
> 但这是一个公认的数学难题（虽然至今并没有证明），暂时还没有有效的算法。

如果Eve知道了（p，q），则他容易知道Bob的私钥d。此时Eve只需要用推广的辗转相除法寻找d，满足
$$
ed \equiv 1(mod(p-1)(q-1))
$$

### 6 基本RSA的另一个安全性漏洞：共模攻击

#### 前提环境

设Bob(1)和Bob(2)有共同的模`n`

Bob(1)和Bob(2)的公钥分别是`（n，e(1)）`和`（n，e(2)） `

#### 场景

Alice欲发送同一个明文`m`给Bob(1)和Bob(2) ，其中0<m<n 

> Alice用两人的公钥，分别计算两个密文

$$
c(1) =m^{e(1)}(modn) \\
c(2) =m^{e(2)}(modn)
$$

#### 攻击者Eve

攻击者Eve获得了两个密文c(1)和c(2) 

攻击者Eve也知道两个公钥`（n，e(1)）`和`（n，e(2)） `

#### 攻击方式

如果`e(1)`和`e(2) `互素，则攻击者Eve 能够计算整数`d(1)`和`d(2)`，满足
$$
e(1)d(1)+e(2)d(2) =1
$$
于是，攻击者Eve 能够计算
$$
\begin{align*}
c(1)^{d(1)}c(2)^{d(2)} (modn)

& \equiv m^{e(1)d(1)}m^{e(2)d(2)} (modn)\\

& \equiv m
\end{align*}
$$
（不妨设d(1)>0，因此d(2)<0，此时需要计算c(2)-d(2) (modn)的逆元）

#### 关键提示：

不同的用户不能共模

（注：2012年的惊人发现）



