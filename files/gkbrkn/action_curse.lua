table.insert( actions,
{
    id          = "GKBRKN_CURSE",
    name 		= "Golden Blessing",
    description = "Turn your foes to gold from the inside out",
    sprite 		= "files/gkbrkn/action_curse.png",
    sprite_unidentified = "files/gkbrkn/action_curse.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0.1,0.1,0.1,0.1,0.1,0.1,0.1",
    price = 1000,
    mana = 0,
    max_uses = 1,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_curse.xml,";
        draw_actions( 1, true );
    end,
});