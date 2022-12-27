// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Social {

    uint[] blocklist1;
    uint public unlockTime;
    address payable public owner;

    event _pin(string name, string pin,uint val);
    event _unpin(string name, string pinning, uint val);
    event _block(string name, string blocking,uint val);
    event _unblock(string name, string blocking,uint val);
    event _updatemeta(string name, address _userAddress,uint val);
    event _deletemeta(string name,uint val);




    constructor(uint _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time should be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }
 function pin() public{


        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }


    function unpin() public {

      

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function Block() public {

        //Create a blacklist
     

        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
        if(msg.sender!=owner){
            revert("Doesn't belong to this community");

            if(msg.sender!=owner){
                //add it to blocklist 
            }
        }

    }

    function blocklist() external{
      
        blocklist1.push(1);


    }

    function unblock() public {


        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
        if(msg.sender!=owner){
            deleteMeta;
        }
    }

    function updateMeta() public {

      
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }

    function deleteMeta() public {
       
        require(block.timestamp >= unlockTime, "You can't withdraw yet");
        require(msg.sender == owner, "You aren't the owner");
        owner.transfer(address(this).balance);
    }
}
