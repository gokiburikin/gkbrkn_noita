dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
-- This is the invisible trigger projectile that has been primed with a cast
-- It will trigger when it hits an entity with the tag gkbrkn_bounce_trigger
local entity = GetUpdatedEntityID()

local link_time = EntityGetVariableNumber( entity, "gkbrkn_link_time", 0 )

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if projectile == nil then EntityKill( entity ) return end

if EntityHasVarTag( entity, "gkbrkn_just_bounced" ) then
    ComponentSetValue2( projectile, "collide_with_tag", "" )
    EntityRemoveVarTag( entity, "gkbrkn_just_bounced" )
else
    if EntityHasVarTag( entity, "gkbrkn_bounce_just_triggered" ) then
        EntityRemoveVarTag( entity, "gkbrkn_bounce_just_triggered" )
        ComponentSetValue2( projectile, "collide_with_tag", "gkbrkn_trigger_bounce" )
        EntityAddVarTag( entity, "gkbrkn_just_bounced" )
    end
end


if link_time ~= 0 then return end

local depth_string = ComponentObjectGetValue2( projectile, "config", "action_unidentified_sprite_filename" )
if depth_string == nil then EntityKill( entity ) return end

local _,_,depth = depth_string:find("trigger_bounce_(%d+)")
if depth == nil then EntityKill( entity ) return end
depth = tonumber( depth )

-- This block searches for a projectile with the same id as this trigger projectile
-- When found, it creates the trigger activator and attaches it to the real projectile
-- Every so often this invisible projectile will enable collision with the activator
-- which causes the world hit trigger to occur
local x,y = EntityGetTransform( entity )
local found_parent = false
local in_radius = EntityGetInRadius(x,y,32) or {}
for k,nearby in pairs(in_radius) do
    if nearby ~= entity and EntityGetIsAlive( nearby ) == true then
        local nearby_projectile = EntityGetFirstComponentIncludingDisabled( nearby, "ProjectileComponent" )
        if nearby_projectile then
            local nearby_depth = ComponentObjectGetValue2( nearby_projectile, "config", "action_unidentified_sprite_filename" )
            if nearby_depth then
                local _,_,nearby_depth = nearby_depth:find("trigger_bounce_(%d+)")
                if tonumber(nearby_depth) == tonumber(depth) then
                    EntitySetVariableNumber( entity, "gkbrkn_link_time", GameGetFrameNum() )
                    EntityAddChild( nearby, entity )
                    --print(tostring(entity).."("..EntityGetName(entity)..") found parent " ..tostring(nearby).."("..EntityGetName(nearby)..") at "..tostring(GameGetFrameNum()) )
                    local link_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_bounce/trigger_entity.xml", x, y  )
                    EntityAddChild( entity, link_entity )
                    found_parent = true
                    break
                end
            end
        end
    end
end
if not found_parent then EntityKill( entity ) return end

---- We only call this to set the parent up so we can remove it immediately
--EntityRemoveComponent( entity, EntityGetFirstComponentIncludingDisabled( entity, "LuaComponent", "gkbrkn_trigger_bounce" ) )