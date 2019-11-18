table.insert( actions,
{
    id          = "GKBRKN_PROJECTILE_GRAVITY_WELL",
    name 		= "Projectile Gravity Well",
    description = "Cast 2 spells of which the first attracts the second",
    sprite 		= "files/gkbrkn/actions/projectile_gravity_well/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/projectile_gravity_well/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1",
    price = 210,
    mana = 10,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/projectile_gravity_well/projectile_extra_entity.xml,";
        draw_actions( 2, true );
    end,
});