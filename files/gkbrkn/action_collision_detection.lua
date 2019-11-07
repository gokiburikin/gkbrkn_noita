table.insert( actions,
{
    id          = "GKBRKN_COLLISION_DETECTION",
    name 		= "Collision Detection",
    description = "Casts a spell that attempts to avoid world collisions",
    sprite 		= "files/gkbrkn/action_collision_detection.png",
    sprite_unidentified = "files/gkbrkn/action_collision_detection.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1",
    price = 90,
    mana = 4,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_collision_detection.xml,";
        draw_actions( 1, true );
    end,
});
