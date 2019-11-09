table.insert( actions,
{
    id          = "GKBRKN_DUPLICATE",
    name 		= "Duplicate Spell",
    description = "Duplicate the next spell",
    sprite 		= "files/gkbrkn/actions/duplicate_spell/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/duplicate_spell/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 1000,
    mana = 50,
    action 		= function()
		duplicate_draw_action( 2, true );
    end,
});