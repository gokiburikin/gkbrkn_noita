-- TODO this spell still needs some cleanup
-- (nullify projectile velocity, get it back when cast is done, use velocity in the interim to move the spell, etc
table.insert( actions, generate_action_entry(
    "GKBRKN_CARRY_SHOT", "carry_shot", ACTION_TYPE_UTILITY,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 160, 4, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/carry_shot/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );