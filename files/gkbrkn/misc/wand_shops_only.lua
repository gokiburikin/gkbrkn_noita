if GKBRKN_WAND_SHOPS_ONLY_INIT == nil then
    GKBRKN_WAND_SHOPS_ONLY_INIT = true;
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
end

_generate_shop_item = generate_shop_item;
function generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
    if HasFlagPersistent( MISC.WandShopsOnly.Enabled ) then
        generate_shop_wand( x, y, cheap_item, biomeid_ );
        local local_wands = EntityGetInRadiusWithTag( x, y, 8, "wand" ) or {};
        for _,wand in pairs(local_wands) do
            local item_cost = EntityGetFirstComponent( wand, "ItemCostComponent" );
            if item_cost ~= nil then
                ComponentSetValue( item_cost, "stealable", "0" );
            end
        end
    else
        _generate_shop_item( x, y, cheap_item, biomeid_, is_stealable );
    end
end