dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DEMOLITIONIST", "demolitionist", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_demolitionist_bonus", 1.0, function(value) return tonumber( value ) + 2; end );
        --[[
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_shot="mods/gkbrkn_noita/files/gkbrkn/perks/demolitionist/shot.lua"
        });
        ]]
	end
) );