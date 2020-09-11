dofile( "data/scripts/items/generate_shop_item.lua" );
function item_pickup( entity_item, entity_who_picked, item_name )
	local x, y = EntityGetTransform( entity_item );

    local pull = tonumber( GlobalsGetValue( "gkbrkn_shop_rerolls", "0" ) );
    GlobalsSetValue( "gkbrkn_shop_rerolls", pull + 1 );
    SetRandomSeed( x, y );
    -- NOTE: Because of mods, it's not clear how big this radius should be
    local nearby_entities = EntityGetInRadius( x, y, 512 );
    local shop_items = {};
    for _,entity in pairs(nearby_entities) do
        local item_cost = EntityGetFirstComponent( entity, "ItemCostComponent", "shop_cost" );
        if item_cost then
            table.insert( shop_items, entity );
        else
            local sprite = EntityGetFirstComponent( entity, "SpriteComponent" );
            -- remove sale banners
            -- NOTE: Hard coded since there is no other useful data
            if ComponentGetValue2( sprite, "image_file" ) == "data/ui_gfx/sale_indicator.png" then
                EntityKill( entity );
            end
        end
    end
	--local sale_item_i = Random( 1, #shop_items )
    -- NOTE: Because the item has to be moved and the sale tag will be offset, this doesn't allow for sales
	local sale_item_i = -1
    --for shop_item in pairs( shop_items )
    for i=1,#shop_items do
        local item = shop_items[i];
        local wand = EntityHasTag( item, "wand" );
        local x, y = EntityGetTransform( item );
        local rng_x, rng_y = x + pull * 0.001, y + pull * 0.001;
        EntityKill( item );
        if wand then
            generate_shop_wand( rng_x, rng_y, i == sale_item_i, nil, true );
        else
            generate_shop_item( rng_x, rng_y, i == sale_item_i, nil, true );
        end
        local new_item = EntityGetInRadius( rng_x, rng_y, 2 )[1];
        if new_item then
            EntityApplyTransform( new_item, x, y );
        end
    end

	EntityKill( entity_item );
	EntityLoad( "data/entities/particles/perk_reroll.xml", x, y );
	EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/shop_reroll/shop_reroll.xml", x, y );
end
