--[[
changelog
-m "Adjust many action spawn weights"
-m "Add Action: Spell Duplicator"
-m "Add Tweak: Projectile Repulsion"
-m "Buff Perk: Mana Recovery (mana recharge speed +50 -> +100)"
-m "Buff Perk: Demolitionist (max durability to destroy +0 -> +2)"
-m "Fix Perk: Demolitionist increasing explosion damage (unintentional)"
-m "Fix Perk: Protagonist and Misc: Less Particle -> Player Projectiles not working on trigger fired projectiles"
-m "Fix Action: Magic Hand's initial capture distance"
-m "Fix Action: Zap going absolutely crazy with increased lifetime (just a little bit less crazy now)"
-m "Nerf Action: Protective Enchantment (mana cost 20 -> 23, spawn weighting 1.0 -> 0.4, cast delay 0 -> .283, recharge time 0 -> .283, projectile -> utility type, damage reduction 0% -> 70%)"
-m "Rebalance Action: Chaotic Burst to make it less powerful without modifiers (lifetime 240 -> 120, lifetime randomness 0 -> 60, mana cost 30 -> 42, damage 6 -> 4)"
-m "Rebalance Perk: Protagonist (damage +100% -> +200%, linear -> less effective while healthy)"
-m "Rename Action: Chain Cast to Action: Queued Cast"
-m "Rename Perk: Chain Casting to Queue Casting"
-m "Rework Action: Chain Cast to be a general Chain Bolt modifier"
-m "Rework Action: Nugget Shot to be more consistent (add projectile damage, lower speed slightly)"
-m "Add final boss health scaling to Misc: Hero Mode"
-m "Change Misc: Hero Mode distance scaling to use the places visited stat instead of total horizontal distance"
-m "Add Champion: Knockback"
-m "Add appropriate damage type resistances to relevant champion types"
-m "Buff Mini-Bosses (add Burning champion type)"
-m "Buff Champion: Haste (attack speed 150% -> 200%)"
-m "Fix Champion: Ice Burst and Champion: Counter/Reflect scripts not proccing when taking rapid tick damage (like fire)"
-m "Remove the cell eater from enemies in Misc: Hero Mode (ineffective, caused terrain oddities)"
-m "Remove projectile prediction from Champion: Projectile Buff (odd behaviour)"
-m "Rework Champion: Teleportation (less unprompted Holy Moutain assassination attempts)"
-m "Rework Misc: Champions -> Mini-Bosses (no more mini-bosses too early or too often)"
-m "Add Misc: Fixed Camera"
-m "Add Misc: Spell Slot Machine"
-m "Fix a script error when checking if an entity drops gold"
-m "Reword a handful of spell descriptions and config options for clarity"
-m "Update a handful of graphics here and there"

TODO
    make material compression fill all flasks you pick up for the first time (don't know if this is possible right now)
    nest tweak (1 gold for things spawned from nests)

ACTIONS
    damage cut (damage below a certain number is blocked) (can't override damage right now)
    Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
    Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)
    Dynamic spell compression (combine random spells into single cards that expand into their actions when cast)

PERKS
    Double Cast (all spells cast twice) (probably too powerful)
    Lucky Dodge (small chance to evade damage) (can't be implemented how i want it yet)
    Wand Merge (merge two wands into a new wand with the best aspects of either wand)
    Lucky Draw (reset the perk reroll cost) (too powerful)
    Gold Rush (enemies explode into more and more gold as your kill streak continues)
    Chaos (randomize projectile stuff) (probably not useful)
    NYI
        Dual Wield would probably be an excessively difficulty task to implement, but it would be cool if you could designate a Wand to dual wield.

ABANDONED
    Lava, Acid, Poison (Material) Immunities (works if you're willing to polymorph the player for a frame. i'm not)
    Slot Machine (official mechanic)
    Projectile Repulsion Field (official mechanic)

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
            AddFlagPersistent( get_content_flag( content.id ) );
        end
    end
    for _,option in pairs(OPTIONS) do
        if option.EnabledByDefault == true then
            AddFlagPersistent( option.PersistentFlag );
        end
    end
end

ModLuaFileAppend( "data/scripts/gun/gun.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun.lua" );
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "mods/gkbrkn_noita/files/gkbrkn/append/gun_extra_modifiers.lua" );

for content_id,content in pairs( CONTENT ) do
    if content.init_function ~= nil and content.enabled() then
        content.init_function();
    end
end

--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/action_info.lua" );

ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_altar.lua" );
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/gkbrkn_noita/files/gkbrkn/append/boss_arena.lua" );
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
ModLuaFileAppend( "data/scripts/items/generate_shop_item.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/wand_shops_only.lua" );

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
    end
end

if HasFlagPersistent( MISC.Loadouts.Manage ) then
    try_append( "mods/starting_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/starting_loadouts_support.lua" );
    try_append( "mods/more_loadouts/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/more_loadouts_support.lua" );
    try_append( "mods/Kaelos_Archetypes/init.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/kaelos_loadouts_support.lua" );
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
    if HasFlagPersistent( MISC.LimitedAmmo.Enabled ) then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" );
    end

    if HasFlagPersistent( MISC.UnlimitedAmmo.Enabled ) then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" );
    end

    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn/starting_perks_config_append.lua" );
end