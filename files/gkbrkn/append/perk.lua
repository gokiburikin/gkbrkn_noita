local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

local function get_perk_flag_name( perk_id ) return "PERK_" .. perk_id; end

local _perk_get_spawn_order = perk_get_spawn_order;
function perk_get_spawn_order()
    if #perk_list > 0 then
        if setting_get( MISC.PerkRewrite.NewLogicFlag ) then
            local perk_order = {};
            for i=1,300 do
                table.insert( perk_order, perk_get_at_index( i ) );
            end
            return perk_order;
        else
            return _perk_get_spawn_order();
        end
    end
end

local _perk_spawn = perk_spawn;
function perk_spawn( x, y, perk_id )
    local perk = _perk_spawn( x, y, perk_id );
    if setting_get( MISC.ShowPerkDescriptions.EnabledFlag ) then
        if perk then
            local perk_data = get_perk_with_id( perk_list, perk_id );
            if perk_data then
                local info = EntityGetFirstComponent( perk, "UIInfoComponent" );
                local full_name = GameTextGetTranslatedOrNot( perk_data.ui_name ) .. " - ".. GameTextGetTranslatedOrNot( perk_data.ui_description );
                if info then
                    ComponentSetValue2( info, "name", full_name );
                end
            end
        end
    end
    return perk;
end

local _perk_pickup = perk_pickup;
function perk_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks )
    local perk_id = ""
	edit_component( entity_item, "VariableStorageComponent", function(comp,vars)
		perk_id = ComponentGetValue2( comp, "value_string" )
	end)

	local perk_data = get_perk_with_id( perk_list, perk_id )
    local can_recurse = false;
	if perk_data ~= nil and perk_data.stackable == true then
		can_recurse = true;
	end

    local recursion_stacks = EntityGetVariableNumber( entity_who_picked, "gkbrkn_recursion_stacks", 0 );
    if can_recurse and recursion_stacks > 0 then
        for i=1,recursion_stacks,1 do
            _perk_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks );
            EntitySetVariableNumber( entity_who_picked, "gkbrkn_recursion_stacks", EntityGetVariableNumber( entity_who_picked, "gkbrkn_recursion_stacks", 0 ) - 1 );
        end
    else
        _perk_pickup( entity_item, entity_who_picked, item_name, do_cosmetic_fx, kill_other_perks );
    end
end

local unique_perks = {
	["BREATH_UNDERWATER"] = true,
	["GOLD_IS_FOREVER"] = true,
	["TRICK_BLOOD_MONEY"] = true,
	["EXPLODING_GOLD"] = true,
	["EXPLODING_CORPSES"] = true,
	["SAVING_GRACE"] = true,
	["INVISIBILITY"] = true,
	["REMOVE_FOG_OF_WAR"] = true,
	["LOW_HP_DAMAGE_BOOST"] = true,
	["WORM_ATTRACTOR"] = true,
	["WORM_DETRACTOR"] = true,
	["RADAR_ENEMY"] = true,
	["WAND_RADAR"] = true,
	["PROTECTION_FIRE"] = true,
	["PROTECTION_RADIOACTIVITY"] = true,
	["PROTECTION_EXPLOSION"] = true,
	["PROTECTION_MELEE"] = true,
	["PROTECTION_ELECTRICITY"] = true,
	["EDIT_WANDS_EVERYWHERE"] = true,
	["VAMPIRISM"] = true,
	["ABILITY_ACTIONS_MATERIALIZED"] = true,
	["UNLIMITED_SPELLS"] = true,
	["FREEZE_FIELD"] = true,
	["FIRE_GAS"] = true,
	["DISSOLVE_POWDERS"] = true,
	["PLAGUE_RATS"] = true,
	["WORM_SMALLER_HOLES"] = true,
	["PROJECTILE_EATER_SECTOR"] = true,
	["NO_MORE_SHUFFLE"] = true,
	["NO_MORE_KNOCKBACK"] = true,
	["PEACE_WITH_GODS"] = true,
}


-- returns true if perks can be picked many times
local _perk_is_stackable = perk_is_stackable;
function perk_is_stackable( perk_data )
	if perk_data then
        if setting_get( MISC.PerkRewrite.StackableChangesFlag ) then
            if perk_data.stackable == nil then
                return not unique_perks[perk_data.id];
            else
                return perk_data.stackable;
            end
        else
            return _perk_is_stackable( perk_data );
        end
    end
end

function weighted_random_table( entries )
    local sum = 0;
    for k,v in pairs( entries ) do
        sum = sum + v;
    end
    if sum <= 0 then
        return nil;
    end
    local random = Random() * sum;
    for k,v in pairs( entries ) do
        if random <= v then
            return k;
        end
        random = random - v;
    end
end

local function create_perk_pool()
	local result = {};

	for i,perk_data in ipairs( perk_list ) do
		if ( perk_data.not_in_default_perk_pool == nil or perk_data.not_in_default_perk_pool == false ) then
			table.insert( result, perk_data );
		end
	end

	return result;
end

local perks_memoized = {};
function perk_get_at_index( index, min_distance_between_duplicate_perks, duplicate_avoidance_tries )
	if perks_memoized[index] ~= nil then return perks_memoized[index]; end
	if min_distance_between_duplicate_perks == nil then min_distance_between_duplicate_perks = 4; end
	if duplicate_avoidance_tries == nil then duplicate_avoidance_tries = 400; end
	SetRandomSeed( 1 + index, 2 + index );
	
	local perk_pool = create_perk_pool();
	local weighted_perk_pool = {};
	for k,v in ipairs( perk_pool ) do
		local appearances = 0;
		for _,perk_id in pairs( perks_memoized ) do
			if perk_id == v.id then
				appearances = appearances + 1;
			end
		end
		if perk_is_stackable( v ) == true or GameHasFlagRun( get_perk_picked_flag_name( v.id ) ) == false then
			weighted_perk_pool[v.id] = 1 / math.max( appearances ^ 2, 1 );
		end
	end
	local perk = weighted_random_table( weighted_perk_pool );
	local perks_behind = {};
	for i=math.max(1, index - min_distance_between_duplicate_perks),index-1 do
		table.insert( perks_behind, perk_get_at_index( i, min_distance_between_duplicate_perks, duplicate_avoidance_tries ) );
	end

	local function is_duplicate_perk()
		for k,v in ipairs( perks_behind ) do
			if perk == v then
				return true;
			end
		end
		return false;
	end

	local tries = 0;
	while tries < duplicate_avoidance_tries and is_duplicate_perk() do
		perk = weighted_random_table( weighted_perk_pool );
		tries = tries + 1;
	end

	perks_memoized[index] = perk;
	return perk;
end

local _perk_spawn_random = perk_spawn_random;
function perk_spawn_random( x, y )
    if setting_get( MISC.PerkRewrite.NewLogicFlag ) then
        local result_id = 0;
        
        local next_perk_index = tonumber( GlobalsGetValue( "TEMPLE_NEXT_PERK_INDEX", "1" ) );
        local perk_id = perk_get_at_index( next_perk_index );
        GlobalsSetValue( "TEMPLE_NEXT_PERK_INDEX", tostring( next_perk_index + 1 ) );

        GameAddFlagRun( get_perk_flag_name( perk_id ) );
        result_id = perk_spawn( x, y, perk_id );
        
        return result_id;
    else
        return _perk_spawn_random( x, y );
    end
end

local _perk_spawn_many = perk_spawn_many;
function perk_spawn_many( x, y )
    if setting_get( MISC.PerkRewrite.NewLogicFlag ) then
        local perk_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ) )
        
        local count = perk_count
        local width = 60
        local item_width = width / count

        for i=1,count do
            perk_spawn_random( x + (i-0.5)*item_width, y )
        end
    else
       _perk_spawn_many( x, y );
    end
end

local _perk_reroll_perks = perk_reroll_perks;
function perk_reroll_perks( entity_item )
    if setting_get( MISC.PerkRewrite.NewLogicFlag ) then
        local perk_spawn_pos = {};
        local perk_count = 0;

        local all_perks = EntityGetWithTag( "perk" );
        local x, y;
        if #all_perks > 0 then
            for i,entity_perk in ipairs( all_perks ) do
                if entity_perk ~= nil then
                    perk_count = perk_count + 1;
                    x, y = EntityGetTransform( entity_perk );
                    table.insert( perk_spawn_pos, { x, y } );
                    EntityKill( entity_perk );
                end
            end
        end

        local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) );
        perk_reroll_count = perk_reroll_count + 1;
        GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring( perk_reroll_count ) );

        local perks = perk_get_spawn_order()

        for i,v in ipairs( perk_spawn_pos ) do
            x = v[1];
            y = v[2];

            perk_spawn_random( x, y);
        end
    else
        return _perk_reroll_perks( entity_item );
    end
end