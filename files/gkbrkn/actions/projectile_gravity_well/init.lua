table.insert( actions,
{
    id          = "GKBRKN_PROJECTILE_GRAVITY_WELL",
    name 		= "Projectile Gravity Well",
    description = "Cast 2 spells of which the first attracts the second",
    sprite 		= "files/gkbrkn/actions/projectile_gravity_well/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/projectile_gravity_well/icon.png",
    type 		= ACTION_TYPE_DRAW_MANY,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 210,
    mana = 3,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/projectile_gravity_well/projectile_extra_entity.xml,";
        c.speed_multiplier = c.speed_multiplier * 0.75;
        draw_actions( 2, true );
        add_projectile( "files/gkbrkn/actions/projectile_capture.xml" );
    end,
});