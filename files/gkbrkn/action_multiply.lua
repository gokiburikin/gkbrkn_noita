table.insert( actions,
{
    id          = "GKBRKN_MULTIPLY",
    name 		= "Duplicate Spell",
    description = "Duplicate the next spell",
    sprite 		= "files/gkbrkn/action_duplicate.png",
    sprite_unidentified = "files/gkbrkn/action_duplicate.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 9,
    action 		= function()
		duplicate_draw_action( 2, true );
    end,
});