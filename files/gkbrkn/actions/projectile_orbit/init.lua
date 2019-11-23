table.insert( actions,
{
    id          = "GKBRKN_PROJECTILE_ORBIT",
    name 		= "Projectile Orbit",
    description = "Cast 2 spells of which the second will orbit the first",
    sprite 		= "files/gkbrkn/actions/projectile_orbit/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/projectile_orbit/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 3,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/projectile_orbit/projectile_extra_entity.xml,";
        draw_actions( 2, true );
        add_projectile( "files/gkbrkn/actions/projectile_capture.xml" );
    end,
});
