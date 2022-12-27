// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Demo{
    name contract;
    //Give time frame
        uint lastUpdated;

// Set `lastUpdated` to `now`
function updateTimestamp() public {
  lastUpdated.blockTimeStamp();
}

};


 struct stat_struct {
     uint256 id;
     //LIST OF REWARDS
     uint size = 3;
uint balance[] = new uint[](size);

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


function get_reward_receiver(string to_contract) return (reward_struct){
            return get_reward_receiver(reward_receivers, to_contract);
        }

        function last_reward_passed_seconds(string to_contract) return(int64){
            return block.timestamp - get_reward_receiver(to_contract).timestamp

//CREATE A MOSAIC FUNCTION 
}

}

    function symbol() constant returns (string symbol){
   return "MNFT";
 }
 
 }
    

     function get_continious_rate(){
return (1 + Return) ^ (1 / N) - 1
     }

    

    function seconds_per_year(){
        return get_supply/100;


    }

      function is_it_time_to_reward(const commun::structures::community& community, string to_contract, int64 passed_seconds) public return(bool){
        require(passed_seconds >= 0, "SYSTEM: incorrect passed_seconds");
        //return passed_seconds >= community.get_emission_receiver(to_contract).period;
    }
 function   maybe_issue_reward(string commun_code, string to_contract){
        if (is_it_time_to_reward(commun_code, to_contract)) {
            call_issue_reward_action(commun_code, to_contract);
         }
    }


 }
