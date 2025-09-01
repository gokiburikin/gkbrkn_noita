dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
local entity = GetUpdatedEntityID()
local parent = tonumber(EntityGetVariableString( entity, "gkbrkn_projectile_orbit_soft_parent", "0" ))
if parent == 0 or not EntityGetIsAlive( parent ) then return end

local TWO_PI = math.pi * 2
local ORBIT_RADIUS = 8
local ORBIT_SPEED = 8

local found_orbit = false
local orbit_index = 0
local orbit_total = 1

for _,v in pairs( EntityGetComponentIncludingDisabled( entity, "VariableStorageComponent" ) ) do
    if ComponentGetValue2( v, "name" ) == "gkbrkn_orbit" then
        found_orbit = true
        orbit_index = ComponentGetValue2( v, "value_int" )
        orbit_total = tonumber( ComponentGetValue2( v, "value_string" ) ) - 1
        break
    end
end

if not found_orbit then return end

local frame = GameGetFrameNum()
local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
if not velocity then return end

local velocity_x, velocity_y = ComponentGetValue2( velocity, "mVelocity" )
local parent_velocity = EntityGetFirstComponentIncludingDisabled( parent, "VelocityComponent" )
if not parent_velocity then return end

local parent_velocity_x, parent_velocity_y = ComponentGetValue2( parent_velocity, "mVelocity" )
local x,y = EntityGetTransform( entity )
local parent_x, parent_y = EntityGetTransform( parent )
local target_x = parent_x + math.cos( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS
local target_y = parent_y + math.sin( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS
local angle = math.atan2( target_y - y, target_x - x )
local magnitude = ( parent_velocity_x ^ 2 + parent_velocity_y ^ 2) ^ 0.5
local target_velocity_x = math.cos( angle ) * magnitude
local target_velocity_y = math.sin( angle ) * magnitude
ComponentSetValue2( velocity, "mVelocity", target_velocity_x, target_velocity_y )
EntityApplyTransform( entity, target_x, target_y )