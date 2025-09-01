dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
local e = GetUpdatedEntityID()
local materials_string = EntityGetVariableString( e, "gkbrkn_tranquilizer", "" )
if #materials_string == 0 then return end
for material_id in string.gmatch( materials_string,"(%d+)," ) do
    local x,y = EntityGetTransform( e )
    x = x + (math.random() - 0.5) * 10
    y = y + (math.random() - 0.5) * 10
    GameCreateParticle( CellFactory_GetName( tonumber( material_id) ), x, y, 25, 30, 30, false, false, true )
end
