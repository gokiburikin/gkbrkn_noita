table.insert( actions,
{
    id          = "GKBRKN_ACTION_TEST",
    name 		= "Test Action",
    description = "For testing",
    sprite 		= "files/gkbrkn/action_undefined.png",
    sprite_unidentified = "files/gkbrkn/action_undefined.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 100,
    mana = 7,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_test.xml,";
        draw_actions( 1, true );
    end,
});
