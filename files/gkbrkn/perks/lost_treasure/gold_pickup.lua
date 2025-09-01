dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
function item_pickup()
    EntityRemoveVarTag( GetUpdatedEntityID(), "gkbrkn_lost_treasure" )
end 