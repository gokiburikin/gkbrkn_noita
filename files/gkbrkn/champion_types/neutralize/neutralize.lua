dofile_once("data/scripts/lib/utilities.lua")

local entity = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity )
local vx,vy = 0,0
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
if velocity then
    vx,vy = ComponentGetValueVector2( velocity, "mVelocity" )
end
EntityKill( entity )
