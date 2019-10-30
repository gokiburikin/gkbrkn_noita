table.insert( actions,
{
    id          = "GKBRKN_MICRO_SHIELD",
    name 		= "Micro Shield",
    description = "Projectiles reflect projectiles",
    sprite 		= "files/gkbrkn/action_micro_shield.png",
    sprite_unidentified = "files/gkbrkn/action_micro_shield.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 540,
    mana = 20,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_micro_shield.xml,";
        draw_actions( 1, true );
    end,
});