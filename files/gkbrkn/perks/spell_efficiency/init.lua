dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_SPELL_EFFICIENCY", "spell_efficiency", function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_spell_efficiency", } );
	end
) );