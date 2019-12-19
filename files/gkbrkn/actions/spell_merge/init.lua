dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_SPELL_MERGE", "spell_merge", ACTION_TYPE_DRAW_MANY, 
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 190, 7, -1,
    nil,
    function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile_extra_entity.xml,";
        c.lifetime_add = c.lifetime_add + 1;
        draw_actions( 2, true );
    end
) );