# 链码编写hello world（第一）

### 目标

> 1.使用链码相关的API实现一个简单的 Hello World 入门应用
> 2.使用开发测试模式测试 Hello World 应用

**任务实现**

该应用需求较为简单：链码在实例化时向账本保存一个初始数据，key 为 Hello， value 为 World，然后用户发出查询请求，可以根据 key 查询到相应的 value。

### 链码开发

####  1.编写链码

##### 创建文件夹

进入 fabric-samples/chaincode/ 目录下并创建一个名为 hello 的文件夹

```
$ cd hyfa/fabric-samples/chaincode
$ sudo mkdir hello
$ cd hello
```

创建并编辑链码文件

```
$ sudo vim hello.go
```

导入链码依赖包

```
package main

import (
 “github.com/hyperledger/fabric/core/chaincode/shim”
 “github.com/hyperledger/fabric/protos/peer”
 “fmt”
 )
```

##### 编写主函数

```
func main()  {
	err := shim.Start(new(HelloChaincode))
	if err != nil {
		fmt.Printf("链码启动失败: %v", err)
	}
}
```

自定义结构体

```
//自定义结构体
type HelloChaincode struct {

}
```

##### 实现 Chaincode 接口

实现 Chaincode 接口必须重写 Init 与 Invoke 两个方法。

Init 函数：初始化数据状态

```
/**
Init 函数：初始化数据状态
获取参数并判断参数长度是否为2
参数: Key, Value
调用 PutState 函数将状态写入账本中
如果有错误, 则返回
打印输出提示信息
返回成功
 */
func (t *HelloChaincode)Init(stub shim.ChaincodeStubInterface) peer.Response {
	//调用ChaincodeStubInterface.GetStringArgs函数来获取Init所需的参数
	fmt.Println("开始实例化链码….")
	// 获取参数
	//args := stub.GetStringArgs()
	_, args := stub.GetFunctionAndParameters()
	// 判断参数长度是否为2个
	if len(args) != 2 {
		return shim.Error("指定了错误的参数个数")
	}
	fmt.Println("保存数据……")
	// 通过调用PutState方法将数据保存在账本中
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return shim.Error("保存数据时发生错误…")
	}
	fmt.Println("实例化链码成功")
	return shim.Success(nil)

}
```

Invoke 函数

```
/**
Invoke 函数
获取参数并判断长度是否为1
利用第1个参数获取对应状态 GetState(key)
如果有错误则返回
如果返回值为空则返回错误
返回成功状态
 */
func (t *HelloChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	// 获取调用链码时传递的参数内容(包括要调用的函数名及参数)
	fun, args := stub.GetFunctionAndParameters()
	// 客户意图
	if fun == "query"{
		return query(stub, args)
	}
	return shim.Error("非法操作, 指定功能不能实现")

}
```

实现查询函数

```
/**
实现查询函数
 */
func query(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	// 检查传递的参数个数是否为1
	if len(args) != 1{
		return shim.Error("指定的参数错误，必须且只能指定相应的Key")
	}
	// 根据指定的Key调用GetState方法查询数据
	result, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("根据指定的 " + args[0] + " 查询数据时发生错误")
	}
	if result == nil {
		return shim.Error("根据指定的 " + args[0] + " 没有查询到相应的数据")
	}
	// 返回查询结果
	return shim.Success(result)
}
```

#### 2. 链码测试

#####  启动网络

进入` fabric-samples/chaincode-docker-devmode/ `目录

```
$ cd fabric-samples/chaincode-docker-devmode/
docker-compose -f docker-compose-simple.yaml up

docker-compose -f docker-compose-simple.yaml up
```

上述指令启动了一个带有`SingleSampleMSPSolo`orderer profile的网络，并将节点在“开发者模式”下启动。它还启动了另外两个容器：一个包含chaincode运行环境;另一个是CLI命令行，可与chaincode进行交互。创建并加入channel（管道）的指令内嵌于CLI容器中，所以我们下面马上跳转到chaincode调用部分。

##### 构建并启动链码

2.1 打开一个新的终端2，进入 chaincode 容器：

```
$ sudo docker exec -it chaincode bash
```

2.2 编译链码

```
cd hello
go build
```

2.3 启动链码

```
CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=hellocc:0 ./hello
```

命令执行后输出如下：

```
2019-06-11 06:18:30.230 UTC [grpc] HandleSubConnStateChange -> DEBU 006 pickfirstBalancer: HandleSubConnStateChange: 0xc0003a1830, CONNECTING
2019-06-11 06:18:30.232 UTC [grpc] HandleSubConnStateChange -> DEBU 007 pickfirstBalancer: HandleSubConnStateChange: 0xc0003a1830, READY
```

chaincode被peer节点启动，chaincode日志表明peer节点成功注册。注意：现阶段chaincode还没有与任何channel关联。这会在接下来使用`instantiate`指令后实现。

##### 测试：

3.1 打开一个新的终端3，进入 cli 容器

```
$ sudo docker exec -it cli bash
```

3.2 安装链码

```
peer chaincode install -p chaincodedev/chaincode/hello -n hellocc -v 0
```

3.3 实例化链码

```
peer chaincode instantiate -n hellocc -v 0 -c '{"Args":["init", "hello", "world"]}' -C myc
```

3.4 调用链码

根据指定的 key （”Hello”）查询对应的状态数据

```
peer chaincode query -n mycc -c '{"Args":["query","a"]}' -C myc
```

返回查询结果： 

> World

#### 注意：

运行完网络后，再运行时，可能容器明有冲突cli

记得要清空容器

```
docker rm $(docker ps -a -q)
```

