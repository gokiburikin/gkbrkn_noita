table.insert( actions,
{
    id          = "GKBRKN_COLLISION_DETECTION",
    name 		= "Collision Detection",
    description = "Casts a spell that attempts to avoid world collisions",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 90,
    mana = 4,
    action 		= function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/projectile_extra_entity.xml,";
        c.speed_multiplier = c.speed_multiplier * 0.85;
        c.bounces = math.max( 1, c.bounces );
        draw_actions( 1, true );
    end,
});
