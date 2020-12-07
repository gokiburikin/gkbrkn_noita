local MISC = dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/options.lua");

extra_modifiers["gkbrkn_no_recoil"] = function()
	shot_effects.recoil_knockback = -999999;
end

extra_modifiers["gkbrkn_spell_efficiency"] = function()
    if current_action.uses_remaining > 0 and Random() <= MISC.PerkOptions.SpellEfficiency.RetainChance then
        current_action.uses_remaining = current_action.uses_remaining + 1;
    end
end

extra_modifiers["gkbrkn_mana_efficiency"] = function()
    mana = mana + c.action_mana_drain * MISC.PerkOptions.ManaEfficiency.Discount;
end

extra_modifiers["gkbrkn_no_recoil"] = function()
	shot_effects.recoil_knockback = -999999;
end

extra_modifiers["gkbrkn_dimige"] = function()
    c.damage_projectile_add = c.damage_projectile_add + 0.04;
end