dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
    EntityAddVarTag( GetUpdatedEntityID(), "gkbrkn_regen_cancel" )
end
