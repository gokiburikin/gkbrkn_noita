table.insert( actions,
{
    id          = "GKBRKN_MICRO_SHIELD",
    name 		= "Micro Shield",
    description = "Cast a spell that reflects projectiles",
    sprite 		= "files/gkbrkn/actions/micro_shield/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/micro_shield/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 540,
    mana = 20,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/micro_shield/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});