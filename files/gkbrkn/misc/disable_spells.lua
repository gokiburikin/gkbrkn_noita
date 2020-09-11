print("[goki's things] Disabling Random Spells")
local blacklist = {
    LIGHT_BULLET = true
}
local spells_to_disable = math.floor(#actions / 10);
local disabled_spells = {};
local random_iterator = 0;
while spells_to_disable > 0 do
    local spell_to_disable = actions[math.ceil(ProceduralRandom(random_iterator,random_iterator * 100) * #actions)];
    random_iterator = random_iterator + 1;

    if spell_to_disable ~= nil and blacklist[spell_to_disable.id] ~= true and disabled_spells[spell_to_disable.id] ~= true then
        spell_to_disable.name = GameTextGetTranslatedOrNot(spell_to_disable.name) .. " (Disabled)";
        --print("[goki's things] disabled "..GameTextGetTranslatedOrNot(spell_to_disable.name));
        -- TODO this might be overkill, but there is at least one mod that makes max use spells infinite, so...
        spell_to_disable.action = function() end
        spell_to_disable.max_uses = 0;
        disabled_spells[spell_to_disable.id] = true;
        spells_to_disable = spells_to_disable - 1;
    end
end
print("[goki's things] Disabled Random Spells")
