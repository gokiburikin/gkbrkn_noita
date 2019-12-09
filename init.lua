--[[
api issues
    no event callback hook registration whatver for certain important actions
        the biggest nice to haves:
            entity created / loaded
            projectiles fired in a spell cast
            
    no overriding of base game events in a modular interoperable way (currently have to overwrite or keep custom code up to date
        with every change)

    not enough returning of important values in widely use functions

    too much blackboxing of otherwise important game information (the biome levels in generate_shop_item for example)

    no component copy methods
    

changelog

kill streaks events
grze events
passives as mini perks
    greed

HitEffect considerations
    ElectricitySourceComponent
    DamageNearbyEntitiesComponent
    WormAttractorComponent

TODO
    slowing attack champion
    modifier that reduces the projectile resistance of target it hits
    wand passive enemy drops one additional gold nugget
    king champion: champion enemies nearby

    look into using spread to determine formation stack distance
    champions that move the player around

    7 cast odd firebolt gravity well

    figure out physics based projectile velocity application
    look into what it takes to perform actions with an AbilityComponent
    add a disable cosmetic particles blacklist for certain entities (might not be possible)
    golden recharge (picking up gold reduces the recharge time on the wand) (passive? perk?)
    spell drop chance (drop money override, a chance to drop a spell of equal value)
    modifier that applies the next modifier to all projectiles in the wand
    make enemies imperfect / take time to aim towards you
    try a pathfinding algorithm

UTILITY
    TODO
        Spell Power (utility stat on wand stat windows) (not yet possible?)

ACTIONS
    TODO
        cut duration
        Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
        Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)
        Dynamic spell compression (combine random spells into single cards that expand into their actions when cast)

PERKS
    TODO
        Double Cast (all spells cast twice)
        Lucky Dodge (small chance to evade damage) (can't be implemented how i want it yet)
        Crit Crits (crits can crit) (probably can't do this yet)
        Wand Merge (merge two wands into a new wand with the best aspects of either wand)
        Lucky Draw (reset the perk reroll cost)
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

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "data/scripts/lib/utilities.lua");

if HasFlagPersistent("gkbrkn_first_launch") == false then
    AddFlagPersistent("gkbrkn_first_launch")
    for _,content in pairs(CONTENT) do
        if content.disabled_by_default == true then
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
    
if CONTENT[PERKS.DuplicateWand].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/duplicate_wand/init.lua" ); end
if CONTENT[PERKS.ShortTemper].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/init.lua" ); end
if CONTENT[PERKS.GoldenBlood].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/golden_blood/init.lua" ); end
--if CONTENT[PERKS.LivingWand].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/living_wand/init.lua" ); end
if CONTENT[PERKS.LostTreasure].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/lost_treasure/init.lua" ); end
if CONTENT[PERKS.ManaEfficiency].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/mana_efficiency/init.lua" ); end
if CONTENT[PERKS.ManaRecovery].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/mana_recovery/init.lua" ); end
if CONTENT[PERKS.MaterialCompression].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/material_compression/init.lua" ); end
if CONTENT[PERKS.PassiveRecharge].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/passive_recharge/init.lua" ); end
if CONTENT[PERKS.RapidFire].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/rapid_fire/init.lua" ); end
if CONTENT[PERKS.Resilience].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/resilience/init.lua" ); end
if CONTENT[PERKS.SpellEfficiency].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/spell_efficiency/init.lua" ); end
if CONTENT[PERKS.KnockbackImmunity].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/knockback_immunity/init.lua" ); end
if CONTENT[PERKS.AlwaysCast].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/always_cast/init.lua" ); end
if CONTENT[PERKS.HealthierHeart].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/healthier_heart/init.lua" ); end
if CONTENT[PERKS.InvincibilityFrames].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/invincibility_frames/init.lua" ); end
if CONTENT[PERKS.ExtraProjectile].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/extra_projectile/init.lua" ); end
if CONTENT[PERKS.Protagonist].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/protagonist/init.lua" ); end
if CONTENT[PERKS.FragileEgo].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/fragile_ego/init.lua" ); end
if CONTENT[PERKS.ThriftyShopper].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/thrifty_shopper/init.lua" ); end
if CONTENT[PERKS.Swapper].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/swapper/init.lua" ); end
if CONTENT[PERKS.Demolitionist].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/demolitionist/init.lua" ); end
if CONTENT[PERKS.Multicast].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/multicast/init.lua" ); end
if CONTENT[PERKS.MagicLight].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/init.lua" ); end

if CONTENT[ACTIONS.BounceDamage].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/bounce_damage/init.lua" ); end
if CONTENT[ACTIONS.BreakCast].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/break_cast/init.lua" ); end
if CONTENT[ACTIONS.ArcaneBuckshot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/init.lua" ); end
if CONTENT[ACTIONS.CollisionDetection].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/init.lua" ); end
if CONTENT[ACTIONS.CopySpell].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/copy_spell/init.lua" ); end
if CONTENT[ACTIONS.DrawDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/draw_deck/init.lua" ); end
if CONTENT[ACTIONS.DoubleCast].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/double_cast/init.lua" ); end
if CONTENT[ACTIONS.ExtraProjectile].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/extra_projectile/init.lua" ); end
if CONTENT[ACTIONS.GoldenBlessing].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/golden_blessing/init.lua" ); end
if CONTENT[ACTIONS.LifetimeDamage].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/lifetime_damage/init.lua" ); end
if CONTENT[ACTIONS.MagicLight].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/init.lua" ); end
if CONTENT[ACTIONS.ManaEfficiency].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/mana_efficiency/init.lua" ); end
if CONTENT[ACTIONS.ManaRecharge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/init.lua" ); end
if CONTENT[ACTIONS.ModificationField].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/init.lua" ); end
if CONTENT[ACTIONS.MicroShield].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/micro_shield/init.lua" ); end
if CONTENT[ACTIONS.NgonShape].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/ngon_shape/init.lua" ); end
if CONTENT[ACTIONS.OrderDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/order_deck/init.lua" ); end
if CONTENT[ACTIONS.PassiveRecharge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/passive_recharge/init.lua" ); end
if CONTENT[ACTIONS.PathCorrection].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/path_correction/init.lua" ); end
if CONTENT[ACTIONS.PerfectCritical].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/perfect_critical/init.lua" ); end
if CONTENT[ACTIONS.PowerShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/power_shot/init.lua" ); end
if CONTENT[ACTIONS.ProjectileBurst].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_burst/init.lua" ); end
if CONTENT[ACTIONS.ProjectileGravityWell].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/init.lua" ); end
if CONTENT[ACTIONS.ProjectileOrbit].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/init.lua" ); end
if CONTENT[ACTIONS.Revelation].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/revelation/init.lua" ); end
if CONTENT[ACTIONS.ShimmeringTreasure].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/shimmering_treasure/init.lua" ); end
if CONTENT[ACTIONS.ShuffleDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/shuffle_deck/init.lua" ); end
if CONTENT[ACTIONS.SpectralShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/spectral_shot/init.lua" ); end
if CONTENT[ACTIONS.SpellEfficiency].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/spell_efficiency/init.lua" ); end
if CONTENT[ACTIONS.SpellMerge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/init.lua" ); end
if CONTENT[ACTIONS.ArcaneShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_shot/init.lua" ); end
if CONTENT[ACTIONS.SuperBounce].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/init.lua" ); end
if CONTENT[ACTIONS.TriggerHit].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_hit/init.lua" ); end
if CONTENT[ACTIONS.TriggerTimer].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_timer/init.lua" ); end
if CONTENT[ACTIONS.TriggerDeath].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_death/init.lua" ); end
if CONTENT[ACTIONS.TimeSplit].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/time_split/init.lua" ); end
if CONTENT[ACTIONS.FormationStack].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/init.lua" ); end
if CONTENT[ACTIONS.PiercingShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/piercing_shot/init.lua" ); end
if SETTINGS.Debug == true then
    if CONTENT[ACTIONS.WIP].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/actions/wip/init.lua" ); end
    if CONTENT[PERKS.WIP].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/perks/wip/init.lua" ); end
end

--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/action_info.lua" );

ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_actions.lua" );
ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "mods/gkbrkn_noita/files/gkbrkn/misc/tweak_perks.lua" );
ModLuaFileAppend( "data/scripts/biomes/temple_altar.lua", "mods/gkbrkn_noita/files/gkbrkn/append/temple_altar.lua" );

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

function OnModPreInit()
    -- append the logic to parse the old loadouts as new loadouts 
    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn_loadouts/loadouts.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/parse_old_loadouts.lua" );
    -- slap the fully combined set of loadout files onto the end of config so it can be caught by the config menu and performed
    ModLuaFileAppend( "mods/gkbrkn_noita/files/gkbrkn/config.lua", "mods/gkbrkn_noita/files/gkbrkn_loadouts/loadouts.lua" );
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