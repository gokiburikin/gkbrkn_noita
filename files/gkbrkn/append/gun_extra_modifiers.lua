dofile_once("files/gkbrkn/config.lua");

extra_modifiers["gkbrkn_spell_efficiency"] = function()
    if current_action.uses_remaining > 0 and Random() <= CONTENT[PERKS.SpellEfficiency].options.RetainChance then
        current_action.uses_remaining = current_action.uses_remaining + 1;
    end
end

extra_modifiers["gkbrkn_mana_efficiency"] = function()
    mana = mana + c.action_mana_drain * CONTENT[PERKS.ManaEfficiency].options.Discount;
end

extra_modifiers["gkbrkn_no_recoil"] = function()
	shot_effects.recoil_knockback = -999999;
end