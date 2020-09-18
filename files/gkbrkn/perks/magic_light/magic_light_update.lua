local entity = GetUpdatedEntityID();
local parent = EntityGetParent( entity );
if parent ~= nil then
    local parent_controls = EntityGetFirstComponent( parent, "ControlsComponent" );
    if parent_controls ~= nil then
        local mx, my = ComponentGetValue2( parent_controls, "mMousePosition" );
        EntitySetTransform( entity, mx, my );
    else
        local px, py = EntityGetTransform( parent );
        EntitySetTransform( entity, px, py );
    end
end