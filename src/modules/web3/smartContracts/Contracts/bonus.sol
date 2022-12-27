// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Bonus{
   
    address public minter;
    mapping (address => uint) public balances;
    address DappLeader;
    //DappLeader = msg.sender; 
    //Write a condition for bonus


    event Sent(address from, address to, uint amount);


    
    constructor() {
        minter = msg.sender;
    }
   
    

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }


    

//Add a  code for symbol, check if symbol is same in the community
    //require(

    function check_community(address community,uint amount) public{
        require(
            msg.sender == minter);//define above the each and every community stuff
            balances[community]+=amount;
    }



   
    error InsufficientBalance(uint requested, uint available);
    error CantClaimMoney(address from, address to);

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }

    //Add memo string condition



}
