table.insert( actions,
{
    id          = "GKBRKN_EXTRA_PROJECTILE",
    name 		= "Extra Projectile",
    description = "Cast a spell that gains an additional projectile",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/extra_projectile/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/extra_projectile/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 320,
    mana = 12,
    action 		= function()
        c.spread_degrees = c.spread_degrees + 3;
        c.fire_rate_wait = c.fire_rate_wait + 8;
        current_reload_time = current_reload_time + 8;
        extra_projectiles( 1 );
        draw_actions( 1, true );
    end,
});