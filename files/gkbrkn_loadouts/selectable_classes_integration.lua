dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );

local loadouts = {};
for id,loadout in pairs( LOADOUTS ) do
    if CONTENT[loadout].enabled() then
        local loadout_data = CONTENT[loadout].options;

        table.insert( class_list, {
            id = id,
            ui_name = CONTENT[loadout].name,
            ui_description = loadout_data.author,
            ui_icon = "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_auto_icon_ui.png",
            pickup_icon = "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_auto_icon_ig.png",
            perks = nil,
            wands = nil,
            items = nil,
            callback = function( player_entity )
                handle_loadout( player_entity, loadout_data );
            end
        } );
    end
end