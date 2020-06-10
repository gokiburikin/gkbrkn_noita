dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
_do_money_drop = _do_money_drop or do_money_drop;

function do_money_drop( amount_multiplier )
    if HasFlagPersistent( MISC.CharmNerf.Enabled ) then
        local entity = GetUpdatedEntityID();
        local charmed = GameGetGameEffectCount( entity, "CHARM" );
        if charmed <= 0 then
            _do_money_drop( amount_multiplier );
        end
    else
        _do_money_drop( amount_multiplier );
    end
end