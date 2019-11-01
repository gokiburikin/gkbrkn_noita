table.insert( actions,
{
    id          = "GKBRKN_PROJECTILE_BURST",
    name 		= "Projectile Burst",
    description = "Duplicate a projectile multiple times",
    sprite 		= "files/gkbrkn/action_projectile_burst.png",
    sprite_unidentified = "files/gkbrkn/action_projectile_burst.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 320,
    mana = 24,
    max_uses = 24,
    action 		= function()
        c.fire_rate_wait = c.fire_rate_wait + 10;
        current_reload_time = current_reload_time + 10;
        c.spread_degrees = c.spread_degrees + 7;
        c.speed_multiplier = c.speed_multiplier * (1 + ( math.random() - 0.5 ) * 0.2 );
        extra_projectiles( 4 );
        draw_actions( 1, true );
    end,
});