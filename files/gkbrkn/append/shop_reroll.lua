local _spawn_all_shopitems = spawn_all_shopitems
function spawn_all_shopitems( x, y )
    _spawn_all_shopitems( x, y )
    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/shop_reroll/shop_reroll.xml", x - 49, y - 12 )
end