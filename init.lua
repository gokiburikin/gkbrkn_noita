--[[
api issues
    no event callback hook registration whatver for certain important actions
        the biggest nice to haves:
            entity created / loaded
            
    no overriding of base game events in a modular interoperable way (currently have to overwrite or keep custom code up to date
        with every change)

    not enough returning of important values in widely use functions

    too much blackboxing of otherwise important game information (the biome levels in generate_shop_item for example)

    no component copy methods
    

changelog
    -m "Shoutouts to DunkOrSlam and the Moist Mob for the gameplay and feedback"
    -m "Rework Action: Magic Hand so that it retains spread"
    -m "Rework Action: Zap to be closer to the original concept"
    -m "Rework Action: Perfect Critical into Damage Plus - Critical. Increases spell critical damage instead of 100% critical chance"
    -m "Rework Loadout: Spark to fit the new Action: Zap rework"
    -m "Rework Champion: Digging Projectile to be more effective"
    -m "Rework Perk: Demolitionist (explosion power and radius x1.5 -> explosion power and radius +200%)"
    -m "Rework Misc: Hero Mode wand adjustment values"
    -m "Reduce the spawn probability of Action: Projectile Orbit and Action: Projectile Gravity Well"
    -m "Rename Action: Modification Field to Circle of Divine Blessing"
    -m "Reword some spell descriptions"
    -m "Add Loadout: Charge"
    -m "Add Loadout: Alchemist"
    -m "Add Loadout: Kamikaze"
    -m "Add Loadout: Trickster"
    -m "Add Loadout: Treasure Hunter"
    -m "Add the loadout message to the localization file"
    -m "Add Misc: Chests Can Contain Perks"
    -m "Add Misc: Legendary Wands (work in progress)"
    -m "Add a Mini-Boss option to Misc: Champion Enemies"
    -m "Add Champion: Reward (used for Mini-Bosses)"
    -m "Add Action: Treasure Sense"
    -m "Add Action: Nugget Shot"
    -m "Add Action: Protective Enchantment"
    -m "Add Action: Chain Cast"
    -m "Add Perk: Demote Always Cast"
    -m "Add Tweak: Reduce Stun Lock"
    -m "Add support for not processing (combining, etc) gold nuggets with the tag gkbrkn_special_goldnugget"
    -m "Add a gold bonus for killing Hero Mode enemies (re-added since persistent gold was separated from Hero Mode)"
    -m "Buff Perk: Fragile Ego (damage resistance 50% -> 75%)"
    -m "Update Perk: Always Cast icon"
    -m "Update Action: Barrier Trail icon"
    -m "Deprecate: Action: Shimmering Treasure"
    -m "Deprecate: Action: Relevation"
    -m "Deprecate: Action: Super Bounce"
    -m "Fix Misc: No Preset Wands not including trap room wands"
    -m "Fix Misc: Gold Decay not properly clearing scripts on pickup"
    -m "Fix Misc: Target Dummy burning and taking massive damage from fire"
    -m "Fix Misc: Target Dummy not appearing in the final Holy Mountain"
    -m "Fix Misc: Hero Mode buffing duplicated wands and loadout wands"
    -m "Fix Misc: Hero Mode causing support enemies to prioritize you"
    -m "Fix Champion: Ice Burst spawning projectiles inside of enemies killing them instantly"
    -m "Fix Champion: Revenge Explosion not using the updated revenge explosion script"
    -m "Fix Action: Damage Plus - Lifetime and Damage Plus: Bounce icons not matching vanilla icons"
    -m "Fix Action: Projectile Orbit not working correctly with disc projectiles"
    -m "Fix Perk: Demolitionist not working on lightning spells"
    -m "Fix options that were intended to be disabled by default being enabled by default"

TODO
    make material compression fill all flasks you pick up for the first time (don't know if this is possible right now)
    remove or rework super bounce


UTILITY
    TODO
        Spell Power (utility stat on wand stat windows) (not yet possible?)

ACTIONS
    TODO
        damage cut (damage below a certain number is blocked) (can't override damage right now)
        Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
        Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)
        Dynamic spell compression (combine random spells into single cards that expand into their actions when cast)

PERKS
    TODO
        Double Cast (all spells cast twice)
        Lucky Dodge (small chance to evade damage) (can't be implemented how i want it yet)
        Wand Merge (merge two wands into a new wand with the best aspects of either wand)
        Lucky Draw (reset the perk reroll cost) (too powerful)
        Gold Rush (enemies explode into more and more gold as your kill streak continues)
        Chaos (randomize projectile stuff)
    NYI
        Dual Wield would probably be an excessively difficulty task to implement, but it would be cool if you could designate a Wand to dual wield.

ABANDONED
    Lava, Acid, Poison (Material) Immunities (impossible for now? can ignore _all_ materials, but not individual materials)
        damage_materials cached or something
    Stunlock Immunity (might be possible with small levels of knockback protection?)
        just don't think it's possible right now
    Life Steal (1% of damage dealt is returned as life)
        probably overpowered
    Spell Steal ( n% gain an additional spell charge for a random (weighted by max use) spell in a random wand )
        probably overpowered
    Slot Machine (official mechanic)
        could still be done buuuuuuuut...
    The ability to swallow an item (wand, spell, flask?) and spit it back up upon taking damage? Kind of weird, but has interesting utility. Basically a janky additional inventory slot.
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