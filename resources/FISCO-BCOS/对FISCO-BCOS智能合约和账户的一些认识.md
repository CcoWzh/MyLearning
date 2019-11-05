# 实验五--智能合约

### 0. 智能合约语法

智能合约的语法，可以参考：

- [**Solidity入门知识点集**](https://segmentfault.com/a/1190000019208534#articleHeader29)

- [**官方文档(中文)**](https://solidity-cn.readthedocs.io/zh/develop/)
- [**FISCO BCOS 智能合约开发**](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/manual/smart_contract.html)
- [**智能合约在线编辑器Remix**](https://remix.ethereum.org/ )

个人推荐，可以先看《Solidity入门知识点集》，了解`Solidity`语法的特点和基本知识，会事半功倍。

### 1.智能合约的编写

#### 此用例用到的智能合约`solidity`语法特点，请参考文档[`实验中用到的Solidity的特性语法的说明.md`](./实验中用到的Solidity的特性语法的说明.md)

可以编写`HelloWorld.sol`来练手，在此，我们以智能合约`StudentScore.sol`为例，给学生展示一个完整的合约，对前面三部分内容（前面三个智能合约）进行总结回归。这个一个综合性的合约，用到了有代表性的智能合约的特性、语法，希望学生们可以细细体会。（参考配套文档《实验中用到的Solidity的特性语法的说明》，效果更佳）

#### 合约的场景：

教师需要录入学生的课程成绩信息，将学生成绩上链；学生拥有自己修改自己备注姓名的权利。

#### 先前说明：

```tsx
 msg.sender    //表示当前部署合约的账户地址
```

**本合约使用这个来控制权限，只有部署这个合约的人，才能调用合约中的限定函数**

#### 学生部署`Student.sol`，学生初始化（可修改姓名）

```tsx
contract Student {
    string studentId;
    string studentName;
    address owner;
    //这一步很重要，希望可以好好理解其中的意思
    modifier onlyOwner() {
        if(owner == msg.sender){
            _;
        }
    }
    //构造函数
    constructor(string _studentId, string _stdentName) public {
        studentId = _studentId;
        studentName = _stdentName;
        owner = msg.sender;
    }
    ......
}
```

修改姓名：

```
function getStudentName() public constant returns(string) {
    return studentName;
}
//查询姓名
function setStudentName(string _studentName) public onlyOwner {
     studentName = _studentName;
}
```

#### 教师录入成绩：

```tsx
contract StudentScore {
    uint totalScore;      //全班总成绩
    uint studentCount;    //统计学生数量
    address owner;        //部署合约的账户地址
    //map映射，根据学生ID，存储学生的address和成绩
    mapping (string => address) studentMap; // studentId->student
    mapping (string => uint) scoreMap;      // studentId->score
    //事件
    event studentNotExistsEvent(string studentId);
    //这个用于后面的权限判断，只有部署这个合约的用户，才能调用带有onlyOwner修饰符的方法
    //" _; "一定要添加，它表示使用修改符的函数体的替换位置
    modifier onlyOwner() {
        if(owner == msg.sender){
            _;
        }
    }
    //构造函数
    constructor() public {
        owner = msg.sender;
    }
	...... 
}
```

添加学生成绩：

```
function addStudentScore(string studentId, address student, uint score) public onlyOwner {
        studentMap[studentId] = student;
        scoreMap[studentId] = score;
        totalScore += score;
        studentCount ++;
}
//修改成绩    
function modifyScoreByStudentId(string studentId, uint score) public onlyOwner{
    ......
}
```

查询学生成绩：

```
function getScoreByStudentId(string studentId) public constant returns(string, string, uint){
	......
}
```

判断此学生是否录入过：

```
function studentExists(string studentId) public view returns(bool){
	......
}
```

### 2. 测试

`Remix`智能合约测试网站： https://remix.ethereum.org/ 

编译器功能如图：

![](./img/整体.png)

进入编译器后，**选择对应的智能合约版本**

```tsx
pragma solidity ^0.4.22;      //加了 ^ 之后，表示版本在0.4.22~0.5之间
```

![](./img/版本.png)

进入测试页面后，有5个账户可供选择：

![](./img/账户.png)

选择教师账户,部署`StudentScore.sol`：

![](./img/teacher.png)

选择学生账户，部署`Student.sol`：

![](./img/student1.png)

之后，可测试智能合约：

![](./img/执行.png)

添加学生成绩后，可以查看到交易回执：

![](./img/调用.png)

### 3. 在`FISCO BCOS` 上部署调用

首先，使用脚本`get_account.sh`生成教师和学生这两个角色账户，具体生成方法，请参考[文档](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/manual/account.html)

```tsx
Usage: ./get_account.sh
    default       generate account and store private key in PEM format file
    -p            generate account and store private key in PKCS12 format file
    -k [FILE]     calculate address of PEM format [FILE]
    -P [FILE]     calculate address of PKCS12 format [FILE]
    -h Help
```

生成一个教师账户：

![](./img/教师账户.png)

生成两个学生账户：

![](./img/生成两个学生账户.png)

**分别开三个端口，以`教师`和`学生`的身份登录控制台：**

控制台启动方式有如下几种：

```
./start.sh
./start.sh groupID
./start.sh groupID -pem pemName
./start.sh groupID -p12 p12Name
```

在教师的控制台端，部署`StudentScore.sol`:

![](./img/教师控制台.png)

同理，在另外两个端口，分别以学生身份登录控制台，部署`Student.sol`合约：

![](./img/学生控制台.png)

切换回教师控制台，根据部署的`Student.sol`智能合同地址，录入两个学生的成绩：

![](./img/教师调用.png)

至此，完整的调用流程结束。感兴趣的同学，可以多试试生成多个学生用户，多机部署，分布式调用。

有条件的话，可以在区块链浏览器上查询结果

### 4. 能力提示

使用`SDK`进行区块链的引用开发，详细文档请参考[FISCO BCOS官方文档](https://fisco-bcos-documentation.readthedocs.io/zh_CN/latest/docs/sdk/java_sdk.html) 

配置`SDK`主要是为了可以使用`JAVA`、`nodejs`、`Python`等进行后端产品的开发

在此基础上，可以开发区块链应用程序，前后端一起打造一个区块链落地产品。