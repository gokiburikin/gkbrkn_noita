table.insert( actions,
{
    id          = "GKBRKN_TIME_SPLIT",
    name 		= "Time Split",
    description = "Equalize current cast delay and recharge time",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/time_split/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/time_split/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 140,
    mana = 3,
    action 		= function()
        local sum = (c.fire_rate_wait + current_reload_time) * 0.5;
        c.fire_rate_wait = sum;
        current_reload_time = sum;
    end,
});
