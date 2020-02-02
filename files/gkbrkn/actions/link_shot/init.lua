dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_LINK_SHOT", "link_shot", ACTION_TYPE_MODIFIER, 
    "0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 7, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/link_shot/projectile_extra_entity.xml,";
        draw_actions( 2, true );
    end
) );