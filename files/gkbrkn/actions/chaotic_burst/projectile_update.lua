local entity = GetUpdatedEntityID();

local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    local vx,vy = ComponentGetValueVector2( velocity, "mVelocity", vx, vy );
    local magnitude = math.sqrt( vx * vx + vy * vy );
    local scale = math.pow( magnitude, 0.5 ) / 100;
    local angle = math.atan2( vy, vx ) + ( math.random() - 0.5 ) * math.pi * scale;

    ComponentSetValueVector2( velocity, "mVelocity", math.cos( angle ) * magnitude, math.sin( angle ) * magnitude );
end