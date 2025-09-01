dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" )
local action_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/action_data.lua" )( true )

local _generate_shop_item = generate_shop_item
local _generate_shop_wand = generate_shop_wand

function generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
    local item = _generate_shop_item( x, y, cheap_item, biomeid_, is_stealable )
    if GameHasFlagRun( FLAGS.FreeShops ) then
        local item_cost = EntityGetFirstComponentIncludingDisabled( item, "ItemCostComponent" )
        if item_cost ~= nil then
            ComponentSetValue2( item_cost, "cost", 0 )
        end
    end
    return item
end

function generate_shop_wand( x, y, cheap_item, biomeid_ )
    local wand = _generate_shop_wand( x, y, cheap_item, biomeid_ )
    if GameHasFlagRun( FLAGS.FreeShops ) then
        local item_cost = EntityGetFirstComponentIncludingDisabled( wand, "ItemCostComponent" )
        if item_cost ~= nil then
            ComponentSetValue2( item_cost, "cost", 0 )
        end
    end
    return wand
end