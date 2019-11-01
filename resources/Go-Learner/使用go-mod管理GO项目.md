# 使用go-mod管理GO项目

`module`是一个相关`Go`包的集合，它是源代码更替和版本控制的单元。模块由源文件形成的`go.mod`文件的根目录定义，包含`go.mod`文件的目录也被称为模块根。`moudles`取代旧的的基于`GOPATH`方法来指定在工程中使用哪些源文件或导入包。 

##### 总结成一句话，就是：使用`go mod`后，可以在任意目录下建立`go `项目，不要考虑`GOPATH`的影响

### 要求

##### 版本

```
go version >= 1.11
```

##### 环境变量

```
# 通过环境变量GOPROXY设置代理
export GOPROXY=https://goproxy.io

# go mod功能开关，默认是auto，在gopath中不启用
# 可设置为on强制启用
export GO111MODULE=on

win10下，直接设置环境变量即可，GO111MODULE=auto 
```

环境变量 `GO111MODULE` 开启或关闭模块支持，它有三个可选值：off、on、auto，默认值是 auto：

```
GO111MODULE=off 无模块支持，go 会从 GOPATH 和 vendor 文件夹寻找包。
GO111MODULE=on 模块支持，go 会忽略 GOPATH 和 vendor 文件夹，只根据 go.mod 下载依赖。
GO111MODULE=auto 在 $GOPATH/src外面且根目录有 go.mod 文件时，开启模块支持。
```

在使用模块的时候，`GOPATH `是无意义的，不过它还是会把下载的依赖储存在 `$GOPATH/pkg/mod` 中，也会把 `go install` 的结果放在 `$GOPATH/bin`中。

### 使用mod

#### 一个例子

```
$ mkdir -p /tmp/scratchpad/hello
$ cd /tmp/scratchpad/hello
```

生成`go.mod`文件：

```
$ go mod init hello 
```

写测试文件：

```
package main

import (
	"fmt"
	"github.com/jinzhu/configor"
)

func main(){
	fmt.Println("使用外部包测试： ",configor.Config{})
}
```

测试：

```
go run main
```

之后会在`go.mod`文件里生成：

```
require github.com/jinzhu/configor v1.1.1 // indirect
```

即，成功使用了mod管理项目了

#### go get 下载/升级依赖

go mod不再下载源码进`$GOPATH/src`

go mod的下载目录在`$GOPATH/pkg/mod`，并且是文件权限是只读的`-r--r--r--`

```
# tag必须以v开头 v1.2.3格式
go get -u xxx.com/pkg@2.1.0
```

### 参考

[Go 1.11 Modules 官方说明文档](https://github.com/golang/go/wiki/Modules) 

[Go Module 入门使用](https://segmentfault.com/a/1190000016676359)

