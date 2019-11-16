local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
for i=1,10 do
    GameCreateParticle( "gold", x + Random( -2, 2 ), y + Random( -2, 2 ), 1, 0, 0, false );
end