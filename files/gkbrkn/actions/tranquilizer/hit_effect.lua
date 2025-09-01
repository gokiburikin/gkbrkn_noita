dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
local e = GetUpdatedEntityID()
local x,y = EntityGetTransform(e)
for _,t in ipairs(EntityGetInRadiusWithTag( x, y, 16, "gkbrkn_tranquilizer")) do
    local materials_string = EntityGetVariableString( t, "gkbrkn_tranquilizer", "" )
    if #materials_string == 0 then return end
    for material_id in string.gmatch( materials_string,"(%d+)," ) do
        EntityAddRandomStains( e, tonumber( material_id ), 25 )
    end
    EntitySetVariableString( t, "gkbrkn_tranquilizer", "" )
end
