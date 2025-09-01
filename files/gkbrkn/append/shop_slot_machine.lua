local _spawn_all_shopitems = spawn_all_shopitems
function spawn_all_shopitems( x, y )
    _spawn_all_shopitems( x, y )
    EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/slot_machine/slot_machine.xml", x + 151, y )
end