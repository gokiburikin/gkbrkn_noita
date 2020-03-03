dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_FEATHER_SHOT", "feather_shot", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 3, -1,
    nil,
    function()
        c.lifetime_add = c.lifetime_add + 21;
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/feather_shot/projectile_extra_entity.xml,";
        current_reload_time = current_reload_time - 6;
        draw_actions( 1, true );
    end
) );