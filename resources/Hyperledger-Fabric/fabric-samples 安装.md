# hyperledger fabric-samples 安装

### 前文

首先按照官方文档，hyperledger fabric的环境需要依赖以下这些软件：

```
cURL：需要安装最新版，目前是7.64.0.
Docker和Docker compose：这个非常关键，要谨慎安装，版本也是也是越新越好，当前是1.23
Go：go版本必须是1.11.x，也就是最新版本
node：它是必须8.x，高版本的不支持！
Python：Python2.7，为了可以成功执行npm install命令！ 
```


OK！ 进本的依赖环境已经介绍完了 ，下面介绍一下如何安装，因为可能有些人不会安装，导致运行失败挺可惜的。

### 基本依赖环境安装

#### CURL：

cURL下载链接： 下载cURL
OK ,执行 curl --version 查看下一下是否安装成功.

#### 安装docker和docker compose

##### 安装Docker

```
sudo apt-get install -y curl
curl -sSL https://get.docker.com/ | sh 
```

##### Docker-compose的安装

安装：

```
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

如果安装速度较慢，可以换一个网址：

```
curl -L https://get.daocloud.io/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
```

查看版本：

```
docker-compose -v
```
#### 安装go

去官网下载linux 安装包
下载完成后解压 

```
tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
```
`vim /etc/profile`中添加如下四个环境变量: 

```
export PATH=PATH:/usr/local/go/bin 
export GOROOT=/usr/local/go 
export GOPATH=HOME/go 
export PATH=PATH:HOME/go/bin
```

`source /etc/profile`
使环境变量生效, 自行验证一下go是否安装成功

#### 安装nodejs

版本号必须是8.x(程序员往往会把warning忽略掉,所以这里error仅是为了引起注意)

执行命令

```
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install nodejs
```


即可，使用node -v 命令验证安装成功共与否。

####  安装python

如果是Ubuntu16的话,安装Python很简单 , 只需要一条命令

```
sudo apt-get install python
```


即可,安装完成后,通过python --version 查看一下Python的版本号 必须是2.7.x

### 安装示例,二进制文件,以及docker镜像

官方提供了一个bootstrap.sh的脚本, 该脚本完成三个功能 :

1 ,fabric-samples文件下载 , 

2 , 二进制文件下载 ,

3 , docker镜像的拉取. 

并且这个脚本支持三个参数, 可以灵活地控制它的执行 . 分别是

>-b:加上此参数,则不下载二进制文件
>
>-d:加上此参数则不拉取docker镜像
>
>-s:加上此参数则不下载fabric-samples

在

```
GOPATH/src/github.com/hyperledger目录下执行该脚本 
如果没有此目录,创建即可:mkdir -p GOPATH/src/github.com/hyperledger
```

中间会下载二进制文件到bin目录 ,此步骤执行的特别慢, 往往会断掉. 如果该脚本不能执行成功的, 后面会教你手动完成这三个任务 。

其实也可以不用执行这个脚本, 因为为二进制文件我们可以本地下载后上传至linux系统中, fabric-sample我们也可以手动下载,而docker镜像可以不用提前下载, 因为docker在用到某个镜像时,如果不存在,会自动下载 . 也就是说 ，我们手动完成前两步就可以了。

在不执行该脚本的情况下,我们的操作步骤应该是:(注意当前路径是hyperledger目录)

> 1 , 下载fabric-sample
>
> git clone https://github.com/hyperledger/fabric-samples
> 2 ,下载二进制文件
> 然后下载二进制文件并解压 , 由于官方提供的文件下载速度慢, 我这里提供了一份压缩好的二进制文件 ,方便大家进行下载.

下载完之后解压会形成bin,和config目录, 此时列出当前目录应该有一下文件,而 bootstrap.sh文件可有可无.

然后执行如下命令,赋予bin目录下的文件可执行权限 

```
chmod +x bin/*
```


如果你成功执行了bootstrap.sh脚本 , 直接进行下面的3 即可

3,启动网络
将bin目录设置到系统环境变量中,并使之生效:

在vim /etc/profile中添加

```
export PATH=PATH:GOPATH/src/github.com/hyperledger/bin
```

然后执行

> source profile

通过

> peer version
>
> 命令来验证你的二进制文件,以及环境变量的配置是否成功，成功后的提示信息：



进入目录

进入first-network文件夹

```
cd ./first-network/
```

启动first-network

```
./byfn.sh up
```

如果出现如下页面 , 那么恭喜你,你的超级账本1.4的环境已经搭建成功了! 

#### 测试

```
docker exec -it cli bash
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
```

