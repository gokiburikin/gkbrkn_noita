dofile("files/gkbrkn/config.lua");
dofile("files/gkbrkn/helper.lua");

extra_modifiers["gkbrkn_spell_efficiency"] = function()
    if current_action.uses_remaining > 0 and Random() <= PERKS.SpellEfficiency.RetainChance then
        current_action.uses_remaining = current_action.uses_remaining + 1;
    end
end

extra_modifiers["gkbrkn_mana_efficiency"] = function()
    mana = mana + c.action_mana_drain * PERKS.ManaEfficiency.Discount;
end

extra_modifiers["gkbrkn_rapid_fire"] = function()
    if #deck == 0 then
        current_reload_time = PERKS.RapidFire.RechargeTimeAdjustment( current_reload_time );
    end
    c.fire_rate_wait = PERKS.RapidFire.CastDelayAdjustment( c.fire_rate_wait );
    c.spread_degrees = PERKS.RapidFire.SpreadDegreesAdjustment( c.spread_degrees );
end

extra_modifiers["gkbrkn_no_recoil"] = function()
    --ExploreGlobals();
	shot_effects.recoil_knockback = -999999;
end


extra_modifiers["gkbrkn_no_recoil"] = function()
    c.extra_entities = c.extra_entities.."files/gkbrkn/magic_light_sprite.xml";
end