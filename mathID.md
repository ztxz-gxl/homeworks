# **作业**

1. mathID.sol

   ```solidity
   pragma solidity ^0.6.0;
   pragma experimental ABIEncoderV2;
   
   contract PersonDID {
       //公开管理员地址
       address public admins;
       //设置只有管理员可修改
        modifier OnlyAdmin(){
            require(msg.sender == admins);
            _;
        }
        
       struct Person {
           uint8 id;
           uint8 age;
           string name;
           //添加个人简介
           string synopsis;
       }
       
       event AddPerson(uint8 id, uint8 age, string name, uint timestamp);
       //设置查看个人简介事件
       event Show(uint8 id, uint time);
       //设置管理员设置个人简介事件
       event SetPersonSynopsis(uint8 id,uint time);
       
       Person admin;
       Person[] persons;
       mapping(address => Person) public PersonInfo;
       mapping(address=> bool) public isPersonExsist;
       
       constructor (address ip, uint8 id, string memory name, uint8 age ,string memory synopsis ) public {
           //将部署时输入的个人简介设为空
           synopsis = "";
           admin = Person(id, age, name , synopsis);
           Person memory p = Person(id, age, name ,synopsis);
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
       
       //设置个人简介方法，仅管理员可以修改
       function setPersonSynopsis(address ip,uint8 id,string memory synopsis) public OnlyAdmin {
           Person memory p = PersonInfo[ip];
           p.synopsis = synopsis;
           //触发事件
           emit SetPersonSynopsis(id , now);
       }
       
       //设置变量
       uint8 account = 0;
       //设置展示个人简介方法
       function show(address ip,uint8 id) public returns(bool) {
           //判断查看次数
           if(account < 5){
               Person memory p = PersonInfo[ip];
               p.synopsis;
               //将查看次数累计
               account++;
               //触发查看简介事件
               emit Show(id , now);
               return true;
           }
           return false;
       }
       
   }
   ```

   