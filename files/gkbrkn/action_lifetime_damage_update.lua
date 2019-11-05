local entity_id = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity_id );

GamePrint( EntityGetParent( entity_id ) );