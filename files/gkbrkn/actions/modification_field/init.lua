dofile("files/gkbrkn/helper.lua");
table.insert( actions,
{
    id          = "GKBRKN_MODIFICATION_FIELD",
    name 		= "Modification Field",
    description = "A field of modification magic",
    sprite 		= "files/gkbrkn/actions/modification_field/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/modification_field/icon.png",
    type 		= ACTION_TYPE_STATIC_PROJECTILE,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 200,
    max_uses = 3,
    action 		= function()
        add_projectile( "files/gkbrkn/actions/modification_field/projectile.xml" );
    end,
});
