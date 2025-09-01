dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
local distance_full = 64
local random_offset = 1
local entity = GetUpdatedEntityID()
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" )
if projectile ~= nil then
    local x, y = EntityGetTransform( entity )

    local current_target = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil )
    if current_target == nil or EntityGetIsAlive( current_target ) == false or current_target == 0 then
        local targets = EntityGetInRadiusWithTag( x, y, 32, "homing_target" ) or {}
        for _,nearest_homing_target in pairs( targets ) do
            if nearest_homing_target ~= entity then
                local tx, ty = EntityGetFirstHitboxCenter( nearest_homing_target )
                if tx ~= nil and ty ~= nil then
                    local distance = math.sqrt( ( tx - x ) ^ 2 + ( ty - y ) ^ 2 )
                    if distance <= 32 then
                        EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", nearest_homing_target )
                        break
                    end
                end
            end
        end
    end

    local soft_parent = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 )
    local tx, ty = x, y
    if soft_parent ~= 0 and EntityGetIsAlive( soft_parent ) then
        local px, py = EntityGetTransform( soft_parent )
        local distance = math.sqrt( ( px - x ) ^ 2 + ( py - y ) ^ 2 )
        if distance < distance_full then
            px, py = EntityGetFirstHitboxCenter( soft_parent )
            if px ~= nil and py ~= nil then
                tx, ty = px, py
            end
        else
            EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 )
        end
    else
        EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 )
    end

    if soft_parent ~= 0 then
        tx = tx + (math.random() - 0.5) * 2.0 * random_offset
        ty = ty + (math.random() - 0.5) * 2.0 * random_offset
        local distance = math.sqrt( ( x - tx ) ^ 2 + ( y - ty ) ^ 2 )
        local direction = math.atan2( ty - y, tx - x )

        local velocity_components = EntityGetComponent( entity, "VelocityComponent" ) or {}
        for _,velocity_component in pairs(velocity_components) do
            ComponentSetValue2( velocity_component, "mVelocity", math.cos( direction ) * distance * 60.0, math.sin( direction ) * distance * 60.0 )
        end
    end
end