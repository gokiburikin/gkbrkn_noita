dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local multiplier = 0.25 + Random() * 0.75;
    local vx, vy = ComponentGetValue2( velocity, "mVelocity" );
    ComponentSetValue2( velocity, "mVelocity", vx * multiplier, vy * multiplier );
end