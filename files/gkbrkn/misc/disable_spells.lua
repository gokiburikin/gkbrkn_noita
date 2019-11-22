--[[
]]
local blacklist = {
    LIGHT_BULLET = true
}
local spells_to_disable = math.floor(#actions / 10);
local disabled_spells = {};
while spells_to_disable > 0 do
    local spell_to_disable = actions[math.ceil(math.random() * #actions)];

    if blacklist[spell_to_disable.id] ~= true and disabled_spells[spell_to_disable.id] ~= true then
        spell_to_disable.name = GameTextGetTranslatedOrNot(spell_to_disable.name) .. " (Disabled)";
        -- TODO this might be overkill, but there is at least one mod that makes max use spells infinite, so...
        spell_to_disable.action = function() end
        spell_to_disable.max_uses = 0;
        disabled_spells[spell_to_disable.id] = true;
        spells_to_disable = spells_to_disable - 1;
    end
end

--[[
local blacklist = {
    LIGHT_BULLET = true
}
local spells_to_disable = math.floor(#actions / 10);
local disabled_spells = {};
while spells_to_disable > 0 do
    local spell_index = Random( 1, #actions );
    local spell_to_disable = actions[spell_index];

    if blacklist[spell_to_disable.id] ~= true and disabled_spells[spell_to_disable.id] ~= true then
        spell_to_disable.max_uses = 0;
        -- TODO this might be overkill, but there is at least one mod that makes max use spells infinite, so...
        spell_to_disable.action = function() end
        spell_to_disable.name = GameTextGetTranslatedOrNot(spell_to_disable.name) .. " (Disabled)";
        --GamePrint(spell_index.."/"..actions[spell_index].name);
        --actions[spell_index] = nil;
        table.remove( actions, 1 );
        --if HasFlagPersistent( MISC.DisableSpells.Remove ) then
        --    table.remove( actions, spell_index );
        --end
        disabled_spells[spell_to_disable.id] = true;
        spells_to_disable = spells_to_disable - 1;
    end
end
]]