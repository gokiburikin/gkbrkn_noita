table.insert( actions,
{
    id          = "GKBRKN_ACTION_WIP",
    name 		= "WIP Action",
    description = "For testing",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/undefined.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/undefined.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 140,
    mana = 2,
    --custom_xml_file = "mods/gkbrkn_noita/files/gkbrkn/misc/custom_card_test.xml",
    action 		= function()
        dofile("mods/gkbrkn_noita/files/gkbrkn/actions/wip/action.lua");
    end,
});
