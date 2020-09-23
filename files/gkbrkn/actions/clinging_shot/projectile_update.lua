dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local x, y = EntityGetTransform( entity );

    local current_target = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil );
    if current_target == nil or EntityGetIsAlive( current_target ) == false or current_target == 0 then
        local targets = EntityGetInRadiusWithTag( x, y, 32, "homing_target" ) or {};
        for _,nearest_homing_target in pairs( targets ) do
            local tx, ty = EntityGetFirstHitboxCenter( nearest_homing_target );
            if tx ~= nil and ty ~= nil then
                local distance = math.sqrt( ( tx - x ) ^ 2 + ( ty - y ) ^ 2 );
                if distance <= 32 then
                    EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", nearest_homing_target );
                    break;
                end
            end
        end
    end

    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    local soft_parent = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil );
    if soft_parent ~= nil and EntityGetIsAlive( soft_parent ) then
        local px, py = EntityGetTransform( soft_parent );
        local distance = math.sqrt( ( px - x ) ^ 2 + ( py - y ) ^ 2 );
        if distance < 48 then
            px, py = EntityGetFirstHitboxCenter( soft_parent );
            if px ~= nil and py ~= nil then
                SetRandomSeed( x, y );
                local parent_velocity = EntityGetFirstComponentIncludingDisabled( soft_parent, "VelocityComponent" );
                local parent_vx, parent_vy = 0, 0;
                if parent_velocity ~= nil then
                    parent_vx, parent_vy = ComponentGetValue2( parent_velocity, "mVelocity" );
                end
                local distance = math.sqrt( math.pow( px - x, 2 ) + math.pow( py - y, 2 ) );
                ComponentSetValue2( velocity, "mVelocity", vx / 1.05 + ( px - x ) * 30, vy / 1.05 + ( py - y ) * 30 );
            end
        else
            EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 );
        end
    else
        ComponentSetValue2( velocity, "mVelocity", vx * 0.75, vy  * 0.75 );
    end
end