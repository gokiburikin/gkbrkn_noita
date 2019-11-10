local init_check_flag = "gkbrkn_disable_spells_init";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );

    local blacklist = {
        LIGHT_BULLET = true
    }
    local spells_to_disable = math.floor(#actions / 10);
    local disabled_spells = {};
    --local disabled_string = "Spells Disabled: ";
    while spells_to_disable > 0 do
        local spell_to_disable = actions[Random( 1, #actions)];

        if blacklist[spell_to_disable.id] ~= true and disabled_spells[spell_to_disable.id] ~= true then
            -- TODO this might be overkill, but there is at least one mod that makes max use spells infinite, so...
            spell_to_disable.action = function() end
            spell_to_disable.max_uses = 0;
            disabled_spells[spell_to_disable.id] = true;
            spells_to_disable = spells_to_disable - 1;
            --[[
            local spell_name = spell_to_disable.name;
            if GameTextGetTranslatedOrNot(spell_name) then
                spell_name = GameTextGet(spell_name);
            end
            disabled_string = disabled_string .. spell_name .. ", "
            ]]
        end
    end
    --GamePrint( disabled_string );
end