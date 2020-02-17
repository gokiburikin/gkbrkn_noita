dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );

function kick( is_electric )
    local entity = GetUpdatedEntityID();
    local x,y = EntityGetTransform( entity );
    local nearby_wands = EntityGetInRadiusWithTag( x, y, 32, "wand" ) or {};
    for _,wand in pairs( nearby_wands ) do
        local wand_parent = EntityGetParent( wand );
        if wand_parent == nil or wand_parent == 0 then
            wand_explode_random_action( wand );
        end
    end
end