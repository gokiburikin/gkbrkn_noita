local entity = GetUpdatedEntityID();
local x,y = EntityGetTransform( entity );
local parent = EntityGetParent( entity );
local parent_x, parent_y = EntityGetTransform( parent )

local distance_to_parent = math.sqrt( math.pow( parent_x - x, 2 ) + math.pow( parent_y - y, 2 ) );
if distance_to_parent > 100 then
    --EntitySetTransform( entity, parent_x, parent_y );
    --GamePrint("move to parent");
end
--GamePrint("teleport to parent "..distance_to_parent);