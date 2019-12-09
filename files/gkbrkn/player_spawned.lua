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

--[[
for i=1,20 do
    EntityLoad( "data/entities/animals/longleg.xml", x, y - 100 );
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

    if HasFlagPersistent( MISC.HeroMode.Enabled ) then
        GameAddFlagRun( MISC.HeroMode.Enabled );
        if HasFlagPersistent( MISC.HeroMode.OrbsIncreaseDifficultyEnabled ) then
            GameAddFlagRun( MISC.HeroMode.OrbsIncreaseDifficultyEnabled );
        end
        if HasFlagPersistent( MISC.HeroMode.DistanceDifficultyEnabled ) then
            GameAddFlagRun( MISC.HeroMode.DistanceDifficultyEnabled );
        end
        if HasFlagPersistent( MISC.Badges.Enabled ) then
            local badge_filepath = "mods/gkbrkn_noita/files/gkbrkn/badges/hero_mode";
            local badge_name = "Hero";
            local badge = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/badges/hero_mode.xml" );
            if GameHasFlagRun( MISC.HeroMode.DistanceDifficultyEnabled ) then
                badge_filepath = badge_filepath .. "_distance";
                badge_name = "Determined "..badge_name;
            end
            if GameHasFlagRun( MISC.HeroMode.OrbsIncreaseDifficultyEnabled ) then
                badge_filepath = badge_filepath .. "_orbs";
                badge_name = "Courageous "..badge_name;
            end
            badge_filepath = badge_filepath .. ".png";
            badge_name = badge_name.." Mode";
            if badge ~= nil then
                local ui_icon = EntityGetFirstComponent( badge, "UIIconComponent" );
                if ui_icon ~= nil then
                    ComponentSetValue( ui_icon, "icon_sprite_file", badge_filepath );
                    ComponentSetValue( ui_icon, "name", badge_name );
                end
                EntityAddChild( player_entity, badge );
            end
        end
    end

    if HasFlagPersistent( MISC.ChampionEnemies.Enabled ) then
        GameAddFlagRun( MISC.ChampionEnemies.Enabled );
        if HasFlagPersistent( MISC.ChampionEnemies.SuperChampionsEnabled ) then
            GameAddFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled );
        end
        if HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsEnabled ) then
            GameAddFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled );
        end
        if HasFlagPersistent( MISC.Badges.Enabled ) then
            local badge_filepath = "mods/gkbrkn_noita/files/gkbrkn/badges/champion_mode";
            local badge_name = "Champions";
            local badge_description = "You will face";
            if GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled ) then
                badge_filepath = badge_filepath .. "_always";
                badge_name = badge_name .. " Only";
                badge_description = badge_description .. " only";
            end
            if GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled ) then
                badge_filepath = badge_filepath .. "_super";
                badge_name = "Super "..badge_name;
                badge_description = badge_description .. " very";
            end
            badge_filepath = badge_filepath .. ".png";
            badge_name = badge_name.." Mode";
            badge_description = badge_description .. " challenging enemies.";
            local badge = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/badges/champion_mode.xml" );
            if badge ~= nil then
                local ui_icon = EntityGetFirstComponent( badge, "UIIconComponent" );
                if ui_icon ~= nil then
                    ComponentSetValue( ui_icon, "icon_sprite_file", badge_filepath );
                    ComponentSetValue( ui_icon, "name", badge_name );
                    ComponentSetValue( ui_icon, "description", badge_description );
                end
                EntityAddChild( player_entity, badge );
            end
        end
    end

    for _,content_id in pairs( STARTING_PERKS or {} ) do
        local starting_perk = CONTENT[content_id];
        if starting_perk ~= nil then
            if starting_perk.enabled() then
                local perk_entity = perk_spawn( x, y, starting_perk.key );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
            end
        end
    end
end