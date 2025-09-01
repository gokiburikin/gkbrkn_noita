
dofile_once( "data/scripts/lib/utilities.lua" )
local e = GetUpdatedEntityID()
local p = EntityGetFirstComponent( e, "ProjectileComponent" )
if not p then return end
ComponentSetValue2( p, "physics_impulse_coeff", 0.0 )