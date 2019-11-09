table.insert( actions,
{
    id          = "GKBRKN_BREAK_CAST",
    name 		= "Break Cast",
    description = "Stop the current spell cast",
    sprite 		= "files/gkbrkn/actions/break_cast/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/break_cast/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 50,
    action 		= function()
        skip_cards();
    end,
});
