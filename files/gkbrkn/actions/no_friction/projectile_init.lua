dofile_once( "data/scripts/lib/utilities.lua" )
local e = GetUpdatedEntityID()
local v = EntityGetFirstComponent( e, "VelocityComponent" )
if not v then return end
ComponentSetValue2( v, "air_friction", 0 )
