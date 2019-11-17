table.insert( actions,
{
    id          = "GKBRKN_PROJECTILE_EQUALIZATION",
    name 		= "Projectile Equalization",
    description = "Casts a spell that shares similar properties as other spells cast at the same time",
    sprite 		= "files/gkbrkn/actions/projectile_equalization/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/projectile_equalization/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    action 		= function()
        c.extra_entities = c.extra_entities .. "files/gkbrkn/actions/projectile_equalization/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});
