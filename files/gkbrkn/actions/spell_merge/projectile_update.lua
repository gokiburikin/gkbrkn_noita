dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local parent = tonumber(EntityGetVariableString( entity, "gkbrkn_soft_parent", "0" ));
if parent ~= 0 and EntityGetIsAlive(parent) then
    local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    local x,y = EntityGetTransform( entity );
    local px, py = EntityGetTransform( parent );
    local parent_velocity = EntityGetFirstComponent( parent, "VelocityComponent" );
    if parent_velocity then
        local parent_vx, parent_vy = ComponentGetValue2( parent_velocity, "mVelocity" );
        ComponentSetValue2( velocity, "mVelocity", (px - x) * 60 + parent_vx, (py - y) * 60 + parent_vy );
    end
end