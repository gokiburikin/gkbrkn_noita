local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local nearby_enemies = EntityGetInRadiusWithTag( x, y, 64, "enemy" );
for _,nearby in pairs( nearby_enemies ) do
    
end