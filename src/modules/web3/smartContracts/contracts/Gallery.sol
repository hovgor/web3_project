pragma solidity ^0.8.4;
import "hardhat/console.sol"; 


contract gallery {
    //check if these can be defined inside contracts
    enum opus{ post, comment }
    enum stats_t { ACTIVE, MODERATE, ARCHIVED, LOCKED, BANNED, HIDDEN, BANNED_AND_HIDDEN }

    struct mosiacStruct {
        
        uint64 tracery;
        address creator;
        uint64 royality;
        uint256 lock_date = time_point();
        uint256 collection_end_date; 

        uint16 gemCount;
        uint64 points;
        uint64 shares;
        uint64 damnPoints = 0;
        uint64 damnShares = 0;
        uint64 pledgePoints = 0;
        uint64 rewards = 0;
        uint64 commRating = 0;
        uint64 leadRating = 0; 
        uint64 status = 'ACTIVE';

        bool deactivated_xor_locked = 'false';

        bool banned() const { 
            return status == BANNED || status == BANNED_AND_HIDDEN;
        }
        bool hidden()const { 
            return status == HIDDEN || status == BANNED_AND_HIDDEN; 
        }
        bool deactivated()const { 
            return deactivated_xor_locked && status != LOCKED; 
        }

        function lock() public pure {
            require(status == 'ACTIVE','mosaic is inactive');
            require(lock_date == time_point(), "Mosaic should be modified to lock again.");
            require(!deactivated_xor_locked, "SYSTEM: lock, incorrect deactivated_xor_locked value");
            status = LOCKED;
            lock_date = block.timestamp;
            deactivated_xor_locked = true;
        }

        function unlock(uint64 moderation_period) {
            require(status == LOCKED, "mosaic not locked");
            require(deactivated_xor_locked, "SYSTEM: unlock, incorrect deactivated_xor_locked value");
            uint64 now = block.timestamp;
            require(now <= collection_end_date + eosio::seconds(moderation_period), "cannot unlock mosaic after moderation period");
            status = ACTIVE;
            collection_end_date += now - lock_date;
            deactivated_xor_locked = false;
        }

        uint64 primary_key() const { return tracery; };
        
        function by_comm_rating() public pure returns (uint8, uint64, uint64){
            return (status, comm_rating, lead_rating);   
        }
        function by_lead_rating()public pure returns(uint64, uint64){
            return (lead_rating, comm_rating);
        }

        function by_date()public pure returns(bool, uint256){
            return (deactivated_xor_locked, collection_end_date);
        }
        function by_status()public pure returns(uint8, uint256){
            return (status, collection_end_date);
        }
       

    }

    struct gem_struct {
        uint64 id;
        uint64 tracery;

        uint64 points;
        uint64 shares;
        uint64 pledge_points;

        string owner;
        string creator;

        uint64 primary_key() const { return id; }
      
        function by_key() public pure returns (uint64, address, address){
            return (tracery, owner, creator);   
        }
        function by_creator()public pure returns (uint64, address, address){
            return (tracery, creator, owner);
        }

        function by_claim()public pure returns(address, uint256){
            return (owner, claim_date);
        }
        function by_claim_joint()public pure returns(uint256){
            return claim_date; 
        }
    }

    struct inclusion_struct {
        uint64 quantity;
        uint64 primary_key()const { return quantity.symbol.code().raw(); }
    }

    struct stat_struct {
        uint64 id; 
        int64 unclaimed = 0; 
        int64 retained = 0;
        uint128 last_reward_date = time_point();
        uint64 primary_key()const { return id; }
    };

    struct provision_struct {
        uint64 id;
        string grantor;
        string recipient;
        uint16 fee;
        int64 total  = 0;
        int64 frozen = 0;
        int64 available()const { return total - frozen; };
        
        uint64 primary_key()const { return id; }
        
        function by_key() public pure returns (address, address){
            return (grantor, recipient);   
        }
        
    };

    struct advice_struct {
        address leader;
        uint64 favorites;
        uint64 primary_key()const { return leader.value; }
    };
    
    // using mosaic_comm_index [[using eosio: non_unique, order("status","asc"), order("comm_rating","desc"), order("lead_rating","desc")]] =
    //     eosio::indexed_by<"bycommrating"_n, eosio::const_mem_fun<gallery_types::mosaic_struct, gallery_types::mosaic_struct::by_comm_rating_t, &gallery_types::mosaic_struct::by_comm_rating> >;
    // using mosaic_lead_index [[using eosio: non_unique, order("lead_rating","desc"), order("comm_rating","desc")]] =
    //     eosio::indexed_by<"byleadrating"_n, eosio::const_mem_fun<gallery_types::mosaic_struct, gallery_types::mosaic_struct::by_lead_rating_t, &gallery_types::mosaic_struct::by_lead_rating> >;
    // using mosaic_coll_end_index [[using eosio: non_unique, order("deactivated_xor_locked","desc"), order("collection_end_date","asc")]] =
    //     eosio::indexed_by<"bydate"_n, eosio::const_mem_fun<gallery_types::mosaic_struct, gallery_types::mosaic_struct::by_date_t, &gallery_types::mosaic_struct::by_date> >;
    // using mosaic_status_index [[using eosio: non_unique, order("status","desc"), order("collection_end_date","asc")]] =
    //     eosio::indexed_by<"bystatus"_n, eosio::const_mem_fun<gallery_types::mosaic_struct, gallery_types::mosaic_struct::by_status_t, &gallery_types::mosaic_struct::by_status> >;

    // using mosaics [[using eosio: order("tracery","asc"), scope_type("symbol_code"), GALLERY_LIBRARY]] = eosio::multi_index<"mosaic"_n, gallery_types::mosaic_struct, mosaic_comm_index, mosaic_lead_index, mosaic_coll_end_index, mosaic_status_index>;
    
    // using gem_key_index [[using eosio: order("tracery","asc"), order("owner","asc"), order("creator","asc")]] =
    //     eosio::indexed_by<"bykey"_n, eosio::const_mem_fun<gallery_types::gem_struct, gallery_types::gem_struct::key_t, &gallery_types::gem_struct::by_key> >;
    // using gem_creator_index [[using eosio: order("tracery","asc"), order("creator","asc"), order("owner","asc")]] =
    //     eosio::indexed_by<"bycreator"_n, eosio::const_mem_fun<gallery_types::gem_struct, gallery_types::gem_struct::key_t, &gallery_types::gem_struct::by_creator> >;
    // using gem_claim_index [[using eosio: non_unique, order("owner","asc"), order("claim_date","asc")]] =
    //     eosio::indexed_by<"byclaim"_n, eosio::const_mem_fun<gallery_types::gem_struct, gallery_types::gem_struct::by_claim_t, &gallery_types::gem_struct::by_claim> >;
    // using gem_claim_joint_index [[using eosio: non_unique, order("claim_date","asc")]] =
    //     eosio::indexed_by<"byclaimjoint"_n, eosio::const_mem_fun<gallery_types::gem_struct, time_point, &gallery_types::gem_struct::by_claim_joint> >;

    // using gems [[using eosio: order("id","asc"), scope_type("symbol_code"), GALLERY_LIBRARY]] = eosio::multi_index<"gem"_n, gallery_types::gem_struct, gem_key_index, gem_creator_index, gem_claim_index, gem_claim_joint_index>;
    
    // using inclusions [[using eosio: order("quantity._sym","asc"), GALLERY_LIBRARY]] = eosio::multi_index<"inclusion"_n, gallery_types::inclusion_struct>;
    
    // using prov_key_index [[using eosio: order("grantor","asc"), order("recipient","asc")]] = eosio::indexed_by<"bykey"_n, eosio::const_mem_fun<gallery_types::provision_struct, gallery_types::provision_struct::key_t, &gallery_types::provision_struct::by_key> >;
    // using provs [[using eosio: order("id","asc"), scope_type("symbol_code"), GALLERY_LIBRARY]] = eosio::multi_index<"provision"_n, gallery_types::provision_struct, prov_key_index>;

    // using advices [[using eosio: scope_type("symbol_code"), order("leader","asc"), GALLERY_LIBRARY]] = eosio::multi_index<"advice"_n, gallery_types::advice_struct>;

    // using stats [[using eosio: scope_type("symbol_code"), order("id","asc"), GALLERY_LIBRARY]] = eosio::multi_index<"stat"_n, gallery_types::stat_struct>;
    
    event mosaic_chop_event (
        string commun_code;
        uint64 tracery;
    );

    event mosaic_state_event (
        uint64 tracery;
        address creator;
        uint256 collection_end_date;
        uint16 gem_count;
        int64 shares;
        int64 damn_shares;
        uint256 reward;
        bool banned;
    );
    event gem_state_event (
        uint64 tracery;
        address owner; //!< Mosaic owner
        address creator;
        uint256 points;
        uint256 pledge_points;
        bool damn;
        uint64 shares;
    );
    
    event gem_chop_event (
        uint64 tracery;
        address owner;
        address creator;
        uint256 reward;
        uint256 unfrozen;
    );

    event mosaic_top_event (
        string commun_code;
        uint64 tracery;
        uint16 place;
        int64 comm_rating;
        int64 lead_rating;
    );
    
    event inclusion_state_event (
        address account;
        uint256 quantity;
    );
    
}


function send_mosaic_event(string commun_symbol, mosaic_struct mosaic) {
        emit mosaic_state_event(
            mosaic.tracery,
            mosaic.creator,
            mosaic.collection_end_date,
            mosaic.gem_count,
            mosaic.shares,
            mosaic.damn_shares,
            mosaic.reward,
            mosaic.banned()
        );
    }

function send_mosaic_chop_event(string commun_code, uint64 tracery) {
        emit mosaic_chop_event(
            commun_code,
            tracery
        );
        
    }

function abs(int x) private pure returns (int) {
    return x >= 0 ? x : -x;
}

function send_gem_event(string commun_symbol, gem_struct gem) {
        emit gem_state_event(
            gem.tracery,
            gem.owner,
            gem.creator,
            gem.points,
            gem.pledge_points,
            (gem.shares < 0),
            abs(gem.shares)
        );
    }

 function send_chop_event(gem_struct gem, uint256 reward, uint256 unfrozen) {
        emit gem_chop_event(
            gem.tracery,
            gem.owner,
            gem.creator,
            reward,
            unfrozen
        );
    }

function send_top_event(string commun_code,mosaic_struct mosaic, uint16 place) {
        emit mosaic_top_event(
            commun_code,
            mosaic.tracery,
            place,
            mosaic.comm_rating,
            mosaic.lead_rating
        );
    }

 function send_inclusion_event(address account, uint256 quantity) {
        emit inclusion_state_event(
            account,
            quantity
        );
    }

//private

function send_reward(address from, address to, uint256 quantity, uint64 tracery) private pure return(bool){
        if (to && !balance_exists(to, quantity.symbol.code())) { //refer from point=>         if (to && !point::balance_exists(to, quantity.symbol.code())) {
            return false;
        }
        
        if (quantity.amount) {
            // action(
            //     permission_level{from, config::transfer_permission},
            //     config::point_name,
            //     "transfer"_n,
            //     std::make_tuple(from, to, quantity, "reward for " + std::to_string(tracery))
            // ).send();
        }
        return true; 
    };
    
function freeze(address account, uint256  quantity, address ram_payer = name()) { //check this name()  // check find(), end(), modify(), emplace(), erase()
        
        if (!quantity.amount) {
            return;
        }
        string commun_code = quantity.symbol.code();
        bool balance_exists = balance_exists(account, commun_code);
        require(balance_exists, quantity.amount > 0 ? "balance doesn't exist" : "SYSTEM: points are frozen while balance doesn't exist");

        uint256 balance_amount = get_balance(account, commun_code).amount;
        
        inclusions_table(account.value);
        uint256 incl = inclusions_table.find(quantity.symbol.code().raw()); // check find(), end()
        require((incl == inclusions_table.end()) || ((0 < incl->quantity.amount) && (incl->quantity.amount <= balance_amount)), 
            "SYSTEM: invalid value of frozen points");
        
        uint256 new_val = (incl != inclusions_table.end()) ? quantity.amount + incl->quantity.amount : quantity.amount;
        require(new_val >= 0, "SYSTEM: impossible combination of quantity and frozen points");
        require(new_val <= balance_amount, "overdrawn balance");
        
        emit send_inclusion_event(account, new_val));
        if (new_val) {
            if (incl != inclusions_table.end()) {
                inclusions_table.modify(incl, name(), [&](auto& item) { item.quantity.amount = new_val; });
            }
            else {
                inclusions_table.emplace(ram_payer ? ram_payer : account, [&](auto& item) { item.quantity = quantity; });
            }
        }
        else { // => (incl != inclusions_table.end())
            inclusions_table.erase(incl);
        }
    }
    
 function get_reserve_amount(uint256 quantity) return (int64) {
    return get_reserve_quantity(quantity, NULL).amount; //point::get_reserve_quantity(quantity, nullptr).amount;
}


//template<typename GemIndex, typename GemItr>
    function chop_gem(string commun_symbol, GemIndex gem_idx, GemItr gem_itr, bool by_user, bool has_reward, bool no_rewards = false) return(bool){
        // const auto& gem = *gem_itr;
        // auto commun_code = commun_symbol.code();
        // auto& community = commun_list::get_community(commun_code);

        mosaics_table(_self, commun_code.raw());
        //auto mosaic = mosaics_table.find(gem.tracery);
        require(mosaic != mosaics_table.end(), "mosaic doesn't exist");
        //auto claim_date = mosaic->collection_end_date + eosio::seconds(community.moderation_period + community.extra_reward_period);
        bool ready_to_claim = claim_date <= now && gem.claim_date != eternity;
        if (by_user) {
            require(ready_to_claim || has_auth(gem.owner) 
                || (has_auth(gem.creator) && !has_reward && gem.claim_date != eternity), "lack of necessary authority");
        } else if (!ready_to_claim) {
            // gem_idx.modify(gem_itr, eosio::same_payer, [&](auto& item) {
            //     item.claim_date = claim_date;
            // });
            return false;
        }

        int64 reward = 0;
        bool damn = gem.shares < 0;
        if (!no_rewards && damn == mosaic->banned()) {
            reward = damn ? 
                (community.damned_gem_reward_enabled ? safe_prop(mosaic->reward, -gem.shares, mosaic->damn_shares) : 0) :
                safe_prop(mosaic->reward,  gem.shares, mosaic->shares);
        }
        frozen_points(gem.points + gem.pledge_points, commun_symbol);
        reward_points(reward, commun_symbol);
        
        freeze(_self, gem.owner, -frozen_points);
        send_chop_event(_self, gem, reward_points, frozen_points);

        if (gem.creator != gem.owner) {
            
            provs_table(_self, commun_code.raw());
            // auto provs_index = provs_table.get_index<"bykey"_n>();
            // auto prov_itr = provs_index.find(std::make_tuple(gem.owner, gem.creator));
            if (prov_itr != provs_index.end()) {
                //provs_index.modify(prov_itr, name(), [&](auto& item) {
                    item.total  += reward_points.amount;
                    item.frozen -= frozen_points.amount;
                });
            }
        }
        if (!send_reward(_self, gem.owner, reward_points, gem.tracery)) {
            //shouldn't we use a more specific memo in send_reward here?
            require(send_reward(_self, point::get_issuer(commun_code), reward_points, gem.tracery), "the issuer's balance doesn't exist");
        }
        
        if (mosaic->gem_count > 1 || mosaic->lead_rating) {
            //mosaics_table.modify(mosaic, name(), [&](auto& item) {
                if (!damn) {
                    item.points -= gem.points;
                    item.shares -= gem.shares;
                    item.comm_rating -= gem.points;
                }
                else {
                    item.damn_points -= gem.points;
                    item.damn_shares += gem.shares;
                    item.comm_rating += gem.points;
                }
                item.pledge_points -= gem.pledge_points;
                item.reward -= reward;
                item.gem_count--;
            });
            send_mosaic_event(commun_symbol, mosaic);
        }
        else {
            tats_table(_self, commun_code.raw());
            //const auto& stat = stats_table.get(commun_code.raw(), "SYSTEM: no stat but community present");
            //stats_table.modify(stat, name(), [&]( auto& s) { s.unclaimed += mosaic->reward - reward; });
            // if (!mosaic->deactivated()) {
            //     T::deactivate(_self, commun_code, *mosaic);
            // }
            // send_mosaic_chop_event(_self, commun_code, mosaic->tracery);
            // mosaics_table.erase(mosaic);
        }
        return true;
    }

    function freeze_points_in_gem(bool creating, string commun_symbol, uint64 tracery, time_point claim_date, 
                              int64 points, int64 shares, int64 pledge_points, address owner, address creator) {
        require(points >= 0, "SYSTEM: points can't be negative");
        require(pledge_points >= 0, "SYSTEM: pledge_points can't be negative");
        if (!shares && !points && !pledge_points && !creating) {
            return;
        }
        
        string commun_code = commun_symbol;
        //auto& community = commun_list::get_community(commun_code);
        
        gems_table(_self, commun_code.raw());
        
        bool refilled = false;
        
        if (!creating) {
            // auto gems_idx = gems_table.get_index<"bykey"_n>();
            // auto gem = gems_idx.find(std::make_tuple(tracery, owner, creator));
            // if (gem != gems_idx.end()) {
            //     eosio::check((shares < 0) == (gem->shares < 0), "gem type mismatch");
            //     eosio::check(community.refill_gem_enabled, "can't refill the gem");
            //     gems_idx.modify(gem, name(), [&](auto& item) {
            //         item.points += points;
            //         item.shares += shares;
            //         item.pledge_points += pledge_points;
            //     });
                emit send_gem_event(commun_symbol, gem);
                refilled = true;
            }
        }
        
        if (!refilled) {
            
            uint8 gem_num = 0;
            uint256 max_claim_date = now;
            // auto claim_idx = gems_table.get_index<"byclaim"_n>();
            // auto chop_gem_of = [&](name account) {
            //     auto gem_itr = claim_idx.lower_bound(std::make_tuple(account, time_point()));
            //     if ((gem_itr != claim_idx.end()) && (gem_itr->owner == account) && (gem_itr->claim_date < max_claim_date)) {
            //         if (chop_gem(_self, commun_symbol, claim_idx, gem_itr, false, true)) {
            //             claim_idx.erase(gem_itr);
            //         }
            //         ++gem_num;
            //     }
            // };
            chop_gem_of(owner);
            if (owner != creator) {
                chop_gem_of(creator);
            }
            // max_claim_date -= eosio::seconds(config::forced_chopping_delay);
            // auto joint_idx = gems_table.get_index<"byclaimjoint"_n>();
            // auto gem_itr = joint_idx.begin();
            
            // while ((gem_itr != joint_idx.end()) && (gem_itr->claim_date < max_claim_date) && (gem_num < config::auto_claim_num)) {
            //     if (chop_gem(_self, commun_symbol, joint_idx, gem_itr, false, true, true)) {
            //         gem_itr = joint_idx.erase(gem_itr);
            //     }
            //     else {
            //         ++gem_itr;
            //     }
            //     ++gem_num;
            // }
            
            //gems_table.emplace(creator, [&]( auto &item ) {
                item = gem_struct {
                    id = gems_table.available_primary_key(),
                    tracery = tracery,
                    claim_date = claim_date,
                    points = points,
                    shares = shares,
                    pledge_points = pledge_points,
                    owner = owner,
                    creator = creator
                };
                emit send_gem_event(commun_symbol, item);
            });
        }
        freeze(owner, points + pledge_points, creator);
        
        mosaics_table(_self, commun_code.raw());
        //auto mosaic = mosaics_table.find(tracery);
        require(mosaic != mosaics_table.end(), "mosaic doesn't exist");
        
        //mosaics_table.modify(mosaic, name(), [&](auto& item) {
            if (shares < 0) {
                item.damn_points += points;
                item.damn_shares -= shares;
                item.comm_rating -= points;
            }
            else {
                item.points += points;
                item.shares += shares;
                item.comm_rating += points;
            }
            item.pledge_points += pledge_points;
            if (!refilled) {
                require(item.gem_count < std::numeric_limits<decltype(item.gem_count)>::max(), "gem_count overflow");
                item.gem_count++;
            }
        });
    }
    function pay_royalties(name _self, symbol commun_symbol, uint64_t tracery, name mosaic_creator, int64_t shares) returns (int64){
        if (!shares) {
            return 0;
        }
        //auto commun_code = commun_symbol.code();
        //gallery_types::gems gems_table(_self, commun_code.raw());
    
        //auto gems_idx = gems_table.get_index<"bycreator"_n>();
        //auto first_gem_itr = gems_idx.lower_bound(std::make_tuple(tracery, mosaic_creator, name()));
        int64 pre_shares_sum = 0;
        /*for (auto gem_itr = first_gem_itr; (gem_itr != gems_idx.end()) && 
                                           (gem_itr->tracery == tracery) && 
                                           (gem_itr->creator == mosaic_creator); ++gem_itr) {
            if (gem_itr->shares > 0) {
                pre_shares_sum += gem_itr->shares;
            }
        }*/
        
        int64 ret = 0;
        
        //for (auto gem_itr = first_gem_itr; (gem_itr != gems_idx.end()) && 
                                           (gem_itr->tracery == tracery) && 
                                           (gem_itr->creator == mosaic_creator); ++gem_itr) {
            int64_t cur_shares = 0;
            
            if (gem_itr->shares > 0) {
                cur_shares = safe_prop(shares, gem_itr->shares, pre_shares_sum);
            }
            else if (!pre_shares_sum && gem_itr->owner == mosaic_creator) {
                cur_shares = shares;
            }
            
            if (cur_shares > 0) {
                gems_idx.modify(gem_itr, name(), [&](auto& item) {
                    item.shares += cur_shares;
                });
                send_gem_event(_self, commun_symbol, *gem_itr);
                ret += cur_shares;
                
                if (ret == shares) {
                    break;
                }
            }
        }
        
        mosaics mosaics_table(_self, commun_code.raw());
        //auto mosaic = mosaics_table.find(tracery);
        require(mosaic != mosaics_table.end(), "mosaic doesn't exist");
        
        mosaics_table.modify(mosaic, name(), [&](auto& item) { item.shares += ret; });
        
        return ret;
    }
    function freez_in_gems(
        address _self, 
        bool creating, 
        uint4 tracery, 
        uint256 claim_date, 
        address creator, 
        int256 quantity, 
        providers_t providers,
        bool damn, 
        int64 points_sum, 
        int64 shares_abs, 
        int64 pledge_points){
            int64 total_shares_fee = 0;
            //string commun_symbol = quantity.symbol;
            //auto commun_code = commun_symbol.code();
            mosaics mosaics_table(_self, commun_code.raw());
            //auto provs_index = provs_table.get_index<"bykey"_n>();
            int64 left_pledge = pledge_points;
            int54 left_points = points_sum;
            for (/*const auto& p : providers*/) {
                //auto prov_itr = provs_index.find(std::make_tuple(p.first, creator));
                check(prov_itr != provs_index.end(), "no points provided");
                
                int64 cur_pledge = safe_prop(left_pledge, p.second, left_points);
                int64 cur_points = p.second - cur_pledge;
                int64 cur_shares_abs = safe_prop(shares_abs, p.second, points_sum);
                int64 cur_shares_fee = safe_pct(prov_itr->fee, cur_shares_abs);
                cur_shares_abs   -= cur_shares_fee;
                total_shares_fee += cur_shares_fee;
    
                freeze_points_in_gem(_self, creating, commun_symbol, tracery, claim_date, 
                    cur_points, damn ? -cur_shares_abs : cur_shares_abs, cur_pledge, p.first, creator);
                
                check(prov_itr->available() >= p.second, "not enough provided points");
                provs_index.modify(prov_itr, name(), [&](auto& item) { item.frozen += p.second; });
                
                left_pledge -= cur_pledge;
                left_points -= p.second;
            }
            
            if (quantity.amount || total_shares_fee || creating) {
                int64 cur_pledge = min(left_pledge, quantity.amount);
                int64 cur_points = quantity.amount - cur_pledge;
                int64 cur_shares_abs = safe_prop(shares_abs, quantity.amount, points_sum);
                cur_shares_abs += total_shares_fee;
                
                freeze_points_in_gem(_self, creating, commun_symbol, tracery, claim_date, 
                    cur_points, damn ? -cur_shares_abs : cur_shares_abs, cur_pledge, creator, creator);
            }
        
            mosaics mosaics_table(_self, commun_code.raw());
            //auto mosaic = mosaics_table.find(tracery);
            send_mosaic_event(_self, commun_symbol, *mosaic);

            deactivate_old_mosaics(_self, commun_code);
    }
        
    struct claim_info_t {
        uint64 tracery;
        bool has_reward;
        bool premature;
        string commun_symbol;
    };
        
    function get_claim_info(address _self, uint64 tracery, string commun_code, bool eager) returns (claim_info_t) {
        mosaics mosaics_table(_self, commun_code.raw());
        //const auto& mosaic = mosaics_table.get(tracery, "mosaic doesn't exist");
        
        uint256 now = now;

        auto& community = commun_list::get_community(commun_code);
        
        claim_info_t ret{mosaic.tracery, mosaic.reward != 0, now <= mosaic.collection_end_date + eosio::seconds(community.moderation_period + community.extra_reward_period), community.commun_symbol};
        check(!ret.premature || eager, "moderation period isn't over yet");
        
        maybe_issue_reward(commun_code, _self);
        
        return ret;
    }
    
    function set_gem_holder(name _self, uint64_t tracery, symbol_code commun_code, name gem_owner, name gem_creator, name holder) {
        require(gem_owner);
        //auto& community = commun_list::get_community(commun_code);
    
        gallery_types::mosaics mosaics_table(_self, commun_code.raw());
        //const auto& mosaic = mosaics_table.get(tracery, "mosaic doesn't exist");
        gems gems_table(_self, commun_code.raw());
        /*auto gems_idx = gems_table.get_index<"bykey"_n>();
        auto gem = gems_idx.find(std::make_tuple(tracery, gem_owner, gem_creator));
        eosio::check(gem != gems_idx.end(), "gem doesn't exist");
        eosio::check(gem->claim_date != config::eternity || gem_owner != holder, "gem is already held");*/
    
        //it will prevent the mosaic from being erased, so
        //eosio::check(gem->points >= community.get_opus(mosaic.opus).min_mosaic_inclusion, "not enough inclusion");
        
        if (gem_owner != holder && gem->points) {
            require_auth(holder);
            asset frozen_points(gem->points + gem->pledge_points, community.commun_symbol);
            freeze(_self, gem_owner, -frozen_points);
            freeze(_self, holder, frozen_points);
        }
    
        gems_idx.modify(gem, holder, [&](auto& item) {
            item.owner = holder;
            item.claim_date = config::eternity;
        });
    }
    function deactivate_old_mosaics(address _self, string commun_code) {
        //auto& community = commun_list::get_community(commun_code);

        mosaics mosaics_table(_self, commun_code.raw());
        
        /*auto mosaics_by_date_idx = mosaics_table.get_index<"bydate"_n>();
        auto mosaics_by_status_idx = mosaics_table.get_index<"bystatus"_n>();
        auto now = eosio::current_time_point();
        auto max_collection_end_date = now - (eosio::seconds(community.moderation_period) + eosio::seconds(community.extra_reward_period));

        auto mosaic_by_status = mosaics_by_status_idx.lower_bound(std::make_tuple(gallery_types::mosaic_struct::ACTIVE, time_point()));*/        
        for (size_t i = 0; i < config::auto_deactivate_num && mosaic_by_status != mosaics_by_status_idx.end(); i++, ++mosaic_by_status) {
            if (mosaic_by_status->collection_end_date >= now || mosaic_by_status->status != gallery_types::mosaic_struct::ACTIVE) {
                break;
            }
            mosaics_by_status_idx.modify(mosaic_by_status, name(), [&](auto& item) {
                item.status = gallery_types::mosaic_struct::MODERATE;
            });
        }

        //auto mosaic_by_date = mosaics_by_date_idx.lower_bound(std::make_tuple(false, time_point()));
        for (size_t i = 0; i < config::auto_deactivate_num && mosaic_by_date != mosaics_by_date_idx.end(); i++, ++mosaic_by_date) {
            if (mosaic_by_date->collection_end_date >= max_collection_end_date) {
                break;
            }
            check(mosaic_by_date->status != gallery_types::mosaic_struct::LOCKED, "SYSTEM: deactivate_old_mosaics, incorrect status value");
            mosaics_by_date_idx.modify(mosaic_by_date, name(), [&](auto& item) {
                if (item.status < gallery_types::mosaic_struct::ARCHIVED) {
                    item.status = gallery_types::mosaic_struct::ARCHIVED;
                }
                item.deactivated_xor_locked = true;
            });
            deactivate(_self, commun_code, *mosaic_by_date);
        }
    }


    
