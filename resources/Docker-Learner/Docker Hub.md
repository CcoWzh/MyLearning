# docker从创建镜像，到推送至自己的docker hub

### 1. 在docker hub上创建自己的账号

### 2.构建自己的镜像

创建一个目录

```
mkdir -p dockerfile/df_test1
cd dockerfile/df_test1
```

在这个目录下，创建Dockerfile

```
vim Dockerfile

##################################
FROM    ubuntu:16.04
MAINTAINER ccowzh "wuzhihui@gmail.com"

CMD echo "My First Image"
##################################
```

`FROM`：该命令定义了使用哪个基础镜像启动构建流程。

> FROM`命令可能是最重要的Dockerfile命令。基础镜像可以为任意镜 像。如果基础镜像没有被发现，Docker将试图从Docker image index来查找该镜像。FROM命令必须是Dockerfile的首个命令。

`MAINTAINER`

> 这个命令用于声明作者，并应该放在FROM的后面。

`CMD`

> 和RUN命令相似，CMD可以用于执行特定的命令。和RUN不同的是，这些命令不是在镜像构建的过程中执行的，而是在用镜像构建容器后被调用。

### 3. 构建镜像

```
docker build -t ccowzh/first_images:v1.0
-t : 打标签
```

### 4. 测试镜像

```
docker run ccowzh/first_images:v1.0
```

### 5.推送到docker hub

```
docker login               ####登陆docker

####Username: gerrylon # 输入用户名
####Password:

docker pull ccowzh/first_images:v1.0            ##推送镜像到自己的docker hub
```

注意：如果推送不成功，可能是标签打错了，标签打得不标准是推送不上去的。一般是  `作者/镜像名`

