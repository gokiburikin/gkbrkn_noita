table.insert( actions,
{
    id          = "GKBRKN_MANA_RECHARGE",
    name 		= "Mana Recharge",
    description = "Your wand charges mana a little faster",
    sprite 		= "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/icon.png",
    sprite_unidentified = "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/icon.png",
    type 		= ACTION_TYPE_PASSIVE,
    spawn_level                       = "0,1,2,3,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1,1",
    price = 100,
    mana = 1,
    custom_xml_file = "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/custom_card.xml",
    action 		= function()
        draw_actions(1, true);
    end,
});
