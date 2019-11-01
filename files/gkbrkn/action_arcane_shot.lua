table.insert( actions,
{
    id          = "GKBRKN_SNIPER_SHOT",
    name 		= "Arcane Shot",
    description = "",
    sprite 		= "files/gkbrkn/action_curse.png",
    sprite_unidentified = "files/gkbrkn/action_curse.png",
    type 		= ACTION_TYPE_PROJECTILE,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 375,
    mana = 65,
    action 		= function()
        add_projectile( "files/gkbrkn/action_arcane_shot.xml" );
		c.fire_rate_wait = c.fire_rate_wait + 30;
		current_reload_time = current_reload_time + 90
    end,
});