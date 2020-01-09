dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PROTECTIVE_ENCHANTMENT", "protective_enchantment", ACTION_TYPE_UTILITY,
    "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 200, 23, -1,
    nil,
    function()
        c.fire_rate_wait = c.fire_rate_wait + 17;
        current_reload_time = current_reload_time + 17;
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );