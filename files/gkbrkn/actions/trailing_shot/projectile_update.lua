dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local link_distance = 8;

local parent = tonumber( EntityGetVariableString( entity, "gkbrkn_trailing_shot_soft_parent", "0" ) );
if parent ~= 0 and EntityGetIsAlive( parent ) then
    local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    local px, py = EntityGetTransform( parent );
    local distance = math.sqrt( math.pow( px - x, 2 ) + math.pow( py - y, 2 ) );
    local angle = math.atan2( py - y, px - x );
    local tx, ty = px - math.cos( angle ) * link_distance, py - math.sin( angle ) * link_distance;
    if distance > link_distance then
        ComponentSetValue2( velocity, "mVelocity", ( tx - x ) * 60 * 0.5, ( ty - y ) * 60 * 0.5 );
    else
        ComponentSetValue2( velocity, "mVelocity", vx * 0.5, vy * 0.5 );
    end
end