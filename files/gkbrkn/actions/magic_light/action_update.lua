local entity = GetUpdatedEntityID();
local player = EntityGetParent( EntityGetParent( EntityGetParent( entity ) ) );
if player ~= nil then
    local player_controls = EntityGetFirstComponent( player, "ControlsComponent" );
    if player_controls ~= nil then
        local mx, my = ComponentGetValueVector2( player_controls, "mMousePosition" );
        EntitySetTransform( entity, mx, my );
    else
        local px, py = EntityGetTransform( player );
        EntitySetTransform( entity, px, py );
    end
end