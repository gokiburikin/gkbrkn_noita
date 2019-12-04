table.insert( actions,
{
    id          = "GKBRKN_SUPER_BOUNCE",
    name 		= "Super Bounce",
    description = "Cast a spell that bounces more energetically",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 90,
    mana = 3,
    action 		= function()
        c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/projectile_extra_entity.xml,";
        c.bounces = c.bounces + 2;
        draw_actions( 1, true );
    end,
});