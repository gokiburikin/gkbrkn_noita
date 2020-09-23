dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
local entity = GetUpdatedEntityID();

local velocity = EntityGetFirstComponentIncludingDisabled( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx,vy = ComponentGetValue2( velocity, "mVelocity", vx, vy );
    local magnitude = math.sqrt( vx * vx + vy * vy );
    local frames = GameGetFrameNum() - EntityGetVariableNumber( entity, "gkbrkn_chaotic_burst_frame", GameGetFrameNum() );
    local scale = math.random() * math.pow( magnitude, 0.6 ) / 60 * math.min( 1, frames * 0.20 );
    local angle = math.atan2( vy, vx ) + ( math.random() - 0.5 ) * math.pi * scale;

    ComponentSetValue2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end

if EntityGetVariableNumber( entity, "gkbrkn_chaotic_burst_frame", nil ) == nil then
    EntitySetVariableNumber( entity, "gkbrkn_chaotic_burst_frame", GameGetFrameNum() );
end