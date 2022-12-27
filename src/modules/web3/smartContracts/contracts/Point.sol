pragma solidity ^0.8.4;
import "hardhat/console.sol"; 

contract Point {

function send_currency_event(const structures::stat_struct& st, const structures::param_struct& par) public pure {
    currency_event data{st.supply, st.reserve, par.max_supply, par.cw, par.fee, par.issuer, par.transfer_fee, par.min_transfer_fee_points};
    event(_self, "currency"_n, data).send();
}

function send_balance_event(name acc, const structures::account_struct& accinfo) {
    balance_event data{acc, accinfo.balance};
    event(_self, "balance"_n, data).send();
}

function send_exchange_event(const asset& amount) {
    exchange_event data{amount};
    event(_self, "exchange"_n, data).send();
}

function send_fee_event(const asset& amount) {
    fee_event data{amount};
    event(_self, "fee"_n, data).send();
}

function create(address issuer, asset initial_supply, asset maximum_supply, int16 cw, int16 fee) {
    require(_self);
    require(is_account(issuer), "issuer account does not exist");

    require(maximum_supply.is_valid(), "invalid maximum_supply");
    require(maximum_supply.amount > 0, "maximum_supply must be positive");

    require(initial_supply.symbol == maximum_supply.symbol, "initial_supply and maximum_supply must have same symbol");
    require(initial_supply.is_valid(), "invalid initial_supply");
    require(initial_supply.amount >= 0, "initial_supply must be positive or zero");
    require(initial_supply <= maximum_supply, "initial_supply must be less or equal maximum_supply");

    require(0 <  cw  && cw  <= 10000, "connector weight must be between 0.01% and 100% (1-10000)");
    require(0 <= fee && fee <= 10000, "fee must be between 0% and 100% (0-10000)");

    assert(params_table.find(commun_code.raw()) == params_table.end(), "point already exists");
    assert(issuer_idx.find(issuer) == issuer_idx.end(), "issuer already has a point");

    assert(stats_table.find(commun_code.raw()) == stats_table.end(), "SYSTEM: already exists");

}

function setparams(symbol_code commun_code, std::optional<uint16_t> fee, std::optional<uint16_t> transfer_fee, std::optional<int64_t> min_transfer_fee_points) {
    params params_table(_self, _self.value);
    const auto& param = params_table.get(commun_code.raw(), "symbol does not exist");
    require_auth(param.issuer);
    
    assert(!fee || *fee <= config::_100percent, "fee can't be greater than 100%");
    assert(!transfer_fee || *transfer_fee <= config::_100percent, "transfer_fee can't be greater than 100%");
    assert(!min_transfer_fee_points || *min_transfer_fee_points >= 0, "min_transfer_fee_points cannot be negative");

    params_table.modify(param, eosio::same_payer, [&](auto& p) {
        bool _empty = true;
        SET_PARAM(fee);
        SET_PARAM(transfer_fee);
        SET_PARAM(min_transfer_fee_points);
        assert(!_empty, "No params changed");
        assert(!p.transfer_fee || p.min_transfer_fee_points > 0, "min_transfer_fee_points cannot be 0 if transfer_fee set");
    });
}

function setfreezer(name freezer) {
    require_auth(_self);
    require(is_account(freezer), "freezer account does not exist");
    auto global_param = global_params(_self, _self.value);
    global_param.set({ .point_freezer = freezer }, _self);
}

function issue(name to, asset quantity, string memo) {
    auto commun_symbol = quantity.symbol;
    require(commun_symbol.is_valid(), "invalid symbol name");
    require(memo.size() <= 256, "memo has more than 256 bytes");
    symbol_code commun_code = commun_symbol.code();

    params params_table(_self, _self.value);
    const auto& param = params_table.get(commun_code.raw(), "point with symbol does not exist, create it before issue");

    stats stats_table(_self, commun_code.raw());
    const auto& stat = stats_table.get(commun_code.raw(), "SYSTEM: point with symbol does not exist");

    require_auth(_self);

    require(stat.reserve.amount > 0, "no reserve");
    require(quantity.is_valid(), "invalid quantity");
    require(quantity.amount > 0, "must issue positive quantity");

    require(quantity.symbol == stat.supply.symbol, "symbol precision mismatch");
    require(quantity.amount <= param.max_supply.amount - stat.supply.amount, "quantity exceeds available supply");

    stats_table.modify(stat, same_payer, [&](auto& s) {
        s.supply += quantity;
        send_currency_event(s, param);
    });

    add_balance(param.issuer, quantity, param.issuer);

    if (to != param.issuer) {
        SEND_INLINE_ACTION(*this, transfer, { {param.issuer, "active"_n} },
            { param.issuer, to, quantity, memo }
        );
    }
}

function retire(name from, asset quantity, string memo) {
    auto commun_symbol = quantity.symbol;
    require(commun_symbol.is_valid(), "invalid symbol name");
    require(memo.size() <= 256, "memo has more than 256 bytes");
    symbol_code commun_code = commun_symbol.code();

    params params_table(_self, _self.value);
    const auto& param = params_table.get(commun_code.raw(), "point with symbol does not exist");

    stats stats_table(_self, commun_code.raw());
    const auto& stat = stats_table.get(commun_code.raw(), "SYSTEM: point with symbol does not exist");

    require_auth(from);
    require(quantity.is_valid(), "invalid quantity");
    require(quantity.amount > 0, "must retire positive quantity");

    require(quantity.symbol == stat.supply.symbol, "symbol precision mismatch");

    stats_table.modify(stat, same_payer, [&](auto& s) {
        s.supply -= quantity;
        send_currency_event(s, param);
    });

    sub_balance(from, quantity);
}

function transfer(name from, name to, asset quantity, string memo) {
    do_transfer(from, to, quantity, memo);
}

function withdraw(name owner, asset quantity) {
    require_auth(owner);
    require(quantity.symbol == config::reserve_token, "invalid reserve token symbol");
    sub_balance(owner, vague_asset(quantity.amount));
    INLINE_ACTION_SENDER(eosio::token, transfer)(config::token_name, {_self, config::active_name}, {_self, owner, quantity, ""});
}
}
