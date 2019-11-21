table.insert( actions,
{
    id          = "GKBRKN_SHIMMERING_TREASURE",
    name 		= "Shimmering Treasure",
    description = "Treasures catch your eye",
    sprite 		= "files/gkbrkn/actions/shimmering_treasure/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/shimmering_treasure/icon.png",
    type 		= ACTION_TYPE_MODIFIER,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 7,
    custom_xml_file = "files/gkbrkn/actions/shimmering_treasure/custom_card.xml",
    action 		= function()
    end,
});
