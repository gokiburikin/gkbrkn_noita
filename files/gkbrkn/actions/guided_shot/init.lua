table.insert( actions, generate_action_entry(
    "GKBRKN_GUIDED_SHOT", "guided_shot", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 8, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/guided_shot/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );