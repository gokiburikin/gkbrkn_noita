table.insert( actions, generate_action_entry(
    "GKBRKN_ICE_SHOT", "ice_shot", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 175, 25, -1,
    nil,
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/ice_shot/projectile.xml" );
    end
) );