local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
for _,ice_shot in pairs( EntityGetInRadiusWithTag( x, y, 16, "gkbrkn_ice_shot" ) or {} ) do
    EntityConvertToMaterial( ice_shot, "ice" );
    EntityKill( ice_shot );
end