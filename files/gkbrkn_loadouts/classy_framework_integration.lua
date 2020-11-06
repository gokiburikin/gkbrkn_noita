dofile( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua" );
dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );

for id,loadout_data in pairs( loadouts ) do
    table.insert( class_list, {
        id = loadout_data.id,
        ui_name = loadout_data.name,
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