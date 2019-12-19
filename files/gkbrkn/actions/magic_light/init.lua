dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_MAGIC_LIGHT", "magic_light", ACTION_TYPE_PASSIVE,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 240, 3, -1,
    "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/custom_card.xml",
    function()
        --c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end
) );