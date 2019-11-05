# 实验中用到的Solidity的特性语法的说明

### 1. import导入其他文件

 当代码过于冗长的时候，最好将代码和逻辑分拆到多个不同的合约中，以便于管理。 

或者需要引入其他文件里的函数时，需要导包，或者继承：

```tsx
pragma solidity ^0.4.20;
 
import "./demo2.sol";  // 导入外部的sol文件。(Test合约)
```

### 2. solidity中的`msg.sender`

它指的是当前调用者（或智能合约）的 address。

> 注意：在 Solidity 中，功能执行始终需要从外部调用者开始。 一个合约只会在区块链上什么也不做，除非有人调用其中的函数。所以 `msg.sender`总是存在的。

一个合约的`msg.sender`是当前与合约交互的地址，可以是用户也可以是另一个合约。

在本实验中，下列代码

```tsx
constructor() public {
        owner = msg.sender;
}
```

就表示的是合约地址。

如果合约中定义了一个名为“owner”的变量，则可以为其分配值（地址）`msg.sender`：

    address owner = msg.sender
此时，变量“owner”将始终具有最初部署合约的人的地址，意味着是合约的所有者。

---

所以，如果是一个用户和合约交互，`msg.sender`是该用户的地址；相反，如果是另一个合约B与该合约交互，合约B的地址将变成`msg.sender`。

总的来说，`msg.sender`将会是当前与某合约交互的用户或另一个合约。

使用它，配合自定义的函数修饰符，可以做到：

- 为它加上一个修饰符 `onlyOwner`，它会限制陌生人的访问，将访问某些函数的权限锁定在 owner 上。

#### **务必注意：`msg.sender`是一个实时变化的变量！在合约中，方法的调用者不一样，`msg.sender`就会不一样!** 

### 3. 映射（Mapping）

映射 是另一种在 Solidity 中存储有组织数据的方法。

```tsx
//对于金融应用程序，将用户的余额保存在一个 uint类型的变量中：
mapping (address => uint) public accountBalance;
//或者可以用来通过userId 存储/查找的用户名
mapping (uint => string) userIdToName;
```

> 映射本质上是存储和查找数据所用的键-值对。在第一个例子中，键是一个 address，值是一个 `uint`，在第二个例子中，键是一个`uint`，值是一个 string。

### 4. 一些关键字

#### 1. 函数可见性定义符(Function Visibility Specifiers)

```
function myFunction() <visibility specifier> returns (bool) {
    return true;
}123
```

- `public`:在外部和内部均可见（创建存储/状态变量的访问者函数）
- `private`:仅在当前合约中可见
- `external`: 只有外部可见（仅对函数）- 仅仅在消息调用中（通过`this.fun`）
- `internal`: 只有内部可见

#### 2. pure/constant/view/payable 函数的限制访问

constant、view、pure三个函数修饰词的作用是告诉编译器，函数不改变/不读取状态变量，这样函数执行就可以不消耗gas了，因为不需要矿工来验证。

在`Solidity v4.17`之前，只有constant，后续版本将constant拆成了view和pure。

### 5. 自定义函数修饰符
我们给一个例子，来看一下函数修改器`onlyOwne`r是怎么定义和使用的？
1. 首先：要定义一个modifier，形式与函数很像，可以有参数，但是不需要返回值；
2. 其次：特殊  `_; ` 是必要的，它表示使用修改符的函数体的替换位置；
3. 最后：使用将`modifier`置于参数后，返回值前即可。 

下面是一个 `Ownable` 合约的例子： 来自 `OpenZeppelin Solidity` 库的 `Ownable `合约。 

- 合约创建，构造函数先行，将其 owner 设置为`msg.sender`（其部署者）
- 为它加上一个修饰符 `onlyOwner`，它会限制陌生人的访问，将访问某些函数的权限锁定在 owner 上。
- 允许将合约所有权转让给他人。

看一下源码：

```tsx
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
      */
    function Ownable() public {

    owner = msg.sender;
  }
  /**
   * @dev Throws if called by any account other than the owner.
      */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
      */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}
```

### 6. 合约的继承及抽象合约的使用

参考资料： 

- [**合约继承**](https://blog.csdn.net/qq_33829547/article/details/80395355 )
- [**抽象合约**](https://blog.csdn.net/qq_33829547/article/details/80399117 )



