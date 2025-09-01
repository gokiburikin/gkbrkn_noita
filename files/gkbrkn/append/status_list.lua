table.insert( status_effects, {
    id="GKBRKN_SIPHON",
    ui_name="siphon",
    ui_description="siphon",
    ui_icon="data/ui_gfx/status_indicators/mammi_eater.png",
	effect_entity="mods/gkbrkn_noita/files/gkbrkn/actions/siphon/hit_effect.lua",
	is_harmful=true,
})

table.insert( status_effects, {
    id="GKBRKN_EDIT_WANDS",
    ui_name="$status_name_gkbrkn_edit_wands",
    ui_description="$status_desc_gkbrkn_edit_wands",
    ui_icon="mods/gkbrkn_noita/files/gkbrkn/items/divinium_potion/edit.png",
    effect_entity="mods/gkbrkn_noita/files/gkbrkn/items/divinium_potion/effect_edit.xml",
})
