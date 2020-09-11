table.insert( actions, generate_action_entry(
    "GKBRKN_SEEKER_SHOT", "seeker_shot", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1.0,1.0,1.0,1.0,1.0,1.0,1.0", 280, 20, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/seeker_shot/projectile_extra_entity.xml,";
		c.speed_multiplier = c.speed_multiplier * 0.23;
        draw_actions( 1, true );
    end
) );