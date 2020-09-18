local entity = GetUpdatedEntityID();
local sprites = {};
local children = { entity };
for _,child in pairs( children ) do
    local child_sprites = EntityGetComponent( child, "SpriteComponent" );
    if child_sprites ~= nil and #child_sprites > 0 then
        for _,sprite in pairs( child_sprites ) do
            table.insert( sprites, sprite );
        end
    end

    local child_children = EntityGetAllChildren( child );
    if child_children ~= nil and #child_children > 0 then
        for _,child_child in pairs(child_children ) do
            table.insert( children, child_child );
        end
    end
end

for _,sprite in pairs( sprites ) do
    ComponentSetValue2( sprite, "alpha", 0.17 );
end