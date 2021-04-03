pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract PersonDID {
    struct Person {
        uint8 id;
        uint8 age;
        string name;
    }
    
    event AddPerson(uint8 id, uint8 age, string name, uint timestamp);
    event SetPersonSynopsis(uint8 id,uint time);
    
    address admin;
    Person[] persons;
    mapping(address => Person) public PersonInfo;
    mapping(address => mapping(address => uint8)) synopsisInfo;
    mapping(address=> bool) public isPersonExsist;
    
    
    mapping(address => mapping (address => uint8)) synopsisCount;
    mapping(address => string) synopsisMain; //Person's synopsis
    
    constructor (uint8 id, string memory name, uint8 age) public {
        Person memory p = Person(id, age, name);
        persons.push(p);
        PersonInfo[msg.sender] = p;
        isPersonExsist[msg.sender] = true;
    }
    
    function getNumberOfPersons() view public returns (uint256) {
        return persons.length;
    }
    
    function addPerson(uint8 id, uint8 age, string memory name) public returns (bool) {
        require(!((id == 0) || age == 0), "persons info can not be empty!!");
        require(!isPersonExsist[msg.sender], "person can not exsist !!");
        Person memory person = Person(id, age, name);
        persons.push(person);
        PersonInfo[msg.sender] = Person(id, age, name);
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
        require( ip == msg.sender || admin == msg.sender , "only yourself or admin can add!");
        synopsisMain[ip] = _synopsis;
        emit SetPersonSynopsis(id , now);
    }
    
    function show(address ip,uint8 _counts , uint8 _type) public {
        require( ip != address(0) || _counts != 0 );
        require( _type == 0 || _type == 1 , "_type must be 0 or 1" );
        if(_type == 0){
            synopsisInfo[msg.sender][ip] = _counts;
        }else if (_type == 1){
            synopsisCount[msg.sender][ip] = _counts;
        }
    }
    
    function getSynopsis(address ip,uint8 id)public view returns(bool){
        Person storage p = PersonInfo[ip];
        require( p.id == id , "This account is not exsist!");
        if(synopsisCount[msg.sender][ip] > 0){
            synopsisMain[ip];
          return true;
        }
        return false;
    }
    
}
