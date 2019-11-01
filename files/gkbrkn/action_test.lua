table.insert( actions,
{
    id          = "GKBRKN_ACTION_TEST",
    name 		= "Test Action",
    description = "For testing",
    sprite 		= "files/gkbrkn/action_test.png",
    sprite_unidentified = "files/gkbrkn/action_test.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 190,
    mana = 0,
    max_uses = 7,
    action 		= function()
        c.damage_critical_chance = c.damage_critical_chance + 100;
        draw_actions( 1, true );
    end,
});