#  gRPC系列之go语言的使用（1）

### 0. 配置环境

#### Install gRPC

Use the following command to install gRPC.

```
$ go get -u google.golang.org/grpc
```

#### Install Protocol Buffers v3

Install the protoc compiler that is used to generate gRPC service code. The simplest way to do this is to download pre-compiled binaries for your platform(protoc-<version>-<platform>.zip) from here: https://github.com/google/protobuf/releases

- Unzip this file.
- Update the environment variable PATH to include the path to the protoc binary file.

#### install the protoc plugin for Go

```
$ go get -u github.com/golang/protobuf/protoc-gen-go
```

编译器插件protoc-gen-go将安装在 GOBIN中，默认为​ GOPATH / bin。它必须在你的​ PATH中，协议编译器protoc才能找到它。

````
$ export PATH=$PATH:$GOPATH/bin
````

### 1. 编写proto文件

````
syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.helloworld";
option java_outer_classname = "HelloWorldProto";

package helloworld;

// The greeting service definition.
service Greeter {
    // Sends a greeting
    rpc SayHello (HelloRequest) returns (HelloReply) {}
    // Sends another greeting
    rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
    string name = 1;
}

// The response message containing the greetings
message HelloReply {
    string message = 1;
}
````

`.proto`生成 go 代码：

```
root@cc-virtual-machine:~/go/src/testGRPC# ls
main.go  proto
root@cc-virtual-machine:~/go/src/testGRPC# protoc -I proto/ proto/helloworld.proto --go_out=plugins=grpc:proto
```

说明：`--go_out=plugins=grpc:proto`为生成 go 代码的文件夹；`proto/helloworld.proto`为`proto`文件的存放地址。

### 2. 写go 的服务端

```
package main

import (
	"context"
	"google.golang.org/grpc"
	"log"
	"net"
	//pb "google.golang.org/grpc/examples/helloworld/helloworld"
	pb "testGRPC/proto"
)

const (
	port = ":50051"
)

// server is used to implement helloworld.GreeterServer.
type server struct{}

// SayHello implements helloworld.GreeterServer
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.Name)
	return &pb.HelloReply{Message: "Hello " + in.Name}, nil
}

func (s *server) SayHelloAgain(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	return &pb.HelloReply{Message: "Hello again " + in.Name}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterGreeterServer(s, &server{})
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

### 3. 写客户端

```
package main

import (
	"context"
	"log"
	"os"
	"time"

	"google.golang.org/grpc"
	//pb "google.golang.org/grpc/examples/helloworld/helloworld"
	pb "testGRPC/proto"
)

const (
	address     = "localhost:50051"
	defaultName = "hui"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial(address, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn)

	// Contact the server and print out its response.
	name := defaultName
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.Message)

	r, err = c.SayHelloAgain(ctx, &pb.HelloRequest{Name: "say again hui"})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.Message)
}
```



