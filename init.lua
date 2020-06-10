--[[
changelog
    -m "Add Development Option: Cheap Rerolls"
    -m "Add Development Option: Infinite Money"
    -m "Add Game Modifier: Kick Spells Around"
    -m "Add Game Modifier: Kick Spells Off Wands"
    -m "Add Option: Show Damage Numbers"
    -m "Add Option: Rainbow Projectiles"
    -m "Add Unique Wand: Creation: Blue"
    -m "Add Unique Wand: Creation: Green"
    -m "Add Unique Wand: Creation: Red"
    -m "Add Unique Wand: The Huntress"
    -m "Add support for null actions in wand generation functions (nil will leave a blank space in the wand)"
    -m "Change Action: Path Correction (script updates)"
    -m "Change Action: False Spell (lifetime 0 -> 1)"
    -m "Change Action: Magic Hand (fix 0 velocity spells having an incorrect offset)"
    -m "Change Action: Spell Merge (mana cost 7 -> 14, remove on_collision_die adoption)"
    -m "Change font files used for DPS Tracker and Gold Tracker"
    -m "Change Loadout: Lancer (add forgotten digging wand)"
    -m "Change Option: Less Particles (include some missed player shots, update less particles logic for other entities)"
    -m "Change Game Modifier: Floor is Lava (properly inflict damage, deal more damage less often while grounded)"
    -m "Change Option: Show Health Bars (never ragdollify on death 0 -> 1)"
    -m "Change Perk: Always Cast (renamed Promote Spell)"
    -m "Change Perk: Demote Always Cast (renamed Demote Spell)"
    -m "Change Perk: Material Compression (now doubles the amount of liquid inside flasks as well, no more half empty flask pickups)"
    -m "Change Perk: Wand Fusion (no longer explodes frozen or permanently attached spells from merged wands; they are deleted instead, fusing 0 wands no longer produces a wand)"
    -m "Deprecate Tweak: Chain Bolt (no longer necessary)"
    -m "Update some scripts to utilize new API functions"
    -m "Optimize projectile capture functions (large increase in performance when many player projectiles are on screen)"

TODO
    Hard Mode
        enemies gain damage resistance every time they are damaged by the player (excluding bosses)
            this reduces the effectiveness of spray and pray / tick damage weaponry
    Game Modifiers
        Spider Mage
            Lukki Mutation, Vampirism, More Blood x3, Enemy Radar, Slime Blood, Chainsaw Only, Immunities Forbidden
        Space Wizard
            Teleportitus, Freeze Field, every wand you build must have a Teleport spell (consider: bleed teleportitus, make every spawned wand always cast teleport.)
        Use What You See
            You must use every wand you come across. Spells are allowed to be edited, but you can't change the base wand unless you find a replacement. Shop wands only.
    Alternative Enemies
        palette swapped enemies with new behaviours
    Nest Tweak
        Add gold drops for things spawned from nests
    Adds Tweak
        Create new projectile / adds logic so that adds don't spawn champions
    Perk: Thunder Thighs
        Kicks carry an electric charge
    Pot of Greed
        suck up items you don't want, turn them into gold

TODO EVENTUALLY
    fix spell duplicator to use the new peek actions functions instead of the inaccurate extremely complicated system it uses right now

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
    Dynamic spell compression (combine random spells into single cards that expand into their actions when cast)

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

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "data/scripts/lib/utilities.lua");

if HasFlagPersistent("gkbrkn_first_launch") == false then
    AddFlagPersistent("gkbrkn_first_launch")
    for _,content in pairs(CONTENT) do
        if content.disabled_by_default == true and content.inverted == true then
            AddFlagPersistent( GKBRKN_CONFIG.get_content_flag( content.id ) );
        end
    end
    for _,option in pairs(OPTIONS) do
        if option.EnabledByDefault == true then
            AddFlagPersistent( option.PersistentFlag );
        end
    end
end

--[[ Gun System Extension ]]
ModLuaFileAppend( "data/scripts/gun/gun.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun.lua" );
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_extra_modifiers.lua" );

for content_id,content in pairs( CONTENT ) do
    if content.init_function ~= nil then
        if content.enabled() then
            content.init_function();
        end
    end
end

--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/action_info.lua" );

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

if HasFlagPersistent( MISC.NoPregenWands.Enabled ) then
    local pregen_wand_biomes = {
        "data/scripts/biomes/coalmine.lua",
        "data/scripts/biomes/coalmine_alt.lua",
    };
    for _,entry in pairs( pregen_wand_biomes ) do
        ModLuaFileAppend( entry, "mods/gkbrkn_noita/files/gkbrkn/append/no_preset_wands.lua" );
    end
end


if HasFlagPersistent( MISC.LooseSpellGeneration.Enabled ) then
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/loose_spell_generation.lua" );
end

ModLuaFileAppend( "data/scripts/items/drop_money.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/charm_nerf.lua" );
ModLuaFileAppend( "data/scripts/gun/procedural/gun_procedural.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_procedural.lua" );
ModLuaFileAppend( "data/scripts/items/generate_shop_item.lua", "mods/gkbrkn_noita/files/gkbrkn/append/generate_shop_item.lua" );
ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn/starting_perks_config_append.lua" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/hot_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/poly_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/killer_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/alt_killer_goo.xml" );

function OnPlayerSpawned( player_entity )
    if HasFlagPersistent( MISC.DisableSpells.Enabled ) then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/disable_spells.lua" );
    end
    if #(EntityGetWithTag( "gkbrkn_mod_config") or {}) == 0 then
        EntityLoad('mods/gkbrkn_noita/files/gkbrkn/gui/container.xml');
    end
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/player_spawned.lua", { player_entity = player_entity } );
end

-- this file is mostly for backwards compatibility of the base game and more loadouts mods. this method should not be relied upon as it 
-- needs to know the layout and functionality of the underlying mods
-- prefer utilizing the register_loadout function like the examples

function try_append( init_filepath, support_append_filepath )
    local _, err = loadfile( init_filepath );
    if err == nil then
        ModLuaFileAppend( init_filepath, support_append_filepath );
        return truel
    end
    return false;
end

if HasFlagPersistent( MISC.Loadouts.Manage ) then
    try_append( "mods/starting_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/starting_loadouts_support.lua" );
    try_append( "mods/more_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/more_loadouts_support.lua" );
    try_append( "mods/Kaelos_Archetypes/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/kaelos_loadouts_support.lua" );
end

-- if selectable classes is loaded and available then
if HasFlagPersistent( MISC.Loadouts.SelectableClassesIntegration ) then
    try_append( "mods/selectable_classes/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/selectable_classes_support.lua" )
end 

if HasFlagPersistent( MISC.Badges.Enabled ) then
    try_append( "mods/nightmare/init.lua", "mods/gkbrkn_noita/files/gkbrkn/append/nightmare_mode_badge.lua" );
end

if HasFlagPersistent( MISC.LegendaryWands.Enabled ) then
    dofile( "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/init.lua" );
end

if HasFlagPersistent( MISC.FixedCamera.Enabled ) then
    ModMagicNumbersFileAdd( "mods/gkbrkn_noita/files/gkbrkn/misc/magic_numbers_fixed_camera.xml" );
end

function OnModPreInit()
    -- append the logic to parse the old loadouts as new loadouts
    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn_loadouts/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/parse_old_loadouts.lua" );
    -- slap the fully combined set of loadout files onto the end of config so it can be caught by the config menu and performed
    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/loadouts.lua" );
    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn_legendary_wands/register.lua" );
    -- handle dynamic removal generation
    -- TODO this doesn't work well at all
    --ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/removals_append.lua" );
    --ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_actions.lua" );
    --ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/append/perk_list.lua" ); 
    -- handle tweaks
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
    ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
end

function OnModPostInit()
    if CONTENT[GAME_MODIFIERS.LimitedAmmo].enabled() then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" );
    end

    if CONTENT[GAME_MODIFIERS.UnlimitedAmmo].enabled() then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" );
    end
end