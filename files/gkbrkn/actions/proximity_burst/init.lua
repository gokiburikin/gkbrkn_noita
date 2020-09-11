dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_PROXIMITY_BURST", "proximity_burst", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 300, 33, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_burst/projectile_extra_entity.xml,";
        c.lifetime_add = c.lifetime_add + 6;
        c.explosion_radius = c.explosion_radius + 8.0;
		c.damage_explosion_add = c.damage_explosion_add + 0.1;
        set_trigger_death( 1 );
        draw_actions( 1, true );
    end
) );