local x, y = EntityGetTransform( player_entity );

--[[
local spells_to_add = {"TRANSMUTATION"};
local children = EntityGetAllChildren( player_entity );
if children ~= nil then
    for index,child_entity in pairs( children ) do
        if EntityGetName( child_entity ) == "inventory_full" then
            for _,action in pairs( spells_to_add ) do
                local action_card = CreateItemActionEntity( action, x, y );
                EntitySetComponentsWithTagEnabled( action_card, "enabled_in_world", false );
                EntityAddChild( child_entity, action_card );
            end
            break;
        end
    end
end
]]

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_update" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_update",
        script_source_file="mods/gkbrkn_noita/files/gkbrkn/misc/player_update.lua",
        execute_every_n_frame="1",
    });
end

if EntityGetFirstComponent( player_entity, "LuaComponent", "gkbrkn_player_damage_received" ) == nil then
    EntityAddComponent( player_entity, "LuaComponent", {
        _tags="gkbrkn_player_damage_received",
        script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/player_damage_received.lua",
    });
end

local init_check_flag = "gkbrkn_player_new_game";
if GameHasFlagRun( init_check_flag ) == false then
    GameAddFlagRun( init_check_flag );
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/init.lua", { player_entity = player_entity } );
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } );

    EntityAddComponent( player_entity, "LuaComponent", {
        script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/player_shot.lua"
    });

    local inventory = EntityGetNamedChild( player_entity, "inventory_quick" );
    if inventory ~= nil then
        if CONTENT[ITEMS.SpellBag].enabled() then
            EntityAddChild( inventory, EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/spell_bag/spell_bag.xml", x, y ) );
        end
    end
end