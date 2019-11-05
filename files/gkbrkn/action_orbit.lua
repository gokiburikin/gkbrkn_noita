table.insert( actions,
{
    id          = "GKBRKN_ACTION_ORBIT",
    name 		= "Gravity Well",
    description = "Cast a spell that attracts projectiles and casts another spell after a short timer runs out",
    sprite 		= "files/gkbrkn/action_orbit.png",
    sprite_unidentified = "files/gkbrkn/action_orbit.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 210,
    mana = 10,
    action 		= function()
        c.speed_multiplier = c.speed_multiplier * 0.75;
        c.fire_rate_wait = c.fire_rate_wait + 0.20;
        set_trigger_timer( 6, 1 );
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_orbit.xml,";
        draw_actions( 1, true );
    end,
});

--[[ TODO if c.extra_entities ever gets fixed, change this skill from a timer trigger to a simple multicast

table.insert( actions,
{
    id          = "GKBRKN_ACTION_ORBIT",
    name 		= "Gravity Well",
    description = "Cast a spell that attracts projectiles and casts another spell after a short timer runs out",
    sprite 		= "files/gkbrkn/action_orbit.png",
    sprite_unidentified = "files/gkbrkn/action_orbit.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 210,
    mana = 10,
    action 		= function()
        c.speed_multiplier = c.speed_multiplier * 0.75;
        c.fire_rate_wait = c.fire_rate_wait + 0.20;
        --set_trigger_timer( 6, 1 );
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_orbit.xml,";
        draw_actions( 1, true );
    end,
});

]]