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
    price = 320,
    mana = 0,
    action 		= function()
        stack_next_action( 1 );
        draw_actions( 1, true );
    end,
});