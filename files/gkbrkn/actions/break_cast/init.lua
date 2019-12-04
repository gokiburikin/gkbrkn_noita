table.insert( actions,
{
    id          = "GKBRKN_BREAK_CAST",
    name 		= "Break Cast",
    description = "Skip casting all remaining spells",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/break_cast/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/break_cast/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 50,
    mana = 2,
    action 		= function()
        c.fire_rate_wait = c.fire_rate_wait - 10.2;
        current_reload_time = current_reload_time - 10.2;
        skip_cards();
    end,
});
