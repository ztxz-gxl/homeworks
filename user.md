# homeworks
作业仓库
# **作业**

1. **必做题**

```solidity
pragma solidity ^0.6.0;

contract UserManager {
    address payable public owner;
    
    //映射表	
    mapping(uint8 => string) accounts;    //id -> passwd
    mapping(uint8 => address) ips;       //IP address
    
    //事件
    event Login(uint8 id, uint time);
    event Register(uint8 id,uint time);
    event SetPassword(uint8 id,uint time);
    
    constructor () public {
        owner = msg.sender;
    }

    //登录
    function login(uint8 id, string memory passwd) public returns (bool) {
    	//判断登录者是否是本人账户
        require(ips[id] == msg.sender);
        //将accounts[id]和passwd转为哈希值进行对比，相同为true
        if ( keccak256(abi.encodePacked(accounts[id]))  == keccak256(abi.encodePacked(passwd)) ) {
        	//触发登录事件
            emit Login(id, now);
            return true; 
        }
        return false;
    }
    
    //获取指定账户ip地址
    function getIP(uint8 id) public view returns (address) {
        require(ips[id] != address(0));
        return ips[id];
    }
    
    //注册
    function register(uint8 id, string memory passwd,string memory _passwdAgain) public returns (bool) {
        //判断用户输入的两次密码是否一致
        if (keccak256(abi.encodePacked(_passwdAgain))  == keccak256(abi.encodePacked(passwd))){
            //将当前账户地址赋给该id的ip地址
            ips[id] = msg.sender;
            //设置账户密码
            accounts[id]=passwd;
            //触发注册事件
            emit Register(id,now);
            return true;
        }
        return false;
    }
    
    //修改密码
    function setPassword(uint8 id, string memory passwd,string memory _passwdNew) public returns (bool) {
        //判断是否为该id的账户
        require(ips[id] == msg.sender );
        //判断新密码与原密码是否相同
        if(keccak256(abi.encodePacked(_passwdNew))  != keccak256(abi.encodePacked(passwd))){
        	//给该账户设置新密码
            accounts[id]=_passwdNew;
            //触发修改密码事件
            emit SetPassword(id,now);
            return true;
        }
        return false;
    }
  }
```

