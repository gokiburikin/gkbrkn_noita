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

extra_modifiers["matran"] = function()
    local data = hand[#hand];
    if data and data.mana ~= nil then
        mana = mana + data.mana * 0.5;
    end
end