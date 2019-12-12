dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_KNOCKBACK_IMMUNITY", "knockback_immunity", function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_no_recoil", } );
        local components = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if components ~= nil then
            for i,dataComponent in pairs( components ) do
                ComponentSetValue(dataComponent,"minimum_knockback_force","100000");
            end
        end
	end
));