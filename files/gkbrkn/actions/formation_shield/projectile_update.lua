dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local TWO_PI = math.pi * 2;
local ORBIT_SPEED = 8;
local entity = GetUpdatedEntityID();
local parent = EntityGetVariableNumber( entity, "gkbrkn_formation_shield_soft_parent", 0 );

if parent ~= 0 and EntityGetIsAlive(parent) then
    local frame = GameGetFrameNum();
    local orbit_index = EntityGetVariableNumber( entity, "gkbrkn_formation_shield_index", 1 );
    local orbit_total = EntityGetVariableNumber( entity, "gkbrkn_formation_shield_total", 1 );
    local orbit_radius = EntityGetVariableNumber( entity, "gkbrkn_formation_shield_radius", 16 );
    local orbit_frame = EntityGetVariableNumber( entity, "gkbrkn_formation_shield_frame", GameGetFrameNum() );
    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
    if velocity then
        local velocity_x, velocity_y = ComponentGetValue2( velocity, "mVelocity" );
        local parent_velocity = EntityGetFirstComponentIncludingDisabled( parent, "VelocityComponent" );
        if parent_velocity then
            local parent_velocity_x, parent_velocity_y = ComponentGetValue2( parent_velocity, "mVelocity" );
            local x,y = EntityGetTransform( entity );
            local parent_x, parent_y = EntityGetTransform( parent );
            local frame_scale = math.min( 1.0, ( frame - orbit_frame ) * 0.1 );
            local target_x = parent_x + math.cos( TWO_PI / orbit_total * orbit_index + ( frame + orbit_frame ) * 0.0167 * ORBIT_SPEED ) * orbit_radius;
            local target_y = parent_y + math.sin( TWO_PI / orbit_total * orbit_index + ( frame + orbit_frame ) * 0.0167 * ORBIT_SPEED ) * orbit_radius;
            local target_velocity_x = (target_x - x) * 60 + parent_velocity_x;
            local target_velocity_y = (target_y - y) * 60 + parent_velocity_y;
            if orbit_frame == frame then
                EntityApplyTransform( entity, target_x, target_y );
            else
                ComponentSetValue2( velocity, "mVelocity", target_velocity_x, target_velocity_y );
            end
        end
    end
end