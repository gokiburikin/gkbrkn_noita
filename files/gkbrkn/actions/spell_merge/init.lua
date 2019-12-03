table.insert( actions,
{
    id          = "GKBRKN_SPELL_MERGE",
    name 		= "Spell Merge",
    description = "Cast 2 spells of which the first is merged with the second",
    sprite 		= "files/gkbrkn/actions/spell_merge/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/spell_merge/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 190,
    mana = 7,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/spell_merge/projectile_extra_entity.xml,";
        draw_actions( 2, true );
    end,
});