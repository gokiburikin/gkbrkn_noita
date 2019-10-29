table.insert( perk_list, {
	id = "GKBRKN_STURDY",
	ui_name = "Knockback Immunity",
	ui_description = "You are unaffected by recoil and knockback.",
	ui_icon = "files/gkbrkn/perk_sturdy_ui.png",
    perk_icon = "files/gkbrkn/perk_sturdy_ig.png",
    func = function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_no_recoil", } );
        local dataComponents = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if dataComponents ~= nil then
            for i,dataComponent in pairs( dataComponents ) do
                ComponentSetValue(dataComponent,"minimum_knockback_force","100000");
            end
        end
	end,
});