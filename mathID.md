# **作业**

1. mathID.sol

   ```solidity
   pragma solidity ^0.6.0;
   pragma experimental ABIEncoderV2;
        
       struct Person {
           uint8 id;
           uint8 age;
           string name;
       }
       
       event AddPerson(uint8 id, uint8 age, string name, uint timestamp);
       //设置管理员设置个人简介事件
       event SetPersonSynopsis(uint8 id,uint time);
       
       //设置管理员地址
       address admin;
       Person[] persons;
       
       mapping(address => Person) public PersonInfo;
       //设置授权读取个人权限映射（地址=>地址=>次数）
       mapping(address => mapping(address => uint8)) synopsisInfo;
       mapping(address=> bool) public isPersonExsist;
       
       mapping(address => mapping (address => uint8)) synopsisCount;
       mapping(address => string) synopsisMain; //Person's synopsis
       
       constructor (address ip, uint8 id, string memory name, uint8 age) public {
           Person memory p = Person(id, age, name);
           persons.push(p);
           PersonInfo[msg.sender] = p;
           isPersonExsist[msg.sender] = true;
       }
       
       function getNumberOfPersons() view public returns (uint256) {
           return persons.length;
       }
       
       function addPerson(uint8 id, uint8 age, string memory name) public returns (bool) {
           string memory synopsis;
           require(!((id == 0) || age == 0), "persons info can not be empty!!");
           require(!isPersonExsist[msg.sender], "person can not exsist !!");
           Person memory person = Person(id, age, name,synopsis);
           persons.push(person);
           PersonInfo[msg.sender] = Person(id, age, name,synopsis);
           isPersonExsist[msg.sender] = true;
           emit AddPerson(id, age, name, now);
       }
       
       function setPersonAgeSto(address ip, uint8 age) public {
           Person storage p = PersonInfo[ip];
           p.age = age;
       }
       
       function getPersonAge(address ip) public view returns (uint8) {
           return PersonInfo[ip].age;
       }
       
       function setPersonSynopsis(address ip,uint8 id,string memory _synopsis) public {
       //判断是不是本人或者管理员
        require( ip == msg.sender || admin == msg.sender , "only yourself or admin can add!");
        //设置个人简介
        synopsisMain[ip] = _synopsis;
        //触发事件
        emit SetPersonSynopsis(id , now);
    }
       
       //设置授权事件
       function show(address ip,uint8 _counts , uint8 _type) public {
       //判断地址和次数是否为空
        require( ip != address(0) || _counts != 0 );
        //判断输入值是否符合要求
        require( _type == 0 || _type == 1 , "_type must be 0 or 1" );
        //根据选择给予权限
        if(_type == 0){
            synopsisInfo[msg.sender][ip] = _counts;
        }else if (_type == 1){
            synopsisCount[msg.sender][ip] = _counts;
        }
    }
       
       
       //获取个人简介
       function getSynopsis(address ip,uint8 id)public view returns(bool){
       //判断账户是否存在
        Person storage p = PersonInfo[ip];
        require( p.id == id , "This account is not exsist!");
        //判断是否有授权
        if(synopsisCount[msg.sender][ip] > 0){
            synopsisMain[ip];
          return true;
        }
        return false;
    }
    
       
   }
   ```

   
