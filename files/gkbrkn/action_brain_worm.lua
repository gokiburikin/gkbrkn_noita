table.insert( actions,
{
    id          = "GKBRKN_BRAIN_WORM",
    name 		= "Path Correction",
    description = "Projectiles target enemies within a short line of sight",
    sprite 		= "files/gkbrkn/action_undefined.png",
    sprite_unidentified = "files/gkbrkn/action_undefined.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1",
    price = 200,
    mana = 12,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_brain_worm.xml,";
        draw_actions( 1, true );
    end,
});