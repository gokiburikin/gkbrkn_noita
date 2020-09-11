local entity = GetUpdatedEntityID();
local item_cost = EntityGetFirstComponent( entity, "ItemCostComponent" );
local shop_reroll_count = tonumber( GlobalsGetValue( "gkbrkn_shop_rerolls", "0" ) );
local cost = 200 * math.pow( 2, shop_reroll_count );
ComponentSetValue( item_cost, "cost", tostring(cost) );