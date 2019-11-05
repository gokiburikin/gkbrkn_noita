table.insert( actions,
{
    id          = "GKBRKN_REVELATION",
    name 		= "Revelation",
    description = "Cast a spell that reveals enemies",
    sprite 		= "files/gkbrkn/action_revelation.png",
    sprite_unidentified = "files/gkbrkn/action_revelation.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0.1,0.1,0.1,0.1,0.1,0.1,0.1",
    price = 100,
    mana = 3,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_revelation.xml,";
        draw_actions( 1, true );
    end,
});