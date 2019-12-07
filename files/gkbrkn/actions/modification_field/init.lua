table.insert( actions,
{
    id          = "GKBRKN_MODIFICATION_FIELD",
    name 		= "Modification Field",
    description = "A field of modification magic",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/icon.png",
    type 		= ACTION_TYPE_STATIC_PROJECTILE,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 200,
    max_uses = 3,
    mana = 50,
    action 		= function()
        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/projectile.xml" );
    end,
});
