--[[ Chaotic Velocity 
]]
local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
    local angle = math.atan2( vy, vx );
    local magnitude = math.sqrt( vx * vx + vy * vy );
    local offset = (0.6 + math.random() * 0.8);
    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle )  * magnitude* offset, math.sin( angle ) * magnitude * offset );
end