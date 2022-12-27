pragma solidity ^0.8.4;
import "hardhat/console.sol"; 

contract Bonus {
    function claimBonus(address account, string token_code) public pure {
        require(auth_account);

        require(itr != idx.end() && itr->symbol() == token_code, "Nothing to claim");
        require(itr->release <= current_time_point(), "Too early to claim");


    }

    function onTokenTransfer(address from, address to, string quantity,string memo) {
    
    if (_self != to) {
        // transfer funds from contract
        
        require(itr != idx.end() && itr->symbol() == token_code, "Nothing to transfer");
        require(itr->release <= current_time_point(), "Too early to transfer");
        require(quantity <= itr->quantity, "Too many funds requested");

        if (quantity < itr->quantity) idx.modify(itr, eosio::same_payer, [&](auto& w) { w.quantity -= quantity; });
        else idx.erase(itr);
        return;
    }

    bytes account_str[16];
    uint32 release_raw;

    require(r == 2, "Invalid memo string. Available format: 'to: <account> release: <unix-timestamp>'");

    require(is_account(account), "Missing recipient account");
    require(account != _self, "Can't hold funds for self");

    account_tbl table(_self, account.value);
    table.emplace(_self, [&](auto& v) {
            v.id = table.available_primary_key();
            v.quantity = quantity;
            v.release = time_point_sec(release_raw);
        });
    
}