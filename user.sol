pragma solidity ^0.6.0;

contract UserManager {
    address payable public owner;
    
    mapping(uint8 => string) accounts;    //id -> passwd
    mapping(uint8 => address) ips;       //IP address
    
    event Login(uint8 id, uint time);
    event Register(uint8 id,uint time);
    event SetPassword(uint8 id,uint time);
    
    constructor () public {
        owner = msg.sender;
    }

    function login(uint8 id, string memory passwd) public returns (bool) {
        require(ips[id] == msg.sender);
        if ( keccak256(abi.encodePacked(accounts[id]))  == keccak256(abi.encodePacked(passwd)) ) {
            emit Login(id, now);
            return true; 
        }
        return false;
    }
    
    function getIP(uint8 id) public view returns (address) {
        require(ips[id] != address(0));
        return ips[id];
    }
    
    function register(uint8 id, string memory passwd,string memory _passwdAgain) public returns (bool) {
        if (keccak256(abi.encodePacked(_passwdAgain))  == keccak256(abi.encodePacked(passwd))){
            ips[id] = msg.sender;
            accounts[id]=passwd;
            emit Register(id,now);
            return true;
        }
        return false;
    }
    
    function setPassword(uint8 id, string memory passwd,string memory _passwdNew) public returns (bool) {
        require(ips[id] == msg.sender );
        if(keccak256(abi.encodePacked(_passwdNew))  != keccak256(abi.encodePacked(passwd))){
            accounts[id]=_passwdNew;
            emit SetPassword(id,now);
            return true;
        }
        return false;
    }
  }
