--[[
changelog
    -m "The Update Before the Break Update"
    -m "Add an additional on-screen message when development mode is enabled"
    -m "Add Game Modifier: Floor is Lava"
    -m "Add Game Modifier: Guaranteed Always Cast"
    -m "Add Game Modifier: Hot Goo Mode"
    -m "Add Game Modifier: Killer Goo Mode"
    -m "Add Game Modifier: No Hit"
    -m "Add Game Modifier: Order Wands Only"
    -m "Add Game Modifier: Poly Goo Mode"
    -m "Add Game Modifier: Remove Generic Wands"
    -m "Add Game Modifier: Shuffle Wands Only"
    -m "Add Game Modifier: Spell Shops Only"
    -m "Add Game Modifier: Unlimited Levitation"
    -m "Add Loadout: Blood"
    -m "Add Loadout: Combustion"
    -m "Add Loadout: Eldritch"
    -m "Add Loadout: Event Horizon"
    -m "Add Loadout: Geomancer"
    -m "Add Loadout: Hydromancy"
    -m "Add Loadout: Light"
    -m "Add Loadout: Rapid"
    -m "Add Loadout: Speed"
    -m "Add Loadout: Taikasauva Terror"
    -m "Add Option: Show Deprecated Content for toggling of content that has been removed from Goki's Things without requiring config file editing"
    -m "Add Unique Wand: Auto Spell"
    -m "Change Action: Double Cast (mana cost 30 -> 8)"
    -m "Change Action: Passive Recharge (recharge time 0 -> -0.2)"
    -m "Change Action: Protective Enchantment (spawn weighting 0.4 -> 1)"
    -m "Change Action: Spell Duplicator (fixes nested duplicators retaining modifiers of internal casts, still doesn't fix double/triple cast syngery)"
    -m "Change Action: Triple Cast (mana cost 50 -> 16)"
    -m "Change all goo mode loadouts to include All-seeing Eye"
    -m "Change development options to be disabled by default and hidden if development mode is not enabled"
    -m "Change Game Modifier: Limited Mana (more restrictive max mana calculation)"
    -m "Change Option: Target Dummy (fire resistance 100% -> 0%, don't track environmental damage)"
    -m "Change Options: Development Mode to not require a restart"
    -m "Change Options: Hero Mode: Carnage Mode (player gains a dense / extremely dense rock -> cursed rock aura)"
    -m "Change Perk: Wand Fusion (spells on the wand you're holding get moved to the new wand)"
    -m "Deprecate Perk: Passive Recharge"
    -m "Fix Action: Feather Shot (apply immediately instead of after 1 frame)"
    -m "Fix Game Modifier: Limited Mana not correctly accounting for special wands (fixes Perk: Duplicate Wand, Perk: Wand Fusion, Loadouts wands, etc)"
    -m "Fix kicking wands removing spells from them"
    -m "Fix Perk: Demote Always Cast not working if the spell doesn't have a non-always cast spell on it"
    -m "Fix Perk: Rapid Fire (no longer slow the wand down if it has negative cast delay or recharge time)"
    -m "Move Option: Limited Ammmo and Option: Unlimited Ammo to Game Modifier: Limited Ammo and Game Modifier: Unlimited Ammo"
    -m "Move Option: Wand Shops Only to Game Modifier: Wand Shops Only"
    -m "Remove Game Modifier: Taikasauva Terror"
    -m "Rename Challenges to Game Modifiers"

TODO
    Hard Mode
        enemies gain damage resistance every time they are damaged by the player (excluding bosses)
            this reduces the effectiveness of spray and pray / tick damage weaponry
    Game Modifiers
        Spider Mage
            Lukki Mutation, Vampirism, More Blood x3, Enemy Radar, Slime Blood, Chainsaw Only, Immunities Forbidden
        Space Wizard
            Teleportitus, Freeze Field, every wand you build must have a Teleport spell (consider: bleed teleportitus, make every spawned wand always cast teleport.)
        Super Singularity Bros.
            Wand with always cast long-distance Giga Black Holes, can't use anything else.
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
    make material compression fill all flasks you pick up for the first time (not possible right now)
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

-- [[ Tweaks ]]
ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );

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
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/creepy_lava.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/poly_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/killer_goo.xml" );
ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/alt_killer_goo.xml" );

function OnPlayerSpawned( player_entity )
    print( "mod is enabled? "..tostring ( ModIsEnabled("gkbrkn_noita_extras") ) );
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
end

function OnModPostInit()
    if CONTENT[GAME_MODIFIERS.LimitedAmmo].enabled() then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" );
    end

    if CONTENT[GAME_MODIFIERS.UnlimitedAmmo].enabled() then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" );
    end
end