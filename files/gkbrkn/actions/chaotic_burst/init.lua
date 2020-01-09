dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_CHAOTIC_BURST", "chaotic_burst", ACTION_TYPE_PROJECTILE,
    "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 260, 42, -1,
    nil,
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" );
    end
) );