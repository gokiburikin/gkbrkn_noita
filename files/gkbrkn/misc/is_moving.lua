local entity = GetUpdatedEntityID();
last_x = last_x or 0;
last_y = last_y or 0;
local x, y = EntityGetTransform( entity );
if last_x == x and last_y == y then
    print( "not moving" );
else
    print( "moving" );
end
last_x = x;
last_y = y;