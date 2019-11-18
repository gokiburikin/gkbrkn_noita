table.insert( actions,
{
    id          = "GKBRKN_PATH_CORRECTION",
    name 		= "Path Correction",
    description = "Projectiles target enemies within a short line of sight",
    sprite 		= "files/gkbrkn/actions/path_correction/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/path_correction/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 200,
    mana = 12,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/path_correction/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});