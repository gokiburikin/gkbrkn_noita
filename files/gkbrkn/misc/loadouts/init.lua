local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );

if setting_get( MISC.Loadouts.EnabledFlag ) and not GameHasFlagRun( FLAGS.SkipGokiLoadouts ) then
    if loadouts and #loadouts > 0 then
        print("[goki's things] found "..#loadouts.." active loadouts" );
        local x,y = EntityGetTransform( player_entity );
        SetRandomSeed( GameGetFrameNum(), x + y + player_entity + 718 );

        local chosen_loadout = loadouts[Random( 1, #loadouts )];
        local loadout_data = chosen_loadout;

        -- Add a random spellcaster type to the loadout name
        local spellcaster_types = string_split( GameTextGetTranslatedOrNot("$loadout_spellcaster_types"), "," );
        local spellcaster_types_rnd = Random( 1, #spellcaster_types );
        local loadout_name = loadout_data.name;
        loadout_name = loadout_name:gsub( "TYPE", spellcaster_types[spellcaster_types_rnd] );

        handle_loadout( player_entity, loadout_data );

        if loadout_data.custom_message == nil then
            local note = "";
            if loadout_data.author ~= nil then
                note = "By "..GameTextGetTranslatedOrNot(loadout_data.author);
            end
            GamePrintImportant( string.format( GameTextGetTranslatedOrNot("$loadout_message_format"), loadout_name ), note );
        elseif loadout_data.custom_message ~= "" then
            GamePrintImportant( loadout_data.custom_message, "" );
        end
    end
end