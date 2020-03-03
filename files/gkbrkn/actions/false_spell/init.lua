dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_FALSE_SPELL", "false_spell", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 90, 1, -1,
    nil,
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.xml" );
    end
) );