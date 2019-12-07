table.insert( actions,
{
    id          = "GKBRKN_MAGIC_LIGHT",
    name 		= "Magic Light",
    description = "Control a magic light that cuts through darkness",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/icon.png",
    type 		= ACTION_TYPE_PASSIVE,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 240,
    mana = 3,
    custom_xml_file = "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/custom_card.xml",
    action 		= function()
        --c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/projectile_extra_entity.xml,";
        draw_actions( 1, true );
    end,
});