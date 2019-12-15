local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local check_radius = 256;

local nearby_entities = EntityGetInRadius( x, y, check_radius );
for _,nearby in pairs( nearby_entities ) do
    -- TODO  this is technically safer since disabled components don't show up, but if it's disabled then
    -- we probably don't want to consider this nugget anyway
    local shimmer = false;
    local item = EntityGetFirstComponent( nearby, "ItemComponent" );
    if item ~= nil then
        shimmer = ComponentGetValue( item, "auto_pickup" ) == "1";
    end
    if shimmer == true then
        local nearby_x, nearby_y = EntityGetTransform( nearby );
        local offset_distance = 2;
        local shimmer = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/shimmering_treasure/shimmer.xml", nearby_x + Random(-offset_distance, offset_distance), nearby_y + Random(-offset_distance, offset_distance) );
        EntityAddChild( nearby, shimmer );
    end
end