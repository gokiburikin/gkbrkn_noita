dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
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
for i=1,50 do
    EntityLoad( "data/entities/animals/longleg.xml", x - 100, y - 100 );
end
for i=1,50 do
    EntityLoad( "data/entities/animals/zombie.xml", x- 100, y - 100 );
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
            local badge = load_dynamic_badge( "hero_mode", {
                {_distance=GameHasFlagRun( MISC.HeroMode.DistanceDifficultyEnabled )},
                {_orbs=GameHasFlagRun( MISC.HeroMode.OrbsIncreaseDifficultyEnabled )},
            }, gkbrkn_localization );
            EntityAddChild( player_entity, badge );

            local character_platforming = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" );
            if character_platforming ~= nil then
                local speed_multiplier = 1.25;
                local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
                ComponentAdjustValues( character_platforming, {
                    jump_velocity_x = function(value) return tonumber( value ) * speed_multiplier; end,
                    jump_velocity_y = function(value) return tonumber( value ) * speed_multiplier; end,
                    fly_smooth_y = function(value) return "0"; end,
                    fly_speed_mult = function(value) return tonumber( fly_velocity_x ) * speed_multiplier; end,
                    fly_speed_max_up = function(value) return tonumber( fly_velocity_x ) * 1.5; end,
                    fly_speed_max_down = function(value) return tonumber( fly_velocity_x ) * 1.5; end,
                    fly_speed_change_spd = function(value) return tonumber( fly_velocity_x ) * speed_multiplier; end,
                });
                ComponentAdjustMetaCustoms( character_platforming, {
                    fly_velocity_x = function(value) return fly_velocity_x * speed_multiplier; end,
                    run_velocity = function(value) return tonumber( value ) * speed_multiplier; end,
                    --velocity_min_x = function(value) return tonumber( value ) * speed_multiplier; end,
                    velocity_max_x = function(value) return tonumber( value ) * speed_multiplier; end,
                    velocity_max_y = function(value) return tonumber( value ) * speed_multiplier; end,
                });
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
            local badge = load_dynamic_badge( "champion_mode", {
                {_always=GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled )},
                {_super=GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled )},
            }, gkbrkn_localization );
            EntityAddChild( player_entity, badge );
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