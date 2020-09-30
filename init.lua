--[[
changelog
    -m "Add Action: Control"
    -m "Add Action: Separator"
    -m "Add Action: Target Shot"
    -m "Fix Option: Champions - Minibosses (add the health bonus back in)"
    -m "Fix Perk: Glass Cannon (no longer crash the game when you preview a tweaked Glass Cannon)"
    -m "Update Action: Empower (damage +0 -> +2, fix damage being slightly off)"
    -m "Update Action: Fracture (properly stackable, mana cost 1x -> 3x)"
    -m "Update Action: Path Correction (update icon, increase correction range)"
    -m "Update Action: Speed Down (speed multiplier 0.33x -> 0.4x)"
    -m "Update Action: Seeker Shot (update icon)"
    -m "Update Option: Target Dummy (no gravity so it doesn't fall through the holy mountain, don't show health bar)"
    -m "Update Perk: Mana Manipulation (reallocates only a portion of each mana stat, no longer stackable)"

BUG
    grimoires should either be no limited uses or all limited uses or something, fix this somehow
    zenti is finding "infinite" mana wands
    WE ARE finding too many extremely similar wands, check the RNG state
    remove polyblood from minibosses
    grimoires should not include deprecated spells

TODO
    Player Orbitals - projectiles orbits around the player
    lukki leg champion
    valour champion mode - +2-3 base mods, can stack stackable mods
    add champion type weightings

    Wand Upgrades
        1 wand upgrade token per standard biome replacing an enemy
        wand upgrade tokens used to upgrade held wand
        wand upgrade choices random like perks

    Trigger Ideas
        Trigger on Bounce
        Trigger on Kick
        Trigger while Flying

    mana focus (reduce mana cost of your next spell cast every second up to 10 seconds. resets every cast)
    charged spell (increase damage your next spell cast every second up to 10 seconds. resets every cast)
    override critical logic for critical callbacks (roll critical chance, if it succeeds set it to 100 and mark the projectile as critical, if it fails, set it to 0)

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
    Melee Immunity
    Explosion

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
ModLuaFileAppend( "data/scripts/buildings/temple_check_for_leaks.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_check_for_leaks.lua" );
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

if HasFlagPersistent( MISC.NoPregenWands.EnabledFlag ) then
    local pregen_wand_biomes = {
        "data/scripts/biomes/coalmine.lua",
        "data/scripts/biomes/coalmine_alt.lua",
    };
    for _,entry in pairs( pregen_wand_biomes ) do
        ModLuaFileAppend( entry, "mods/gkbrkn_noita/files/gkbrkn/append/no_preset_wands.lua" );
    end
end

if HasFlagPersistent( MISC.LooseSpellGeneration.EnabledFlag ) then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/loose_spell_generation.lua" ); end

ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/append/perk_list.lua" );
ModLuaFileAppend( "data/scripts/perks/perk.lua", "mods/gkbrkn_noita/files/gkbrkn/append/perk.lua" );
ModLuaFileAppend( "data/scripts/items/generate_shop_item.lua", "mods/gkbrkn_noita/files/gkbrkn/append/generate_shop_item.lua" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/hot_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/poly_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/killer_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/alt_killer_goo.xml" );

local selectable_classes_integration = false;
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
    ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn/content/parse_external_loadouts.lua" );

    if ModIsEnabled("selectable_classes") then
        if HasFlagPersistent( MISC.Loadouts.SelectableClassesIntegrationFlag ) then
            ModTextFileAppend( "data/selectable_classes/classes/class_list.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_integration.lua" );
            ModTextFileAppend( "data/selectable_classes/classes/class_pickup.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_extension.lua" );
            selectable_classes_integration = true;
        end
    end
end

if ModIsEnabled("nightmare") then
    if HasFlagPersistent( MISC.Badges.EnabledFlag ) then ModTextFileAppend( "mods/nightmare/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/nightmare_mode_badge.lua" ); end
end

if HasFlagPersistent( MISC.LegendaryWands.EnabledFlag ) then dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/init.lua" ); end
if HasFlagPersistent( MISC.FixedCamera.EnabledFlag ) then ModMagicNumbersFileAdd( "mods/gkbrkn_noita/files/gkbrkn/misc/magic_numbers_fixed_camera.xml" ); end

function OnPlayerSpawned( player_entity )
    if selectable_classes_integration then
        GameAddFlagRun( FLAGS.SkipGokiLoadouts );
    end
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

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
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
    if find_game_modifier("limited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" ); end
    if find_game_modifier("unlimited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" ); end
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_actions.lua" );
end