local _do_money_drop = do_money_drop;
function do_money_drop( amount_multiplier )
    local entity = GetUpdatedEntityID();
    local charmed = GameGetGameEffectCount( entity, "CHARM" );
    if charmed <= 0 then
        _do_money_drop( amount_multiplier );
    end
end