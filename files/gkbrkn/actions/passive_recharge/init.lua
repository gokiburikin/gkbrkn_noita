table.insert( actions,
{
    id          = "GKBRKN_PASSIVE_RECHARGE",
    name 		= "Passive Recharge",
    description = "Your wand recharges even while holstered",
    sprite 		= "files/gkbrkn/actions/passive_recharge/icon.png",
    sprite_unidentified = "files/gkbrkn/actions/passive_recharge/icon.png",
    type 		= ACTION_TYPE_PASSIVE,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 1,
    custom_xml_file = "files/gkbrkn/actions/passive_recharge/custom_card.xml",
    action 		= function()
        draw_actions(1, true);
    end,
});
