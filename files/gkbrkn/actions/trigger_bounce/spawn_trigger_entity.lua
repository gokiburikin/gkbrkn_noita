dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
local e = GetUpdatedEntityID()
local x, y = EntityGetTransform(e)
for _,te in pairs(EntityGetInRadiusWithTag( x , y, 32, "gkbrkn_bounce_trigger" )) do
    EntityAddVarTag( te, "gkbrkn_bounce_just_triggered" )
end