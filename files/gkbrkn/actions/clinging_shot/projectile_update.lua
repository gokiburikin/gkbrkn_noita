dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
local distance_full = 64;
local random_offset = 1;
local maximum_strength = 256;
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile ~= nil then
    local x, y = EntityGetTransform( entity );

    local current_target = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", nil );
    if current_target == nil or EntityGetIsAlive( current_target ) == false or current_target == 0 then
        local targets = EntityGetInRadiusWithTag( x, y, 32, "homing_target" ) or {};
        for _,nearest_homing_target in pairs( targets ) do
            local tx, ty = EntityGetFirstHitboxCenter( nearest_homing_target );
            if nearest_homing_target ~= entity and tx ~= nil and ty ~= nil then
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
    local soft_parent = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 );
    local target_x = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target_x", x );
    local target_y = EntityGetVariableNumber( entity, "gkbrkn_clinging_shot_target_y", y );
    if soft_parent ~= 0 and EntityGetIsAlive( soft_parent ) then
        local px, py = EntityGetTransform( soft_parent );
        local distance = math.sqrt( ( px - x ) ^ 2 + ( py - y ) ^ 2 );
        if distance < distance_full then
            px, py = EntityGetFirstHitboxCenter( soft_parent );
            target_x = px;
            target_y = py;
        else
            EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 );
            EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target_x", x );
            EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target_y", y );
        end
    else
        EntitySetVariableNumber( entity, "gkbrkn_clinging_shot_target", 0 );
    end


    if soft_parent ~= 0 then
        target_x = target_x + Random( -random_offset, random_offset );
        target_y = target_y + Random( -random_offset, random_offset );
        local distance = math.sqrt( ( x - target_x ) ^ 2 + ( y - target_y ) ^ 2 );
        local direction = math.atan2( target_y - y, target_x - x );

        local velocity_components = EntityGetComponent( entity, "VelocityComponent" ) or {};
        
        for _,velocity_component in pairs(velocity_components) do
            local vx,vy = ComponentGetValue2( velocity_component, "mVelocity", vx, vy);
            local ox = math.cos( direction ) * maximum_strength;
            local oy = math.sin( direction ) * maximum_strength;
            vx = vx + ox;
            vy = vy + oy;
            ComponentSetValue2( velocity_component, "mVelocity", vx, vy );
        end
    end
end