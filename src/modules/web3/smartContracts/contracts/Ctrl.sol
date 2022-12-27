// pragma once
// #include <commun/upsert.hpp>
// #include <commun/config.hpp>
// #include <commun/dispatchers.hpp>

// #include <eosio/time.hpp>
// #include <eosio/asset.hpp>
// #include <eosio/transaction.hpp>
// #include <eosio/binary_extension.hpp>
// #include <commun.list/commun.list.hpp>
// #include <vector>
// #include <string>
pragma solidity ^0.8.4;

struct leader_info {
    string name;       
    bool active;     

    uint64 total_weight;  
    uint64 counter_votes; 
    int64 unclaimed_points; 

    function primary_key() return(uint64) {
        return name.value;
    }

    function weight_key() return(uint64){
        return total_weight;
    }
}

//using leader_weight_idx [[using eosio: non_unique, order("total_weight","desc")]] = indexed_by<"byweight"_n, const_mem_fun<leader_info, uint64_t, &leader_info::weight_key>>;
//using leader_tbl [[using eosio: scope_type("symbol_code"), order("name","asc"), contract("commun.ctrl")]] = eosio::multi_index<"leader"_n, leader_info, leader_weight_idx>;

struct leader_voter {
    uint64 id;
    string voter; 
    string leader;
    uint16 pct;

    function primary_key() return(uint64){ return id; }
    string[] key_t = [string,string]
    function by_voter() return(key_t) { return [voter, leader]; }
    function by_leader() return(key_t) { return [leader, voter]; }
};

//using leadervote_byvoter_idx [[using eosio: order("voter","asc"), order("leader","asc")]] = eosio::indexed_by<"byvoter"_n, eosio::const_mem_fun<leader_voter, leader_voter::key_t, &leader_voter::by_voter> >;
//using leadervote_byleader_idx [[using eosio: order("leader","asc"), order("voter","asc")]] = eosio::indexed_by<"byleader"_n, eosio::const_mem_fun<leader_voter, leader_voter::key_t, &leader_voter::by_leader> >;

//using leader_vote_tbl [[using eosio: scope_type("symbol_code"), order("id","asc"), contract("commun.ctrl")]] = eosio::multi_index<"leadervote"_n, leader_voter, leadervote_byvoter_idx, leadervote_byleader_idx>;


struct proposal {
    string proposal_name;
    string commun_code; 
    string permission; 
    string[] packed_transaction; 

    function primary_key() return(uint64) { return proposal_name.value; }
};

//using proposals [[using eosio: order("proposal_name","asc"), contract("commun.ctrl")]] = eosio::multi_index< "proposal"_n, proposal>;

struct approval {
    string approver; 
    int256 time;
};

struct approvals_info {
    string proposal_name; 
    approval[] provided_approvals; 
    function primary_key() return(uint256) { return proposal_name.value; }
};

//using approvals [[using eosio: order("proposal_name","asc"), contract("commun.ctrl")]] = eosio::multi_index< "approvals"_n, approvals_info>;


struct invalidation {
    string account; 
    int256 last_invalidation_time; 

    function primary_key() return(uint64) { return account.value; }
};

//using invalidations [[using eosio: order("account","asc"), contract("commun.ctrl")]] = eosio::multi_index< "invals"_n, invalidation>;

contract control{

    struct stat_struct {
        uint64 id;
        int64 retained;
        function primary_key() return(uint64) { return id; }
    };

    //using stats [[using eosio: scope_type("symbol_code"), order("id","asc")]] = eosio::multi_index<"stat"_n, stat_struct>;
    
    function init(symbol_code commun_code);

    function regleader(symbol_code commun_code, name leader, std::string url);

    function clearvotes(symbol_code commun_code, name leader, std::optional<uint16_t> count);

    function unregleader(symbol_code commun_code, name leader);

    function stopleader(symbol_code commun_code, name leader);

    function startleader(symbol_code commun_code, name leader);

    function voteleader(symbol_code commun_code, name voter, name leader, std::optional<uint16_t> pct);

    function unvotelead(symbol_code commun_code, name voter, name leader);

    function  claim(symbol_code commun_code, name leader);

    function emit(symbol_code commun_code);

    function changepoints(name who, asset diff);

    //    ON_TRANSFER(COMMUN_POINT) void on_points_transfer(name from, name to, asset quantity, std::string memo);

    function propose(ignore<symbol_code> commun_code, ignore<name> proposer, ignore<name> proposal_name,
                ignore<name> permission, ignore<eosio::transaction> trx);

    function approve(name proposer, name proposal_name, name approver,
                const eosio::binary_extension<eosio::checksum256>& proposal_hash);

    function unapprove(name proposer, name proposal_name, name approver);

    function cancel(name proposer, name proposal_name, name canceler);

    function exec(name proposer, name proposal_name, name executer);

    function invalidate(name account);

    function setrecover();

    function check_started(symbol_code commun_code);

    function get_required(symbol_code commun_code, name permission) return(uint8);

    //  std::vector<name> top_leaders(symbol_code commun_code);
    // std::vector<leader_info> top_leader_info(symbol_code commun_code);

    struct leaderstate_event {
        string commun_code; //!< a point symbol of the community to which the leader belongs
        string leader; //!< the leader name
        uint64 weight; //!< total \a weight of the leader
        bool active; //!< \a true if the leader is active
    }

    function send_leader_event(symbol_code commun_code, const leader_info& wi);
    
    function active_leader(symbol_code commun_code, name leader, bool flag);
    
    function get_power(symbol_code commun_code, name voter, uint16_t pct) return(int64);

    function in_the_top(symbol_code commun_code, name account) return(bool){
        // const auto l = commun_list::get_control_param(commun_code).leaders_num;
        // leader_tbl leader(config::control_name, commun_code.raw());
        // auto idx = leader.get_index<"byweight"_n>();    // this index ordered descending
        // size_t i = 0;
        // for (auto itr = idx.begin(); itr != idx.end() && i < l; ++itr) {
        //     if (itr->active && itr->total_weight > 0) {
        //         if (itr->name == account) {
        //             return true;
        //         }
        //         ++i;
        //     }
        // }
        return false;
    }

    function require_leader_auth(symbol_code commun_code, name leader) {
        require(leader);
        require(in_the_top(commun_code, leader), (leader.to_string() + " is not a leader").c_str());
    }

}