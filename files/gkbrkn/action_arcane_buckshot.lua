table.insert( actions,
{
    id          = "GKBRKN_ARCANE_BUCKSHOT",
    name 		= "Arcane Buckshot",
    description = "A spray of arcane pellets",
    sprite 		= "files/gkbrkn/action_arcane_buckshot.png",
    sprite_unidentified = "files/gkbrkn/action_arcane_buckshot.png",
    type 		= ACTION_TYPE_PROJECTILE,
    spawn_level                       = "1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1",
    price = 210,
    mana = 12,
    action 		= function()
        add_projectile( "files/gkbrkn/action_arcane_buckshot.xml" );
        add_projectile( "files/gkbrkn/action_arcane_buckshot.xml" );
        add_projectile( "files/gkbrkn/action_arcane_buckshot.xml" );
		c.fire_rate_wait = c.fire_rate_wait + 16;
		current_reload_time = current_reload_time + 42;
    end,
});