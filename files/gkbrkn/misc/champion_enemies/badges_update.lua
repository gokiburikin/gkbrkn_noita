local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
local offset_x = #children * 4.5 - 9;
for index,child in pairs(children) do
    local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
    ComponentSetValue( sprite, "offset_x", -offset_x + (index - 1) * 9 );
    ComponentSetValue( sprite, "offset_y", 26 );
    --ComponentSetValue( sprite, "alpha", math.cos( GameGetFrameNum() / 10 + index * 5 ) * 0.5 + 0.5 + 0.25 );
end