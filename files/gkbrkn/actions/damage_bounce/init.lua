dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_DAMAGE_BOUNCE", "damage_bounce", ACTION_TYPE_MODIFIER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 7, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_bounce/projectile_extra_entity.xml,";
        c.bounces = c.bounces + 3;
        draw_actions( 1, true );
    end
) );
