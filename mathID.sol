pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract PersonDID {
    address public admins;
     modifier OnlyAdmin(){
         require(msg.sender == admins);
         _;
     }
     
    struct Person {
        uint8 id;
        uint8 age;
        string name;
        string synopsis;
    }
    
    event AddPerson(uint8 id, uint8 age, string name, uint timestamp);
    event Show(uint8 id, uint time);
    event SetPersonSynopsis(uint8 id,uint time);
    
    Person admin;
    Person[] persons;
    mapping(address => Person) public PersonInfo;
    mapping(address=> bool) public isPersonExsist;
    
    constructor (address ip, uint8 id, string memory name, uint8 age ,string memory synopsis ) public {
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
    
    function setPersonSynopsis(address ip,uint8 id,string memory synopsis) public OnlyAdmin {
        Person memory p = PersonInfo[ip];
        p.synopsis = synopsis;
        emit SetPersonSynopsis(id , now);
    }
    
    uint8 account = 0;
    function show(address ip,uint8 id) public returns(bool) {
        if(account < 5){
            Person memory p = PersonInfo[ip];
            p.synopsis;
            account++;
            emit Show(id , now);
            return true;
        }
        return false;
    }
    
}
