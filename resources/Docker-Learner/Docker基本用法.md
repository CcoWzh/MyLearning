# Docker的简单使用

docker的使用手册

```
https://docs.docker.com/install/linux/docker-ee/ubuntu/
```

### 1.如何启动容器

启动一次：

```
docker run IMAGE [COMMAND][ARG]
run 容器 + 命令 + 参数
```

启动交互式容器：

```
docker run -i -t IMAGE /bin/bash
可以和运行的容器进行交互，比如
docker run -i -t ubuntu /bin/bash，这样就进入了Ubuntu系统，操作Ubuntu系统
```

### 2.查看容器

```
docker ps [-a][-l]
-a : 列出所有的容器
-l : 列出最新创建的容器
当没有参数的时候，默认返回当前**活跃**的容器
```

### 3.删除容器

```
docker rm 6e34735928f5（容器）
```

这个只能删除停止的容器，不能删除正在运行的容器

----

#### 删除所有镜像

停止所有的container，这样才能够删除其中的images：

```
docker stop $(docker ps -a -q)
```

如果想要删除所有container的话再加一个指令：

```
docker rm $(docker ps -a -q)
```

删除所有镜像：

```
docker rmi $(docker images -q)
```

----

### 4.守护式容器

在大多数的情况下，我们需要一个能长期运行的容器，来提供服务。这就是docker的守护式容器

--可以长期运行

--没有交互式会话

--适合运行应用和服务

---

#### 以守护形式运行交互式容器：

使用命令运行一个名为test的交互式容器：

```
{ docker run --name=test -i -t ubuntu /bin/bash }
```

然后按`Ctrl+P`和`Ctrl+Q`退出会话，容器在后台运行。

如果想恢复会话可以使用命令：

```
docker attach 容器
```

#### 启动守护式容器：

命令为：

```
docker run -d IMAGE COMMAN
```

#### 停止守护式容器：

```
docker stop 容器 
##发送一个信号给容器，等待容器停止。
docker kill 容器 
##强行停止容器。
```

#### 查看守护式容器的日志：

命令：

```
docker logs -f [--tail] 容器名
-f --follows=true|false 默认为false        一直跟踪认知变化并且返回结果
-t --timestamps=true|false 默认为false     再返回的结果中加入时间戳
--tail 数字 默认为all                      返回结尾处多少数量的日志
```

#### 查看守护式容器内部进程：

命令：

```
docker top 容器名
```

#### 在运行的容器中启动新进程：

  命令：

```
docker exec -d [-t] 容器 COMMAND
```

----



