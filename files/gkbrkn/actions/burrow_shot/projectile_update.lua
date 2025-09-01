dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua" )
local entity = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity )
local vx, vy = 0, 0
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" )
if velocity then
    vx, vy = ComponentGetValue2( velocity, "mVelocity" )
end
local hit_world, _, _ = RaytracePlatforms( x + vx / 60.0, y + vy / 60.0, x, y )

if EntityHasVarTag( entity, "gkbrkn_burrow_start" ) then
    if not hit_world then return end
    EntityRemoveVarTag( entity, "gkbrkn_burrow_start" )
end
if hit_world then return end

GameCreateCosmeticParticle( "plasma_fading", x, y, 2, vx * 0.1, vy * 0.1 )

local projectile_component = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if not projectile_component then return end

ComponentSetValue2( projectile_component, "penetrate_world", false )
for _,lua in pairs(EntityGetComponentIncludingDisabled( entity, "LuaComponent") or {}) do
    if ComponentGetValue2( lua, "script_source_file" ) == "mods/gkbrkn_noita/files/gkbrkn/actions/burrow_shot/projectile_update.lua" then
        EntityRemoveComponent( entity, lua )
        break
    end
end