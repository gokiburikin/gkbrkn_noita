local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );

local nearby_entities = EntityGetInRadius( x, y, 768 );
local now = GameGetFrameNum();
for _,nearby in pairs( nearby_entities ) do
    if ( now + nearby * 381723 ) % 300 == 0 then
        local shimmer = false;
        local item = EntityGetFirstComponent( nearby, "ItemComponent" );
        if item ~= nil and EntityHasTag( nearby, "gold_nugget" ) == false then
            shimmer = ComponentGetValue2( item, "auto_pickup" ) == true;
            if shimmer == false then
                if EntityHasTag( nearby, "wand" ) then
                    if EntityGetParent( nearby ) == 0 then
                        shimmer = true;
                    end
                else
                    shimmer = ComponentGetValue2( item, "auto_pickup" ) == false;
                end
            end
        end
        
        if shimmer == true and item ~= nil then
            local ix, iy = EntityGetTransform( nearby );
            EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/actions/treasure_sense/sparkler.xml", ix, iy );
        end
    end
end