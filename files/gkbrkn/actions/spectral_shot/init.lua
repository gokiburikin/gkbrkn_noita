table.insert( actions,
{
    id          = "GKBRKN_SPECTRAL_SHOT",
    name 		= "Spectral Shot",
    description = "Cast a spell that passes through materials",
    sprite 		= "files/gkbrkn/actions/spectral_shot/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/spectral_shot/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 1020,
    mana = 35,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/spectral_shot/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});