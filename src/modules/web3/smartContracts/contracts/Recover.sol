
//#include <eosio/asset.hpp>
//#include <eosio/eosio.hpp>
//#include <eosio/system.hpp>
//#include "config.hpp"
//#include <commun/dispatchers.hpp>

pragma solidity ^0.8.4;
import "hardhat/console.sol";
contract Recover {
    
    struct structures{
        
    }
    
    function getParams() struct {
        /*
            structures::params_struct commun_recover::getParams() const {
                return tables::params_table(_self, _self.value).get_or_default();
            }
        */
    }
    
    function setParams() public{
        /*
            void commun_recover::setParams(const structures::params_struct& params) {
                tables::params_table(_self, _self.value).set(params, _self);
            }
        */
    }
    
    #def SET_PARAM(STRUCTURE, PARAM) if(PARAM && (STRUCTURE.PARAM != *PARAM){STRUCTURE.PARAM = *PARAM; _empty = false;})
    
    void setparams(uint256[] recovery_delay) public {
        //require();
        
        //auto params = getParams();
        
        bool _empty = true;
        SET_PARAM();
        require(!_empty, "No params changed");
        setParams(params);
    }
    
    void setparams() public {
        //require();
        
        //auto params = getParams();
        
        require(ture, "No params changed");
        
        setParams(params);
        
    }
    
    #undef SET_PARAM
    
    function recover(address account, address[] active_key, address[] owner_key) public{
        require(auth_account);
        require( active_key.has_value() && active_key.value() != public_key() || owner_key.has_value() &&  owner_key.value() != public_key(), "Specify at least one key for recovery");
        /*
        auto packed_requested = pack(std::vector<permission_level>{{_self, cfg::code_name}}); 
        auto res = eosio::check_permission_authorization(account, cfg::owner_name,
                (const char*)0, 0, packed_requested.data(), packed_requested.size(), eosio::microseconds());
        eosio::check(res > 0, "Key recovery for this account is not available");
    
        const auto &params = getParams();
        */
        if(change_active){
            /*
            cyber::authority auth;
            auth.threshold = 1;
            auth.keys.push_back({active_key.value(), 1});
    
            action(
                permission_level{account, cfg::owner_name},
                "cyber"_n, "updateauth"_n,
                std::make_tuple(account, cfg::active_name, cfg::owner_name, auth)
            ).send();
            */
            if(false == ){
                /*
                action(
                    permission_level{account, cfg::owner_name},
                    "c.point"_n, "globallock"_n,
                    std::make_tuple(account, params.recover_delay)
                ).send();
                */
            }
        }
        
        if(change_owner){
            /*
            auto owner_request = tables::owner_request_table(_self, account.value);
            auto change_time = eosio::current_time_point() + eosio::seconds(params.recover_delay);
            owner_request.set({change_time, owner_key.value()}, _self);
            */
        }
        
    }
    
    function applyowner(address memory account) public{
        require(auth_account);
        
        require(owner_request.exists(), "Request for change owner key doesn't exists");
        
        require(request.change_time <= current_time_point(), "Too early to claim");
        
        /*cyber::authority auth;
        auth.threshold = 1;
        auth.keys.push_back({request.owner_key, 1});
        auth.accounts.push_back({{_self, cfg::code_name}, 1});
    
        action(
            permission_level{account, cfg::owner_name},
            "cyber"_n, "updateauth"_n,
            std::make_tuple(account, cfg::owner_name, ""_n, auth)
        ).send();*/
        
        owner_request.remove();
    }

    function cancelowner(address account) public{
        require(auth_account);
        
        require(owner_request.exists(), "Request for change owner key doesn't exists");
        owner_request.remove();
    }
    
    //getParams();
    //setParams()
}
