local entity = GetUpdatedEntityID();
local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
if velocity ~= nil then
    ComponentSetValue( velocity, "gravity_y", "0" );
end
