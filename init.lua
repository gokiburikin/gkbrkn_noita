--[[        
changelog
    -m "Add Game Modifier: Polymorph Immunity"
    -m "Dev Options are now hidden unless Options - Development Mode is enabled"
    -m "Update Option: Rainbow Projectiles (only randomize costmetic particles. fixes rainbow water trail, etc)"
    -m "Fix Champion Icons ragdolling when champion Lukki are killed"
    -m "Update Action: Area Damage (no longer incorrectly stacks, damage multiplier 50% -> 100%, damage radius 16 -> 10)"
    -m "Update Option: Manage External Content (don't show duplicate entries if mods incorrectly override vanilla spells)"
    -m "Fix Option: Classy Framework Integration (properly give custom loadouts)"
    -m "Fix Dev Option: No Polymorph"
    -m "Fix Selectable Classes and Classy Framework integration messy loadouts (no spinning wands, potion sparkles)"
    -m "Delay random start options until after loadouts are handled"
    -m "Fix Random Starts (no longer duplicates generate primary or secondary wand in the world)"
    -m "Fix outdated chest_random and chest_random_super scripts"
    -m "Add Game Modifier: Advanced Darkness"

some issues with noita (for if Nolla ever cares)
    explosive projectile (c.damage_explosion_add) is broken; damage is based on explosion radius
    add timer trigger, add trigger, and expiration trigger are fundamentally incorrectly implemented
    new statues can be killed and physically destroyed so they aren't good replacements to target dummy
    unlimited spells should work on all spells since there are infinite forms of healing and blackholes anyway
    far too many base game spells don't support modifiers in any interesting or meaningful way; very antithetical to the design of the gun system
    timer triggers should not also activate on hit / expiration--the other triggers exists for those reasons
    there should be a repeat timer trigger (that also doesn't activate on hit / expiration) so that self replicating / larpa triggers can be properly implemented
    projectile_file and related_projectiles should be implemented dynamically instead of manually (applied during Begin Projectile / parsed during action)
    damage modifiers are egregiously imbalanced compared to other modifiers (i.g. 7 mana drain for 44 damage: heavy shot)
    summon fly swarm is cheaper 5x piercing shots without friendly fire; certain spells and perks betray any understanding of the games previous balance / design
    certain functions don't return useful information
    certain functions contain local variables instead of accessible information
    persistent flags don't use a single file and instead use individuals files leading to hundreds (and potentially thousands) of files when dealing with many flags
    there is no simple config file serialization
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

ModTextFilePrepend( "data/entities/animals/boss_centipede/boss_centipede_update.lua", "mods/gkbrkn_noita/files/gkbrkn/append/boss_centipede_update.lua" );

if HasFlagPersistent( MISC.NoPregenWands.EnabledFlag ) then
    local pregen_wand_biomes = {
        "data/scripts/biomes/coalmine.lua",
        "data/scripts/biomes/coalmine_alt.lua",
        "data/scripts/biomes/tower.lua",
    };
    for _,entry in pairs( pregen_wand_biomes ) do
        ModLuaFileAppend( entry, "mods/gkbrkn_noita/files/gkbrkn/append/no_preset_wands.lua" );
    end
end

if HasFlagPersistent( MISC.LooseSpellGeneration.EnabledFlag ) then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/loose_spell_generation.lua" ); end

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
if HasFlagPersistent( MISC.Loadouts.ManageFlag ) then
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
        if HasFlagPersistent( MISC.Loadouts.SelectableClassesIntegrationFlag ) then
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
        if HasFlagPersistent( MISC.Loadouts.ClassyFrameworkIntegrationFlag ) then
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
    if HasFlagPersistent( MISC.Badges.EnabledFlag ) then ModTextFileAppend( "mods/nightmare/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/nightmare_mode_badge.lua" ); end
end

if HasFlagPersistent( MISC.LegendaryWands.EnabledFlag ) then dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/init.lua" ); end
--if HasFlagPersistent( MISC.FixedCamera.EnabledFlag ) then ModMagicNumbersFileAdd( "mods/gkbrkn_noita/files/gkbrkn/misc/magic_numbers_fixed_camera.xml" ); end

function OnPlayerSpawned( player_entity )
    if skip_loadout then GameAddFlagRun( FLAGS.SkipGokiLoadouts ); end
    if delay_init then GameAddFlagRun( FLAGS.DelayInit ); end
    if #(EntityGetWithTag( "gkbrkn_mod_config") or {}) == 0 then
        EntityLoad('mods/gkbrkn_noita/files/gkbrkn/gui/container.xml');
    end
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/player_spawned.lua", { player_entity = player_entity } );
end

function OnModPreInit()
    --[[ Tweaks ]]
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
    ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
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

--function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
function OnModPostInit() -- TODO this was done to allow init_function to call ModMaterialsFileAdd
    ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/content/actions.lua" );
    ModTextFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/content/perks.lua" );

	if HasFlagPersistent( FLAGS.GenerateRandomSpellbooks ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/generate_random_spellbooks.lua" ); end
    if HasFlagPersistent( FLAGS.DisableRandomSpells ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/disable_spells.lua" ); end
    
    GKBRKN_CONFIG.cache_content();
    GKBRKN_CONFIG.parse_content( true );

    -- On first launch enable any options that should be enabled by default
    if HasFlagPersistent("gkbrkn_first_launch") == false then
        AddFlagPersistent("gkbrkn_first_launch");
        for _,option in pairs( GKBRKN_CONFIG.OPTIONS ) do
            if option.SubOptions ~= nil then
                for _,sub_option in pairs(option.SubOptions) do
                    if sub_option.EnabledByDefault then
                        AddFlagPersistent( sub_option.PersistentFlag );
                    end
                end
            else
                if option.EnabledByDefault then
                    AddFlagPersistent( option.PersistentFlag );
                end
            end
        end
    end

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