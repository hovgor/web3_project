// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract Social {
    uint public unlockTime;
    address payable public owner;

    event _pin(string name, string pin);
    event _unpin(string name, string pinning);
    event _block(string name, string blocking);
    event _unblock(string name, string blocking);
    event _updatemeta(string name, address _userAddress);
    event _deletemeta(string name);




    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    function pin(string memory _name,string memory pinning) public {

        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function unpin(string memory _name,string memory pinning) public {

        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function Block(string memory _name,string memory pinning) public {

        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function unblock(string memory _name,string memory pinning) public {

        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function updateMeta(string memory _name,string memory pinning) public {

        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function deleteMeta(string memory _name, string memory pinning) public {
        console.log("Unlock time is %o and block timestamp is %o", unlockTime, block.timestamp);
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }
}
