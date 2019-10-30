table.insert( actions,
{
    id          = "GKBRKN_SPECTRAL",
    name 		= "Spectral Shot",
    description = "Projectiles pass through materials",
    sprite 		= "files/gkbrkn/action_spectral.png",
    sprite_unidentified = "files/gkbrkn/action_spectral.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "4,5,6",
    spawn_probability                 = "1,1,1",
    price = 1020,
    mana = 35,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/action_spectral.xml,";
        draw_actions( 1, true );
    end,
});