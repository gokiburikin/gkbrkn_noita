table.insert( actions,
{
    id          = "GKBRKN_DOUBLE_CAST",
    name 		= "Double Cast",
    description = "Cast the next spell twice",
    sprite 		= "files/gkbrkn/actions/double_cast/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/double_cast/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "0.2,0.2,0.2,0.2,0.2,0.2,0.2",
    price = 500,
    mana = 50,
    action 		= function()
		duplicate_draw_action( 2, true );
    end,
});