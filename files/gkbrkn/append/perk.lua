local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

local _perk_is_stackable = perk_is_stackable;
function perk_is_stackable( perk_data )
	if perk_data then
        return _perk_is_stackable( perk_data );
    end
end

local _perk_get_spawn_order = perk_get_spawn_order;
function perk_get_spawn_order()
    if #perk_list > 0 then return _perk_get_spawn_order(); end
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