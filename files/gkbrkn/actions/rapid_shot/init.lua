dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_RAPID_SHOT", "rapid_shot", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 200, 2, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rapid_shot/projectile_extra_entity.xml,";
        c.spread_degrees = c.spread_degrees + 3;
        c.fire_rate_wait = c.fire_rate_wait - 8;
        current_reload_time = current_reload_time - 12;
        draw_actions( 1, true );
    end
) );