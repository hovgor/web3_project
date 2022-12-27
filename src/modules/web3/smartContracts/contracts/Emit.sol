//commun.emit.hpp
//======================================

// #include <eosio/asset.hpp>
// #include <eosio/eosio.hpp>
// #include <eosio/system.hpp>
// #include "config.hpp"
// #include <commun/dispatchers.hpp>
pragma solidity ^0.8.4;

contract emit{

    struct structres{
        struct reward_struct{
            string contract;
            uint time;
        }

        struct stat_struct{
            uint64 id;
            reward_struct[] reward_receivers;

        function get_reward_receiver(string to_contract) return (reward_struct){
            return get_reward_receiver(reward_receivers, to_contract);
        }

        function last_reward_passed_seconds(string to_contract) return(int64){
            return block.timestamp - get_reward_receiver(to_contract).timestamp
        }
        // int64_t last_reward_passed_seconds(name to_contract) const {
        //     return (eosio::current_time_point() - get_reward_receiver(to_contract).time).to_seconds();
        // }

        function primary_key() public return(uint64){ return id;}

        function get_reward_receiver(reward_struct[] list, string to_contract) private return(){
            unit i=0;
            for(; i<list.length; i++){
                if(list[i].contract == to_contract){
                    return list[i].contract == to_contract
                }
            }

            require(i != list.length, to_contract + " wasn't initialized for emission");
            return i;
        }
        }
    }

    function get_continuous_rate(int64 annual_rate) public view return(int64){
    //     static auto constexpr real_100percent = static_cast<double>(config::_100percent);
            uint256 real_rate = annual_rate;                
    //     return static_cast<int64_t>(std::log(1.0 + (real_rate / real_100percent)) * real_100percent); 
            return int64((1.0 + (real_rate / real_100percent)) * real_100percent)
    }


    function init(string commun_code){
        require(msg.sender);
        stats_table(_self, commun_code.raw());

        uint i =0;
        for(;i<stats_table.length;i++){
            if( stats_table[i] == commun_code.raw()){
                return "already exists"
            }
        }

        // auto& community = commun_list::get_community(commun_code);
        uint256 now = block.timestamp;
    //      stats_table.emplace(_self, [&](auto& s) {
    //     s.id = commun_code.raw();
    //     s.reward_receivers.reserve(community.emission_receivers.size());
    //     for (auto& receiver: community.emission_receivers) {
    //         s.reward_receivers.push_back({receiver.contract, now});
    //         }
    //     });  
    }

    function issuereward(string commun_code, string to_contract){
        require(msg.sender);
        stats_table(_self, commun_code.raw());
        // const auto& stat = stats_table.get(commun_code.raw(), "emitter does not exists, create it before issue");
        int64 passed_seconds = stat.last_reward_passed_seconds(to_contract);

        // auto& community = commun_list::get_community(commun_code);
        if (!is_it_time_to_reward(community, to_contract, passed_seconds)) {
             return; // action can be called twice before updating the date
         }
       
       require(is_account(to_contract), to_contract.to_string() + " contract does not exists");

       // auto supply = point::get_supply(commun_code);
        // auto cont_emission = safe_pct(supply.amount, get_continuous_rate(community.emission_rate));

        int64 seconds_per_year = int64_t(365)*24*60*60;
        // auto period_emission = safe_prop(cont_emission, passed_seconds, seconds_per_year);
        // auto amount = safe_pct(period_emission, community.get_emission_receiver(to_contract).percent);

        if (amount) {
        //     auto issuer = point::get_issuer(commun_code);
        //     asset quantity(amount, supply.symbol);

        //     action(
        //         permission_level{config::point_name, config::issue_permission},
        //         config::point_name,
        //         "issue"_n,
        //         std::make_tuple(issuer, quantity, string())
        //     ).send();

        //     action(
        //         permission_level{issuer, config::transfer_permission},
        //         config::point_name,
        //         "transfer"_n,
        //         std::make_tuple(issuer, to_contract, quantity, string())
        //     ).send();
        }

    }

    function is_it_time_to_reward(const commun::structures::community& community, string to_contract, int64 passed_seconds) public return(bool){
        require(passed_seconds >= 0, "SYSTEM: incorrect passed_seconds");
        //return passed_seconds >= community.get_emission_receiver(to_contract).period;
    }

    function is_it_time_to_reward(string commun_code, string to_contract) return(bool){
//        stats stats_table(config::emit_name, commun_code.raw());
//         auto& stat = stats_table.get(commun_code.raw(), "emitter does not exists");
//         auto& community = commun_list::get_community(commun_code);

//         return is_it_time_to_reward(community, to_contract, stat.last_reward_passed_seconds(to_contract));
    }

    function   maybe_issue_reward(string commun_code, string to_contract){
        if (is_it_time_to_reward(commun_code, to_contract)) {
            call_issue_reward_action(commun_code, to_contract);
         }
    }

    function issue_reward(string commun_code, string to_contract){
        require(is_it_time_to_reward(commun_code, to_contract), "it isn't time for reward");
        call_issue_reward_action(commun_code, to_contract);
    }

    function call_issue_reward_action(string commun_code, string to_contract) private(){
//        action(
//             permission_level{config::emit_name, config::reward_perm_name},
//             config::emit_name,
//             "issuereward"_n,
//             std::make_tuple(commun_code, to_contract)
//         ).send();
//     }
    }
}
