dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua")
local entity = GetUpdatedEntityID()

local parent = EntityGetVariableNumber( entity, "gkbrkn_formation_sword_soft_parent", 0 )
if parent == 0 or not EntityGetIsAlive(parent) then return end

local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if not projectile then return end

local shooter = ComponentGetValue2( projectile, "mWhoShot" )
if not shooter or shooter == 0 then return end

local control = EntityGetFirstComponent( shooter,"ControlsComponent" )
if not control then return end 

local ax, ay = ComponentGetValue2( control, "mAimingVectorNormalized" )
if ax == 0 or ay == 0 then return end

local aim_angle = math.atan2( ay, ax )
local pvx, pvy = GameGetVelocityCompVelocity( shooter )

local active_wand = WandGetActive( shooter )
if active_wand ~= nil then
    local distance = EntityGetVariableNumber( entity, "gkbrkn_formation_sword_index", 0 ) * 12 + 12
    if distance ~= nil and aim_angle ~= nil then
        local wx, wy = EntityGetTransform( active_wand )
        -- TODO this is a silly use of a tag just for a few pixels of offset
        -- find a better way to do this
        -- NOTE it's also not even accurate since it uses the card's position, so it won't match the held wand if you swap
        local offset_entities = EntityGetWithTag("gkbrkn_formation_sword_shoot_pos" )
        local found_offset = false
        for k,v in pairs( offset_entities ) do
            if v and #(EntityGetComponent( v, "InheritTransformComponent" ) or {}) > 0 then
                wx, wy = EntityGetTransform( v )
                found_offset = true
                break
            end
        end
        if not found_offset then distance = distance + 12 end
        EntityApplyTransform( entity, wx + math.cos( aim_angle ) * distance + pvx / 60.0, wy + math.sin( aim_angle ) * distance + pvy / 60.0 )
    end
end

local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" )
if velocity ~= nil then
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" )
    if EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) == 0 and ( vx ~= 0 or vy ~= 0 ) then
        EntitySetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", aim_angle - math.atan2( vy, vx ) )
    end
    local magnitude = 20
    ComponentSetValue2( velocity, "mVelocity", math.cos( aim_angle + EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) ) * magnitude, math.sin( aim_angle + EntityGetVariableNumber( entity, "gkbrkn_formation_sword_angle_offset", 0 ) ) * magnitude )
end