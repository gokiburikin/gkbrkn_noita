table.insert(status_effects, {
    id="SLOW_POLYMORPH",
    ui_name="$status_polymorph",
    ui_description="$statusdesc_polymorph",
    ui_icon="data/ui_gfx/status_indicators/polymorph.png",
    min_threshold_normalized="0.50",
	remove_cells_that_cause_when_activated=true,
    effect_entity="data/entities/misc/effect_polymorph.xml",
});