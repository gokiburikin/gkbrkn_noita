if GKBRKN_CHARM_NERF_INIT == nil then
    GKBRKN_CHARM_NERF_INIT = true;
    dofile( "files/gkbrkn/config.lua" );
    _do_money_drop = do_money_drop
end

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