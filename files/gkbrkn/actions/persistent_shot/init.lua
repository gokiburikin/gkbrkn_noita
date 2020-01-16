table.insert( actions, generate_action_entry(
    "GKBRKN_PERSISTENT_SHOT", "persistent_shot", ACTION_TYPE_DRAW_MANY,
    "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 17, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/persistent_shot/projectile_extra_entity.xml,";
        draw_actions( 2, true );
    end
) );