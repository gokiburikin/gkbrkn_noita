--[[
changelog
    -m "The Legendary Multicast QoL Update"
    -m "Add Action: Triple Cast"
    -m "Add Action: Time Compression"
    -m "Add Legendary Wand: Alchemic Lance"
    -m "Add Legendary Wand: Telefragger"
    -m "Add Legendary Wand: Pocket Black Hole"
    -m "Add Legendary Wand: Endless Alchemy"
    -m "Change config menu to include buttons for descriptions and previews for some content"
    -m "Change Action: Copy Spell (rename to Imitation, revert to previous functionality, clarify description)"
    -m "Change Action: Double Cast (now repeats an entire spell sequence instead of the next immediate spell, base cost 500 -> 400, mana cost 50 -> 30)"
    -m "Change Misc: Loadouts to utilize the dynamic wand sprite system instead of preset wand graphics"
    -m "Fix Misc: Less Particle > Disable Cosmetic Particles not disabling sparks"
    -m "Fix Misc: Slot Machine not appearing in the final Holy Mountain"
    -m "Fix Perk: Megacast's unintuitive draw behaviour (now draws all remaining cards only once at the start of the cast instead of every multicast)"

TODO
    make material compression fill all flasks you pick up for the first time (not possible right now)
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
    if content.init_function ~= nil then
        if content.enabled() then
            content.init_function();
        end
    end
end

--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/action_info.lua" );

ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_altar.lua" );
ModLuaFileAppend( "data/scripts/biomes/boss_arena.lua", "mods/gkbrkn_noita/files/gkbrkn/append/boss_arena.lua" );
ModLuaFileAppend( "data/scripts/items/chest_random.lua", "mods/gkbrkn_noita/files/gkbrkn/append/chest_random.lua" );
ModLuaFileAppend( "data/scripts/items/chest_random_super.lua", "mods/gkbrkn_noita/files/gkbrkn/append/chest_random_super.lua" );
ModLuaFileAppend( "data/scripts/biomes/temple_altar_left.lua", "mods/gkbrkn_noita/files/gkbrkn/append/goo_mode_temple_altar_left.lua" );
ModLuaFileAppend( "data/scripts/buildings/temple_check_for_leaks.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_check_for_leaks.lua" );

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
    if HasFlagPersistent( MISC.LimitedAmmo.Enabled ) then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/limited_ammo.lua" );
    end

    if HasFlagPersistent( MISC.UnlimitedAmmo.Enabled ) then
        ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/unlimited_ammo.lua" );
    end

    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn/starting_perks_config_append.lua" );
end