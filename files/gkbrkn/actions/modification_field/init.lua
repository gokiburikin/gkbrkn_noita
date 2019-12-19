dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_MODIFICATION_FIELD", "modification_field", ACTION_TYPE_STATIC_PROJECTILE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 200, 50, 3,
    nil,
    function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/projectile.xml" );
    end
) );
