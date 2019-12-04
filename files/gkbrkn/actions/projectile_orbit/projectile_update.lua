dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
TWO_PI = math.pi * 2;
ORBIT_RADIUS = 8;
ORBIT_SPEED = 8;
local entity = GetUpdatedEntityID();
local parent = tonumber(EntityGetVariableString( entity, "gkbrkn_soft_parent", "0" ));

if parent ~= 0 and EntityGetIsAlive(parent) then
    local orbit = EntityGetFirstComponent( entity, "VariableStorageComponent", "gkbrkn_orbit" );
    local orbit_index = tonumber( ComponentGetValue( orbit, "value_int" ) );
    local orbit_total = tonumber( ComponentGetValue( orbit, "value_string" ) ) - 1;
    local frame = GameGetFrameNum();
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    local velocity_x, velocity_y = ComponentGetValueVector2( velocity, "mVelocity" );
    local parent_velocity = EntityGetFirstComponent( parent, "VelocityComponent" );
    local parent_velocity_x, parent_velocity_y = ComponentGetValueVector2( parent_velocity, "mVelocity" );
    local x,y = EntityGetTransform( entity );
    local parent_x, parent_y = EntityGetTransform( parent );
    local target_x = parent_x + math.cos( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS;
    local target_y = parent_y + math.sin( TWO_PI / orbit_total * orbit_index + frame / 60 * ORBIT_SPEED ) * ORBIT_RADIUS;
    local target_velocity_x = (target_x - x) * 60 + parent_velocity_x;
    local target_velocity_y = (target_y - y) * 60 + parent_velocity_y;
    ComponentSetValueVector2( velocity, "mVelocity", target_velocity_x, target_velocity_y );
    --EntitySetTransform( entity, target_x, target_y );
end