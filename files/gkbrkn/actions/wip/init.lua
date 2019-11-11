dofile("files/gkbrkn/helper.lua");
table.insert( actions,
{
    id          = "GKBRKN_ACTION_WIP",
    name 		= "WIP Action",
    description = "For testing",
    sprite 		= "files/gkbrkn/actions/undefined.png",
    sprite_unidentified = "files/gkbrkn/actions/undefined.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    custom_xml_file = "files/gkbrkn/actions/wip/custom_card.xml",
    action 		= function()
        DoFileEnvironment( "files/gkbrkn/actions/wip/action.lua");
    end,
});
