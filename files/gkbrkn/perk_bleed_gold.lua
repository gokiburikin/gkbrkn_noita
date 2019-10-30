table.insert( perk_list,
{
	id = "GKBRKN_BLEED_GOLD",
	ui_name = "Golden Blood",
	ui_description = "You bleed gold.",
	ui_icon = "files/gkbrkn/perk_bleed_gold_ui.png",
    perk_icon = "files/gkbrkn/perk_bleed_gold_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if damagemodels ~= nil then
            for i,damagemodel in ipairs( damagemodels ) do
                ComponentSetValue( damagemodel, "blood_material", "gold" );
                ComponentSetValue( damagemodel, "blood_spray_material", "gold" );
                ComponentSetValue( damagemodel, "blood_multiplier", "0.5" );
                ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_yellow_$[1-3].xml" );
                ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_yellow_$[1-3].xml" );
            end
        end
	end
});
