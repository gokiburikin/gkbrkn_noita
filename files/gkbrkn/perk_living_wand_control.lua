local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );

local controls_component = EntityGetFirstComponent( entity, "ControlsComponent" );
if controls_component ~= nil then
    local mouse_x, mouse_y = ComponentGetValueVector2( controls_component, "mMousePosition" );

    EntitySetTransform( entity, x + (mouse_x-x)/8, y + (mouse_y-y)/8 );
end