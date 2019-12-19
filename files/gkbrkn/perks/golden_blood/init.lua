dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( perk_list,
    generate_perk_entry( "GKBRKN_GOLDEN_BLOOD", "golden_blood", true, function( entity_perk_item, entity_who_picked, item_name )
        local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if damagemodels ~= nil then
            for i,damagemodel in ipairs( damagemodels ) do
                ComponentSetValue( damagemodel, "blood_material", "gold" );
                ComponentSetValue( damagemodel, "blood_spray_material", "gold" );
                ComponentSetValue( damagemodel, "blood_multiplier", "0.2" );
                ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_yellow_$[1-3].xml" );
                ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_yellow_$[1-3].xml" );
            end
        end
	end
));
