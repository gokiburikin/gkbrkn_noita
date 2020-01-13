dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local x, y = EntityGetTransform( entity );

    local current_target = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil );
    if current_target == nil or EntityGetIsAlive( current_target ) then
        local targets = EntityGetInRadiusWithTag( x, y, 32, "homing_target" ) or {};
        for _,nearest_homing_target in pairs( targets ) do
            local tx, ty = EntityGetTransform( nearest_homing_target );
            local distance = math.sqrt( ( tx - x ) ^ 2 + ( ty - y ) ^ 2 );
            if distance <= 32 then
                EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", nearest_homing_target );
                break;
            end
        end
    end

    local soft_parent = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil );
    if soft_parent ~= nil then
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local px, py = EntityGetTransform( soft_parent );
        px, py = EntityGetHitboxCenter( soft_parent );
        if px ~= nil and py ~= nil then
            local parent_velocity = EntityGetFirstComponent( soft_parent, "VelocityComponent" );
            local parent_vx, parent_vy = 0, 0;
            if parent_velocity ~= nil then
                ComponentGetValueVector2( parent_velocity, "mVelocity" )
            end
            ComponentSetValueVector2( velocity, "mVelocity", ( px - x ) * 60 + parent_vx, ( py - y ) * 60 + parent_vy );
        end
    end
end