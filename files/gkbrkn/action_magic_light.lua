table.insert( actions,
{
    id          = "GKBRKN_MAGIC_LIGHT",
    name 		= "Magic Light",
    description = "Cast a spell that cuts through darkness",
    sprite 		= "files/gkbrkn/action_magic_light.png",
    sprite_unidentified = "files/gkbrkn/action_magic_light.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 320,
    mana = 10,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_magic_light.xml,";
        draw_actions( 1, true );
    end,
});