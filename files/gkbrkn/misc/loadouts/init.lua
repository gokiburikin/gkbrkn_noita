dofile( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );
if HasFlagPersistent( MISC.Loadouts.Enabled ) and MISC.Loadouts.Skip ~= true then
    local loadouts = {};
    for id,loadout in pairs( LOADOUTS ) do
        if CONTENT[loadout].enabled() then
            if CONTENT[loadout].options.condition_callback == nil or CONTENT[loadout].options.condition_callback( player_entity ) == true then
                table.insert( loadouts, loadout );
            end
        end
    end
    if #loadouts > 0 then
        local x,y = EntityGetTransform( player_entity );
        SetRandomSeed( GameGetFrameNum(), x + y + player_entity + 718 );

        local chosen_loadout = loadouts[Random( 1, #loadouts )];
        local loadout_data = CONTENT[chosen_loadout].options;

        -- Add a random spellcaster type to the loadout name
        local spellcaster_types = gkbrkn_localization.loadout_spellcaster_types;
        local spellcaster_types_rnd = Random( 1, #spellcaster_types );
        local loadout_name = loadout_data.name;
        loadout_name = string.gsub( loadout_name, "TYPE", spellcaster_types[spellcaster_types_rnd] );

       handle_loadout( player_entity, loadout_data );

        if loadout_data.custom_message == nil then
            local note = "";
            if loadout_data.author ~= nil then
                note = "By "..loadout_data.author;
            end
            --GamePrintImportant( "You're a " .. loadout_name .. "!", note );
            GamePrintImportant( string.format( gkbrkn_localization.loadout_message_format, loadout_name ), note );
        elseif loadout_data.custom_message ~= "" then
            GamePrintImportant( loadout_data.custom_message, "" );
        end

        if loadout_data.callback ~= nil then
            loadout_data.callback( player_entity, inventory, cape );
        end
    end
end