dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
-- This is the invisible trigger projectile that has been primed with a cast
-- When we want it to cause the cast to be triggered we set its collide_with_tag for a frame
local entity = GetUpdatedEntityID()

local link_time = EntityGetVariableNumber( entity, "gkbrkn_link_time", 0 )
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if projectile == nil then return end
if (GameGetFrameNum() - link_time) % 15 == 0 then
    ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_repeat" )
else
    ComponentSetValue2( projectile, "collide_with_tag", "" )
end

if link_time ~= 0 then return end

local depth_string = ComponentObjectGetValue2( projectile, "config", "action_unidentified_sprite_filename" )
if depth_string == nil then EntityKill(entity) return end

local _,_,depth = depth_string:find("trigger_repeat_(%d+)")
if depth == nil then EntityKill(entity) return end

-- This block searches for a projectile with the same id as this trigger projectile
-- When found, it creates the trigger activator and attaches it to the real projectile
-- Every so often this invisible projectile will enable collision with the activator
-- which causes the world hit trigger to occur
local x,y = EntityGetTransform( entity )
local found_parent = false
local in_radius = EntityGetInRadius(x,y,128) or {}
for k,nearby in pairs(in_radius) do
    if nearby ~= entity and EntityGetIsAlive( nearby ) == true then
        local nearby_projectile = EntityGetFirstComponentIncludingDisabled( nearby, "ProjectileComponent" )
        if nearby_projectile then
            local nearby_depth = ComponentObjectGetValue2( nearby_projectile, "config", "action_unidentified_sprite_filename" )
            local id = ComponentObjectGetValue2( nearby_projectile, "config", "action_id" )
            if nearby_depth then
                local _,_,nearby_depth = nearby_depth:find("trigger_repeat_(%d+)")
                if tonumber(nearby_depth) == tonumber(depth) then
                    EntitySetVariableNumber( entity, "gkbrkn_link_time", GameGetFrameNum() )
                    --print(tostring(entity).."("..EntityGetName(entity)..") found parent " ..tostring(nearby).."("..EntityGetName(nearby)..") at "..tostring(GameGetFrameNum()) )
                    EntityAddChild( nearby, entity )
                    local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/trigger_entity.xml", x, y  )
                    EntityAddChild( entity, link_entity )
                    found_parent = true
                    break
                end
            end
        end
    end
end
if not found_parent then
    EntityKill( entity )
end