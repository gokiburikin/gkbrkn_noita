--[[
changelog
    -m "The Refactor Update"
    -m "Add Action: Burst Fire"
    -m "Add Action: Curious Path"
    -m "Add Action: Empower"
    -m "Add Action: Fracture"
    -m "Add Action: Mana Efficiency"
    -m "Add Action: Paper Shot"
    -m "Add Action: Rapid Shot"
    -m "Add Action: Seeker Shot"
    -m "Add Action: Trigger - Repeat"
    -m "Add Action: Trigger - Take Damage"
    -m "Add Action: Volatile Magic"
    -m "Add Game Modifer: Enemy Intangibility Frames"
    -m "Add Game Modifer: Enemy Invincibility Frames"
    -m "Add Game Modifer: Keep Moving"
    -m "Add gun.lua: calculate_mana function for affecting spell mana cost (takes base_mana, returns mana_cost, used to override or adjust spell mana cost)"
    -m "Add Option - Target Dummy: Allow Environmental Damage (this allows you to calculate dps for otherwise non-player damage, percentage based damage is problematic)"
    -m "Add Option: Generate Random Spellbooks (dynamically generate collections of 3-6 spells in a single action)"
    -m "Add Option: Manage External Content (disable actions and perks from other mods or the base game)"
    -m "Add Option: Shop Reroller"
    -m "Add Option: Show Mod Tips"
    -m "Add Option: Show Targeted Perk Descriptions"
    -m "Add Option: Verbose Menus"
    -m "Add Perk: Recursion"
    -m "Add Tweak: Allow Negative Mana Always Cast (fixes Increase Mana not working as always cast)"
    -m "Add Tweak: Reduced Eletrocution (One Ukko won't stun you long enough to double hit you)"
    -m "Add Tweak: Trigger Block Expansion (multiple projectile spells have multiple trigger blocks)"
    -m "Add Unique Wand: Projectile Thrower"
    -m "Deprecate Option: Charm Nerf (added to base game)"
    -m "Fix a few existing and future mod compatibility issues"
    -m "Fix a projectile capturing bug where even multicasts cause projectile captures to fail (was doing xor instead of or)"
    -m "Fix Action: Magic Hand (now affects physics based projectiles)"
    -m "Fix Action: Time Split (now casts the next spell)"
    -m "Fix Game Modifier: Guaranteed Always Cast (now supports starting wands + random starting wands)"
    -m "Fix Game Modifier: Kick Spells Off Wands (can no longer kick permanently attached spells)"
    -m "Fix many goki's things perks appearing twice in the progress list"
    -m "Fix Option: Champions (no longer stacks rewards scripts when reloading from a saved game)"
    -m "Fix Option: Disable Spells (had stopped working at some point)"
    -m "Fix Option: Show Damage Numbers on worms (no longer rotate with the head)"
    -m "Fix Option: Target Dummy (add enemy tag)"
    -m "Fix Option: Use Player Cape Colours (properly grabs the cape edge color)"
    -m "Fix Perk: Duplicate Wand (duplicate actions retain position in the wand)"
    -m "Fix Perk: Trick Blood Money (now works with goki's things)"
    -m "Fix Perk: Wand Fusion (no longer spawns spells at 0,0 instead of player position when acquired as the starting perk)"
    -m "Fix starting perks not reflecting perk replacements done by enabled Tweaks"
    -m "Fix Target Dummy being killable (hopefully)"
    -m "Fix Unique Wands showing up even if they were toggled off"
    -m "Rename Action: Bound Shot -> Bind"
    -m "Rename Option: Show Hovered Entity Names -> Show Targeted Entity Names"
    -m "Update Action: Spell Merge (rework to support up to 32 Spell Merge groups, may break certain merges but shouldn't)"
    -m "Update damage number and gold pickup fonts"
    -m "Update gun.lua to properly recursively call add_projectile when Extra Projectile modifiers are present"
    -m "Update localization throughout the mod (utilize proper translation file append)"
    -m "Update Option: Champions (champions now drop more gold for each modifier they have)"
    -m "Update Option: Pretty Health Bars (slight graphical changes)"
    -m "Update Option: Show Damage Numbers (no longer emissive, can't see through fog of war)"
    -m "Update Option: Target Dummy (move the dummy to the left)"
    -m "Update Perk: Extra Projectile (cast delay +.13 -> +.03, recharge time +.13 -> +.03)"
    -m "Update Perk: Hyper Casting (changed from high speed multipler to high acceleration)"
    -m "Update Perk: Mana Manipulation (swap mana and mana recharge -> equalize mana and mana recharge and multiply by 1.1 * stacks)"
    -m "Update Perk: Protagonist (move logic to player_shot)"
    -m "Update Unique Wand: Matra Magic (complete rework)"

TODO
    Packs
        content definable card packs that have actions with weights. used to replace shops
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

]]

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
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

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
    ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/content/actions.lua" );
    ModTextFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/content/perks.lua" );

    --[[ Champion Types ]]
        local goki_champion_types = { "damage_buff", "projectile_buff", "knockback", "rapid_attack", "faster_movement", "teleporting", "burning", "freezing", "invisible", "regenerating", "revenge_explosion", "energy_shield", "electric", "projectile_repulsion_field", "hot_blooded", "gunpowder_blood", "frozen_blood", "projectile_bounce", "eldritch", "armored", "toxic_trail", "counter", "ice_burst", "infested", "digging", "leaping", "jetpack", "sparkbolt", "reward" };
        local deprecated_goki_champion_types = { "healthy","invincibility_frames" };
        for _,champion_type in pairs( goki_champion_types ) do
            ModTextFileAppend( "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua", "mods/gkbrkn_noita/files/gkbrkn/champion_types/"..champion_type.."/init.lua" );
        end
        if HasFlagPersistent( FLAGS.ShowDeprecatedContent ) then
            for _,champion_type in pairs( deprecated_goki_champion_types ) do
                ModTextFileAppend(  "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua", "mods/gkbrkn_noita/files/gkbrkn/champion_types/"..champion_type.."/init.lua" );
            end
        end

	if HasFlagPersistent( FLAGS.GenerateRandomSpellbooks ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/generate_random_spellbooks.lua" ); end
    if HasFlagPersistent( FLAGS.DisableRandomSpells ) then ModTextFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/disable_spells.lua" ); end
    
    GKBRKN_CONFIG.cache_content();
    GKBRKN_CONFIG.parse_content( true );

    -- On first launch enable any options that should be enabled by default
    if HasFlagPersistent("gkbrkn_first_launch") == false then
        local CONTENT = GKBRKN_CONFIG.CONTENT;
        local OPTIONS = GKBRKN_CONFIG.OPTIONS;
        AddFlagPersistent("gkbrkn_first_launch");
        for _,option in pairs(OPTIONS) do
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


    -- Spell Merge Grouping Dynamic Files
    for i=0,31 do
        ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/scratch/projectile_depth_"..i..".xml","<Entity><LuaComponent remove_after_executed=\"1\" execute_on_added=\"1\" script_source_file=\"mods/gkbrkn_noita/files/gkbrkn/scratch/projectile_depth_"..i..".lua\"></LuaComponent></Entity>" );
        ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/scratch/projectile_depth_"..i..".lua","dofile_once( \"mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua\" ); local entity = GetUpdatedEntityID(); EntitySetVariableNumber( entity, \"gkbrkn_projectile_depth\", "..i.." );" );
    end

    append_translations("mods/gkbrkn_noita/files/gkbrkn/append/common.csv");

    GKBRKN_CONFIG.disable_content();

    dofile( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua");
    if find_game_modifier("limited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" ); end
    if find_game_modifier("unlimited_ammo") then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" ); end
end