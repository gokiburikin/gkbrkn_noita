dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PROJECTILE_ORBIT", "projectile_orbit", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 100, 12, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/projectile_extra_entity.xml,";
        c.lifetime_add = c.lifetime_add + 1;
        draw_actions( 5, true );
    end
) );
