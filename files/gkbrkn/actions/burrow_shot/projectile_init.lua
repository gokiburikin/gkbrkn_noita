dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua" )
local entity = GetUpdatedEntityID()

local projectile_component = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if projectile_component then
    ComponentSetValue2( projectile_component, "penetrate_world", true )
    ComponentSetValue2( projectile_component, "penetrate_world_velocity_coeff", 1.0 )
    EntityAddVarTag( entity, "gkbrkn_burrow_start" )
end
