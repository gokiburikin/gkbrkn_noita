dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/game_helpers.lua" )

local make_exploding = function( eid, size )
    EntityAddComponent( eid, "CollisionTriggerComponent", { 
        width = size,
        height = size,
        required_tag = "enemy",
        timer_for_destruction = "5",
    } )
    
    EntityAddComponent( eid, "LuaComponent", { 
        execute_every_n_frame = "-1",
        script_collision_trigger_hit = "data/scripts/perks/gold_explosion_collision_trigger.lua"
    } )
end

function do_money_drop( amount_multiplier, trick_kill )
	
	if GameGetIsTrailerModeEnabled() then return end

	local entity = GetUpdatedEntityID()

	local no_gold_drop = false
	edit_component_with_tag( entity, "VariableStorageComponent", "no_gold_drop", function(comp,vars) no_gold_drop = true end )
	if no_gold_drop then return end

	local amount = 1

	edit_component( entity, "DamageModelComponent", function(comp,vars)
		local health = ComponentGetValue2( comp, "max_hp" )
		if health > 1.0 then
			amount = math.floor(health)
		end
	end)
	
	if GameHasFlagRun( "greed_curse" ) and ( GameHasFlagRun( "greed_curse_gone" ) == false ) then
		amount = amount * 3.0
	end

	amount = amount * amount_multiplier

	local money = 10 * amount
	local x, y = EntityGetTransform( entity )
	
	local gold_entity = "data/entities/items/pickup/goldnugget_"
    local name = "$item_goldnugget"
	local remove_timer = false
    local max_value = 2147483647 - 512
    local sizes = {200000,10000,1000,200,50,10}
    local collision_size = {12,12,20,12,9,6}
    local exploding_gold = GameHasFlagRun( "exploding_gold" )

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	if comp_worldstate then
		if ComponentGetValue2( comp_worldstate, "perk_gold_is_forever" ) then
			remove_timer = true
		end

		if trick_kill then
			if ComponentGetValue2( comp_worldstate, "perk_trick_kills_blood_money" ) then
				gold_entity = "data/entities/items/pickup/bloodmoney_"
                name = "$item_bloodmoney"
			end
		end

		-- drop hp?
		SetRandomSeed( x + entity, y - entity )
		local hp_drop_chance = tonumber( ComponentGetValue2( comp_worldstate, "perk_hp_drop_chance" ) )
		hp_drop_chance = amount_multiplier * hp_drop_chance
		if hp_drop_chance > 0 and Random( 1, 100 ) <= hp_drop_chance then
			local eid = load_gold_entity( "data/entities/items/pickup/bloodmoney_50.xml", x, y-8, remove_timer )
			money = money - 50
			make_exploding( eid, 9 )
		end
	end

	SetRandomSeed( x + entity, y - entity )
    local split = --##Limit
	local sum = 0.0
	local amounts = {}
	for i=1,split do
		local r = math.random()
		table.insert( amounts, r )
		sum = sum + r
	end
	local remainder = money
	for i=1,split do
		amounts[i] = math.floor( amounts[i] / sum * money / 10 + 0.5 ) * 10
		remainder = remainder - amounts[i]
	end
	amounts[1] = amounts[1] + remainder
	local amount_index = 1
    while money >= 10 do
	    local limit = money
		if amount_index <= #amounts then
			limit = amounts[amount_index]
			amount_index = amount_index + 1
		end
        local value = math.max( math.min( limit, max_value ), 10 )
        money = money - value

        local i = 1
        while value < sizes[i] do
            i = i + 1
        end

        local eid = load_gold_entity( gold_entity .. sizes[i]..".xml", x + Random( - 10, 10 ), y - 8 + Random( - 10, 10 ), remove_timer )

		local var_comps = EntityGetComponent( eid, "VariableStorageComponent" )
		if var_comps then
			for i,v in ipairs( var_comps ) do
				if ComponentGetValue2( v, "name" ) == "gold_value" then
					ComponentSetValue2( v, "value_int", value )
					break
				end
			end
		end

        local item = EntityGetFirstComponent( eid, "ItemComponent" )
        if item then ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot(name).." ("..value..")" ) end
        
        local ui_info = EntityGetFirstComponent( eid, "UIInfoComponent" )
        if ui_info then ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot(name).." ("..value..")" ) end

        if exploding_gold then make_exploding( eid, sizes[i] ) end
    end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	do_money_drop( 1, false )
end