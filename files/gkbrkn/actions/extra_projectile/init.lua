table.insert( actions,
{
    id          = "GKBRKN_EXTRA_PROJECTILE",
    name 		= "Extra Projectile",
    description = "Cast a spell that gains an additional projectile",
    sprite 		= "files/gkbrkn/actions/extra_projectile/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/extra_projectile/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 320,
    mana = 15,
    action 		= function()
        c.spread_degrees = c.spread_degrees + 2;
        c.speed_multiplier = c.speed_multiplier * 0.9;
        extra_projectiles( 1 );
        draw_actions( 1, true );
    end,
});