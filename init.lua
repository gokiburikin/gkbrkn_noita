--[[        
changelog


TWitch Event ideas
    All Enemies Gain 1 Perk (forever)
    Gold Value +/- N


TODO
    Gold Duration (Disabled -> 0 - 10 -> Infinite)
    Starting Health (1 -> 300)
    Gold = Health Regeneration
    Kills = Health Regeneration
    Passive Health Regeneration
    Selectable Cape Colour
    Selectable Laser Sight Colour
    make uber boss a slider
    move polymorph immunity game modifier out
    (look into this) if no legendary wands are enabled, don't spawn one

BUG
    the sparkler unique wand is broken (this is almost 100% a projectile capture issue)
    grimoires should either be no limited uses or all limited uses or something, fix this somehow
    remove polyblood from minibosses
    grimoires should not include deprecated spells

TODO
    Player Orbitals - projectiles orbits around the player
    lukki leg champion
    valour champion mode - +2-3 base mods, can stack stackable mods

    Wand Upgrades
        1 wand upgrade token per standard biome replacing an enemy
        wand upgrade tokens used to upgrade held wand
        wand upgrade choices random like perks

    Trigger Ideas
        Trigger on Bounce
        Trigger on Kick
        Trigger while Flying

    Game Modifiers
        Spider Mage
            Lukki Mutation, Vampirism, More Blood x3, Enemy Radar, Slime Blood, Chainsaw Only, Immunities Forbidden
        Space Wizard
            Teleportitus, Freeze Field, every wand you build must have a Teleport spell (consider: bleed teleportitus, make every spawned wand always cast teleport.)
        Use What You See
            You must use every wand you come across. Spells are allowed to be edited, but you can't change the base wand unless you find a replacement. Shop wands only.
    Nest Tweak
        Add gold drops for things spawned from nests
    Adds Tweak
        Create new projectile / adds logic so that adds don't spawn champions
    Perk: Thunder Thighs
        Kicks carry an electric charge
    Pot of Greed
        suck up items you don't want, turn them into gold

EXTRA THINGS
    lily pikku (big scarf?)
mimic perks
    Strong Leviathan
    Prague Rats
    Invisibility Frames

ACTIONS
    damage cut (damage below a certain number is blocked) (can't override damage right now)
    Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
    Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)

PERKS
    Double Cast (all spells cast twice) (probably too powerful)
    Lucky Dodge (small chance to evade damage) (can't be implemented how i want it yet)
    Lucky Draw (reset the perk reroll cost) (too powerful)
    Gold Rush (enemies explode into more and more gold as your kill streak continues)
    NYI
        Dual Wield would probably be an excessively difficulty task to implement, but it would be cool if you could designate a Wand to dual wield.

ABANDONED
    Lava, Acid, Poison (Material) Immunities (works if you're willing to polymorph the player for a frame. i'm not)

Champion Type Ideas
    Pilfer (steal gold on hit)
    Pickpocket/Fumbling (remove the item in your hand)
    Fear (line of sight causes a debuff)
    Fire Trail (like the one that drops the particles)

]]
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
append_translations( "mods/gkbrkn_noita/files/gkbrkn/append/common.csv" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "data/scripts/lib/utilities.lua");

--[[ Biomes ]]
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_altar.lua" );
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/gkbrkn_noita/files/gkbrkn/append/boss_arena.lua" );
ModLuaFileAppend( "data/scripts/biomes/temple_altar_left.lua", "mods/gkbrkn_noita/files/gkbrkn/append/goo_mode_temple_altar_left.lua" );

--[[ Workshop ]]
ModLuaFileAppend( "data/scripts/buildings/workshop_exit.lua", "mods/gkbrkn_noita/files/gkbrkn/append/workshop_exit.lua" );
ModLuaFileAppend( "data/scripts/buildings/workshop_exit_final.lua", "mods/gkbrkn_noita/files/gkbrkn/append/workshop_exit_final.lua" );

--[[ Chest Extensions ]]
ModLuaFileAppend( "data/scripts/items/chest_random.lua", "mods/gkbrkn_noita/files/gkbrkn/append/chest_random.lua" );
ModLuaFileAppend( "data/scripts/items/chest_random_super.lua", "mods/gkbrkn_noita/files/gkbrkn/append/chest_random_super.lua" );

--[[ Gun System Extension ]]
--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/action_info.lua" );
ModLuaFileAppend( "data/scripts/gun/gun.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun.lua" );
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_extra_modifiers.lua" );
ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_procedural.lua" );

ModRegisterAudioEventMappings( "mods/gkbrkn_noita/files/GUIDs.txt" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/rainbow_materials.xml" );

ModTextFilePrepend( "data/entities/animals/boss_centipede/boss_centipede_update.lua", "mods/gkbrkn_noita/files/gkbrkn/append/boss_centipede_update.lua" );

if setting_get( MISC.NoPregenWands.EnabledFlag ) then
    local pregen_wand_biomes = {
        "data/scripts/biomes/coalmine.lua",
        "data/scripts/biomes/coalmine_alt.lua",
        "data/scripts/biomes/tower.lua",
    };
    for _,entry in pairs( pregen_wand_biomes ) do
        ModLuaFileAppend( entry, "mods/gkbrkn_noita/files/gkbrkn/append/no_preset_wands.lua" );
    end
end

if setting_get( MISC.LooseSpellGeneration.EnabledFlag ) then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/loose_spell_generation.lua" ); end

ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/append/perk_list.lua" );
ModLuaFileAppend( "data/scripts/perks/perk.lua", "mods/gkbrkn_noita/files/gkbrkn/append/perk.lua" );
ModLuaFileAppend( "data/scripts/items/generate_shop_item.lua", "mods/gkbrkn_noita/files/gkbrkn/append/generate_shop_item.lua" );

-- TODO only enable these when they need to be disabled
-- can't trivially do right now because ModMaterialsFileAdd doesn't work in OnMagicNumbersAndWorldSeedInitialized
--ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/poly_goo.xml" );
--ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/hot_goo.xml" );
--ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/killer_goo.xml" );
--ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/alt_killer_goo.xml" );

local skip_loadout = false;
local delay_init = false;
if setting_get( MISC.Loadouts.ManageFlag ) then
    if ModIsEnabled("starting_loadouts") then
        ModTextFileAppend( "mods/starting_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/kill_player_spawned_event.lua" );
        ModTextFileAppend( "mods/starting_loadouts/files/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/starting_loadouts_append.lua" );
        ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/starting_loadouts/files/loadouts.lua" );
    end
    if ModIsEnabled("Kaelos_Archetypes") then
        ModTextFileAppend( "mods/Kaelos_Archetypes/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/kill_player_spawned_event.lua" );
        ModTextFileAppend( "mods/Kaelos_Archetypes/files/K_Archetypes/Archetypes.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/kaelos_loadouts_append.lua" );
        ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/Kaelos_Archetypes/files/K_Archetypes/Archetypes.lua" );
    end
    if ModIsEnabled("more_loadouts") then
        ModTextFileAppend( "mods/more_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/kill_player_spawned_event.lua" );
        ModTextFileAppend( "mods/more_loadouts/files/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/more_loadouts_append.lua" );
        ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/more_loadouts/files/loadouts.lua" );
    end

    if ModIsEnabled("selectable_classes") then
        ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/content/selectable_classes_loadouts.lua", ModTextFileGetContent( "data/selectable_classes/classes/class_list.lua" ) );
        ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/selectable_classes_loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_append.lua" );
        ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn/content/selectable_classes_loadouts.lua" );
        if setting_get( MISC.Loadouts.SelectableClassesIntegrationFlag ) then
            ModTextFileAppend( "data/selectable_classes/classes/class_list.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_integration.lua" );
            ModTextFileAppend( "data/selectable_classes/classes/class_pickup.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_extension.lua" );
            skip_loadout = true;
            delay_init = true;
        else
            --ModTextFileSetContent( "mods/selectable_classes/init.lua", [[print("[goki's things] Terminated Selectable Classes Initialization")]] );
            ModTextFileSetContent( "data/selectable_classes/magic_numbers.xml", "" );
            ModTextFileSetContent( "data/selectable_classes/treehouse.lua", "" );
            ModTextFileAppend( "mods/selectable_classes/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/kill_player_spawned_event.lua" );
        end
    end

    if ModIsEnabled("classy_framework") then
        if setting_get( MISC.Loadouts.ClassyFrameworkIntegrationFlag ) then
            ModTextFileAppend( "mods/classy_framework/classes/class_list.lua","mods/gkbrkn_noita/files/gkbrkn_loadouts/classy_framework_integration.lua" );
            ModTextFileAppend( "mods/classy_framework/class_select/class_pickup.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/classy_framework_extension.lua" );
            skip_loadout = true;
            delay_init = true;
        else
            ModTextFileSetContent( "mods/classy_framework/init.lua", [[print("[goki's things] Terminated Classy Framework Initialization")]] );
        end
    end

    ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn/content/parse_external_loadouts.lua" );
end

if ModIsEnabled("nightmare") then
    if setting_get( MISC.Badges.EnabledFlag ) then ModTextFileAppend( "mods/nightmare/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/nightmare_mode_badge.lua" ); end
end

if setting_get( MISC.LegendaryWands.EnabledFlag ) then dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/init.lua" ); end
if setting_get( MISC.FixedCamera.OldBehaviourFlag ) then ModMagicNumbersFileAdd( "mods/gkbrkn_noita/files/gkbrkn/misc/magic_numbers_fixed_camera.xml" ); end
if setting_get( FLAGS.EnableLogging ) then ModMagicNumbersFileAdd( "mods/gkbrkn_noita/files/gkbrkn/misc/magic_numbers_enable_logging.xml" ); end

function OnPlayerSpawned( player_entity )
    GlobalsSetValue( "mod_button_tr_width", "0" );
    if skip_loadout then GameAddFlagRun( FLAGS.SkipGokiLoadouts ); end
    if delay_init then GameAddFlagRun( FLAGS.DelayInit ); end
    --if #(EntityGetWithTag( "gkbrkn_mod_config") or {}) == 0 then
    --    EntityLoad('mods/gkbrkn_noita/files/gkbrkn/gui/container.xml');
    --end
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/player_spawned.lua", { player_entity = player_entity } );
end

-- Add "Nolla" as the author to actions in gun_actions.lua
ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/scratch/actions_author.lua", "for _,action in pairs(actions) do action.author = action.author or \"Nolla\"; end" );
ModTextFileAppend( "data/scripts/gun/gun_actions.lua",  "mods/gkbrkn_noita/files/gkbrkn/scratch/actions_author.lua" );

-- Add "Nolla" as the author to perks in perk_list.lua
ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/scratch/perks_author.lua", "for _,perk in pairs(perk_list) do perk.author = \"Nolla\"; end" );
ModTextFileAppend( "data/scripts/perks/perk_list.lua",  "mods/gkbrkn_noita/files/gkbrkn/scratch/perks_author.lua" );

ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/actions/nugget_shot/materials.xml" );

--[[ Polymorph Nerf - This doesn't work how i want it to so for now being disabled until Nolla fixes status effects 
ModLuaFileAppend( "data/scripts/status_effects/status_list.lua", "mods/gkbrkn_noita/files/gkbrkn/append/status_list.lua" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/slow_polymorph.xml" );
]]


function OnModPreInit()
    --[[ Tweaks ]]
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
    ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
end

function OnModPostInit() -- TODO this was done to allow init_function to call ModMaterialsFileAdd
    if setting_get( MISC.SeededRuns.UseSeedNextRunFlag ) then
        local seed = setting_get( MISC.SeededRuns.SeedFlag );
        if #seed > 0 then
            seed = parse_custom_world_seed( seed );
        end
        SetWorldSeed( seed );
    end
    ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/content/actions.lua" );
    ModTextFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/content/perks.lua" );

	if setting_get( FLAGS.GenerateRandomSpellbooks ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/generate_random_spellbooks.lua" ); end
    if setting_get( FLAGS.DisableRandomSpells ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/disable_spells.lua" ); end
    
    GKBRKN_CONFIG.cache_content();
    GKBRKN_CONFIG.parse_content( true );

    -- Run any enabled content's init functions
    for content_id,content in pairs( GKBRKN_CONFIG.CONTENT ) do
        if content.init_function ~= nil then
            if content.enabled() then
                content.init_function();
            end
        end
    end

    GKBRKN_CONFIG.disable_content();

    dofile( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua");

    for _,game_modifier in pairs( game_modifiers ) do
        if game_modifier.options and game_modifier.options.init_callback then
            game_modifier.options.init_callback();
        end
    end
    if find_game_modifier("limited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" ); end
    if find_game_modifier("unlimited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" ); end
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_actions.lua" );
end

function OnWorldInitialized()
    local mod_button_reservation = tonumber( GlobalsGetValue( "mod_button_tr_width", "0" ) );
    GlobalsSetValue( "gkbrkn_mod_button_reservation", tostring( mod_button_reservation ) );
    GlobalsSetValue( "mod_button_tr_width", tostring( mod_button_reservation + 15 ) );

    dofile( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua");
    if find_game_modifier("darkness") then
        local biomes = {
            "coalmine",
            "mountain_hall",
            "coalmine_alt",
            "excavationsite",
            "fungicave",
            "snowcave",
            "snowcastle",
            "rainforest",
            "rainforest_open",
            "vault",
            "crypt",
        };
        for _,biome_name in pairs( biomes ) do
            BiomeObjectSetValue( "data/biome/" .. biome_name .. ".xml", "modifiers", "fog_of_war_delta", 10 );
        end
    end
end

function OnWorldPreUpdate()
    if GlobalsGetValue( "gkbrkn_mod_button_tr_max", "0" ) == "0" then
        GlobalsSetValue( "gkbrkn_mod_button_tr_max", GlobalsGetValue( "mod_button_tr_width", "0" ) );
    end
    dofile( "mods/gkbrkn_noita/files/gkbrkn/gui/update.lua" );
end

local last_time = GameGetRealWorldTimeSinceStarted();
local current_fps = 0;
local times = {};
function OnWorldPostUpdate()
    GlobalsSetValue( "mod_button_tr_current", "0" );
    --[[ More Accurate Smoothed FPS ]]
    local now = GameGetRealWorldTimeSinceStarted();
    local time_sum = 0;
    table.insert( times, now - last_time );
    last_time = now;
    if #times > 5 then table.remove( times, 1 ); end
    for k,v in ipairs( times ) do time_sum = time_sum + v; end
    local fps = math.floor( (1 / (time_sum / #times) ) );
    current_fps = current_fps + ( fps - current_fps ) / 4;
    GlobalsSetValue( "gkbrkn_fps", tostring( math.ceil( current_fps ) ) );

    local x, y = 0, 0;
    local player = EntityGetWithTag( "player_unit" )[1];
    if player == nil or player == 0 then
        player = ( find_polymorphed_players() or {} )[1];
    end
    if player ~= nil and player ~= 0 then
        x, y = EntityGetTransform( player );
        if is_fixed_camera == nil then is_fixed_camera = not setting_get( MISC.FixedCamera.EnabledFlag ); end
        if setting_get( MISC.FixedCamera.EnabledFlag ) and not setting_get( MISC.FixedCamera.OldBehaviourFlag ) then
            if is_fixed_camera then
                local cx, cy = GameGetCameraPos();
                GameSetCameraPos( cx + ( x - cx ) / 1.2, cy + ( y - cy ) / 1.2 );
            else
                GameSetCameraFree( true );
                is_fixed_camera = true;
            end
        elseif not setting_get( MISC.FixedCamera.EnabledFlag ) or setting_get( MISC.FixedCamera.OldBehaviourFlag ) then
            if is_fixed_camera then
                GameSetCameraFree( false );
                is_fixed_camera = false;
            end
        end
    end

    if setting_get( FLAGS.ShowHitboxes ) then
        local mortals = EntityGetWithTag( "mortal" );
        for _,mortal in pairs(mortals) do
            if EntityHasTag( mortal, "debug_hitbox" ) == false then
                EntityAddTag( mortal, "debug_hitbox" );
                local origin = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/hitboxes/origin.xml" );
                EntityAddChild( mortal, origin );

                local components = EntityGetAllComponents( mortal ) or {};
                for _,component in pairs(components) do
                    if ComponentGetTypeName( component ) == "HitboxComponent" then
                        local hitbox = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/hitboxes/hitbox.xml" );
                        local width = tonumber( ComponentGetValue( component, "aabb_max_x" ) ) - tonumber( ComponentGetValue( component, "aabb_min_x" ) );
                        local height = tonumber( ComponentGetValue( component, "aabb_max_y" ) ) - tonumber( ComponentGetValue( component, "aabb_min_y" ) );
                        local x = -tonumber( ComponentGetValue( component, "aabb_min_x" ) );
                        local y = -tonumber( ComponentGetValue( component, "aabb_min_y" ) );
                        local sprite = EntityGetFirstComponent( hitbox, "SpriteComponent" );

                        ComponentSetValue( sprite, "has_special_scale", "1" );
                        ComponentSetValue( sprite, "special_scale_x", width / 10 );
                        ComponentSetValue( sprite, "special_scale_y", height / 10 );
                        EntityAddChild( mortal, hitbox );
                    end
                end
            end
        end
    else
        local mortals = EntityGetWithTag( "mortal" );
        for _,mortal in pairs( mortals ) do
            if EntityHasTag( mortal, "debug_hitbox" ) then
                EntityRemoveTag( mortal, "debug_hitbox" );
                local children = EntityGetAllChildren( mortal ) or {};

                for _,child in pairs( children ) do
                    if EntityHasNamedVariable( child, "gkbrkn_hitbox" ) then
                        EntityRemoveFromParent( child );
                        EntityKill( child );
                    end
                end
            end
        end
    end

    add_frame_time( GameGetRealWorldTimeSinceStarted() - now );
end