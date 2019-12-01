local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity );
local offset_x = #children * 4.5 - 9;
local offset_y = 24;
local parent = EntityGetParent( entity );
if parent ~= nil then
    local hitbox = EntityGetFirstComponent( parent, "HitboxComponent" );
    if hitbox ~= nil then
        local height = tonumber( ComponentGetValue( hitbox, "aabb_min_y" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_max_y" ) )
        offset_y = -height + 18;
    end
end
for index,child in pairs( children ) do
    local sprite = EntityGetFirstComponent( child, "SpriteComponent" );
    ComponentSetValue( sprite, "offset_x", -offset_x + ( index - 1 ) * 9 );
    ComponentSetValue( sprite, "offset_y", offset_y );
end