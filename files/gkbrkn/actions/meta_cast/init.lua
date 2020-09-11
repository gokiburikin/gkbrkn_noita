table.insert( actions, generate_action_entry(
    "GKBRKN_META_CAST", "meta_cast", ACTION_TYPE_UTILITY,
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 180, 4, -1,
    nil,
    function()
        local mana_multiplier = gkbrkn.mana_multiplier;
        gkbrkn.mana_multiplier = 0;
        local skip_projectiles = gkbrkn.skip_projectiles;
        gkbrkn.skip_projectiles = true;
        draw_actions( 1, true );
        gkbrkn.mana_multiplier = mana_multiplier;
        gkbrkn.skip_projectiles = skip_projectiles;
        draw_actions( 1, true );
    end
) );