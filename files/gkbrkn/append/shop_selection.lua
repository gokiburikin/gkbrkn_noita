local _spawn_all_shopitems = spawn_all_shopitems
function spawn_all_shopitems( x, y )
	local spawn_shop, spawn_perks = temple_random( x, y )
	if spawn_shop == "0"  then return end
	
	SetRandomSeed( x, y )
	local count = tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) )
	local width = 132
	local item_width = width / count
	local sale_item_i = Random( 1, count )

	if GameHasFlagRun( FLAGS.SpellShopsOnly ) then
		EntityLoad( "data/entities/buildings/shop_hitbox.xml", x, y )
		for i=1,count do
			if( i == sale_item_i ) then
				generate_shop_item( x + (i-1)*item_width, y, true, nil, true )
			else
				generate_shop_item( x + (i-1)*item_width, y, false, nil, true )
			end
			
			generate_shop_item( x + (i-1)*item_width, y - 30, false, nil, true )
			LoadPixelScene( "data/biome_impl/temple/shop_second_row.png", "data/biome_impl/temple/shop_second_row_visual.png", x + (i-1)*item_width - 8, y-22, "", true )
		end
	elseif GameHasFlagRun( FLAGS.WandShopsOnly ) then
		EntityLoad( "data/entities/buildings/shop_hitbox.xml", x, y )
		for i=1,count do
			if( i == sale_item_i ) then
				generate_shop_wand( x + (i-1)*item_width, y, true )
			else
				generate_shop_wand( x + (i-1)*item_width, y, false )
			end
		end
	else
		_spawn_all_shopitems( x, y )
	end
end