table.insert( actions,
{
    id          = "GKBRKN_MANA_EFFICIENCY",
    name 		= "Mana Efficiency",
    description = "Projectiles drain less mana",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/action_mana_efficiency.png",
    sprite_unidentified 		= "mods/gkbrkn_noita/files/gkbrkn/action_mana_efficiency.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 150,
    mana = 0,
    action 		= function()
        reduce_mana_usage( 0.5 );
        draw_actions( 1, true );
    end,
});