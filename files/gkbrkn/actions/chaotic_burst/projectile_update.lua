local entity = GetUpdatedEntityID();

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
    local scale = 0.2;
    local angle = math.atan2( vy, vx ) + (math.random() - 0.5) * math.pi * scale;
    local magnitude = math.sqrt( vx * vx + vy * vy );

    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end