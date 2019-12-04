table.insert( actions,
{
    id          = "GKBRKN_MAGIC_LIGHT",
    name 		= "Magic Light",
    description = "Cast a spell that cuts through darkness",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 320,
    mana = 10,
    action 		= function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});