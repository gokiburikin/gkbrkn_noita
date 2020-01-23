dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_BOUND_SHOT", "bound_shot", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 90, -1,
    nil,
    function()
        c.damage_projectile_add = c.damage_projectile_add + 0.08;
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/bound_shot/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );