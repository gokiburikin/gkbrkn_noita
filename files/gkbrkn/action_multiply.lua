table.insert( actions,
{
    id          = "GKBRKN_MULTIPLY",
    name 		= "Multiply",
    description = "Weaponry",
    sprite 		= "files/gkbrkn/action_curse.png",
    sprite_unidentified = "files/gkbrkn/action_curse.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 5,
    action 		= function()
		multi_draw_action( 2, true )
    end,
});