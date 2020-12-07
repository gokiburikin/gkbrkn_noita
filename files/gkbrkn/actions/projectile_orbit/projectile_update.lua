dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local TWO_PI = math.pi * 2;
local ORBIT_RADIUS = 8;
local ORBIT_SPEED = 8;
local entity = GetUpdatedEntityID();
local parent = tonumber(EntityGetVariableString( entity, "gkbrkn_projectile_orbit_soft_parent", "0" ));

local projectile_data = EntityGetFirstComponentIncludingDisabled( entity, "ProjectileComponent" );
if projectile_data then
    local radius = ComponentObjectGetValue2( projectile_data, "config", "action_unidentified_sprite_filename" );
    if radius then
        local _,_,radius = radius:find("orbital_radius_(%d+)");
        if radius then
            radius = tonumber( radius );
            ORBIT_RADIUS = (radius ^ 0.6 + 8) or ORBIT_RADIUS;
        end
    end
end

if parent ~= 0 and EntityGetIsAlive(parent) then
    local orbit = EntityGetFirstComponentIncludingDisabled( entity, "VariableStorageComponent", "gkbrkn_orbit" );
    local orbit_index = ComponentGetValue2( orbit, "value_int" );
    local orbit_total = tonumber( ComponentGetValue2( orbit, "value_string" ) ) - 1;
    local frame = GameGetFrameNum();
    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
    local velocity_x, velocity_y = ComponentGetValue2( velocity, "mVelocity" );
    local parent_velocity = EntityGetFirstComponentIncludingDisabled( parent, "VelocityComponent" );
    local parent_velocity_x, parent_velocity_y = ComponentGetValue2( parent_velocity, "mVelocity" );
    local x,y = EntityGetTransform( entity );
    local parent_x, parent_y = EntityGetTransform( parent );
    local target_x = parent_x + math.cos( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS;
    local target_y = parent_y + math.sin( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS;
    local target_velocity_x = (target_x - x) * 60 + parent_velocity_x;
    local target_velocity_y = (target_y - y) * 60 + parent_velocity_y;
    ComponentSetValue2( velocity, "mVelocity", target_velocity_x, target_velocity_y );
end