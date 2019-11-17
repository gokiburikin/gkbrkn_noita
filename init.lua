--[[
api issues
    no event callback hook registration whatver for certain important actions
        the biggest nice to haves:
            entity created / loaded
            projectile fired from wand
            
    no overriding of base game events in a modular interpoable way (currently have to overwrite or keep custom code up to date
        with every change)
    

changelog
    add missing credit
    rename gravity well to projectile gravity well
    reduce range of projectile gravity well
    fix some negligible issues with max health recovery
    add healthier heart
    add invincibility frames (perk)
    add mana recovery (perk)
    fix resilience

kill streaks events
grze events
passives as mini perks
    greed

HitEffect considerations
    ElectricitySourceComponent
    DamageNearbyEntitiesComponent
    WormAttractorComponent

TODO
    look into what it takes to perform actions with an AbilityComponent
    add a disable cosmetic particles blacklist for certain entities (might not be possible)
    deprecate spell efficiency and mana efficiency (perks can stack easily now)
    make proj mods work for enemies (use herd id to find shooter enemies) (probably won't work until they fix the herd component issue)
        path correction
    golden recharge (picking up gold reduces the recharge time on the wand) (passive? perk?)
    spell drop chance (drop money override, a chance to drop a spell of equal value)
    shot that targets another enemy in line of sight when killing 
        this could be emulated just as well by using trigger on death and an alt path correction that searches for a target upon spawning
    modifier that applies the next modifier to all projectiles in the wand
    make enemies imperfect / take time to aim towards you

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
        True Spell Merge (combine the properties of all projectiles fired in the cast)
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

dofile( "files/gkbrkn/helper.lua");
dofile( "files/gkbrkn/config.lua");
dofile( "files/gkbrkn/lib/variables.lua");
dofile( "data/scripts/lib/utilities.lua");
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
ModLuaFileAppend( "data/scripts/gun/gun.lua", "files/gkbrkn/append_gun.lua" );
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "files/gkbrkn/append_gun_extra_modifiers.lua" );

if CONTENT[PERKS.DuplicateWand].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/duplicate_wand/init.lua" ); end
if CONTENT[PERKS.Enraged].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/enraged/init.lua" ); end
if CONTENT[PERKS.GoldenBlood].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/golden_blood/init.lua" ); end
if CONTENT[PERKS.LivingWand].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/living_wand/init.lua" ); end
if CONTENT[PERKS.LostTreasure].enabled() then dofile( "files/gkbrkn/perk_lost_treasure_update.lua"); ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/lost_treasure/init.lua" ); end
if CONTENT[PERKS.ManaEfficiency].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/mana_efficiency/init.lua" ); end
if CONTENT[PERKS.ManaRecovery].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/mana_recovery/init.lua" ); end
if CONTENT[PERKS.MaterialCompression].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/material_compression/init.lua" ); end
if CONTENT[PERKS.PassiveRecharge].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/passive_recharge/init.lua" ); end
if CONTENT[PERKS.RapidFire].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/rapid_fire/init.lua" ); end
if CONTENT[PERKS.Resilience].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/resilience/init.lua" ); end
if CONTENT[PERKS.SpellEfficiency].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/spell_efficiency/init.lua" ); end
if CONTENT[PERKS.KnockbackImmunity].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/knockback_immunity/init.lua" ); end
if CONTENT[PERKS.AlwaysCast].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/always_cast/init.lua" ); end
if CONTENT[PERKS.HealthierHeart].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/healthier_heart/init.lua" ); end
if CONTENT[PERKS.InvincibilityFrames].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/invincibility_frames/init.lua" ); end
if CONTENT[PERKS.ExtraProjectile].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/extra_projectile/init.lua" ); end

if CONTENT[ACTIONS.BounceDamage].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/bounce_damage/init.lua" ); end
if CONTENT[ACTIONS.BreakCast].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/break_cast/init.lua" ); end
if CONTENT[ACTIONS.ArcaneBuckshot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/arcane_buckshot/init.lua" ); end
if CONTENT[ACTIONS.CollisionDetection].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/collision_detection/init.lua" ); end
if CONTENT[ACTIONS.CopySpell].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/copy_spell/init.lua" ); end
if CONTENT[ACTIONS.DrawDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/draw_deck/init.lua" ); end
if CONTENT[ACTIONS.DoubleCast].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/double_cast/init.lua" ); end
if CONTENT[ACTIONS.ExtraProjectile].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/extra_projectile/init.lua" ); end
if CONTENT[ACTIONS.GoldenBlessing].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/golden_blessing/init.lua" ); end
if CONTENT[ACTIONS.LifetimeDamage].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/lifetime_damage/init.lua" ); end
if CONTENT[ACTIONS.MagicLight].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/magic_light/init.lua" ); end
if CONTENT[ACTIONS.ManaEfficiency].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/mana_efficiency/init.lua" ); end
if CONTENT[ACTIONS.ManaRecharge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/mana_recharge/init.lua" ); end
if CONTENT[ACTIONS.ModificationField].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/modification_field/init.lua" ); end
if CONTENT[ACTIONS.MicroShield].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/micro_shield/init.lua" ); end
if CONTENT[ACTIONS.NgonShape].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/ngon_shape/init.lua" ); end
if CONTENT[ACTIONS.OrderDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/order_deck/init.lua" ); end
if CONTENT[ACTIONS.PassiveRecharge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/passive_recharge/init.lua" ); end
if CONTENT[ACTIONS.PathCorrection].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/path_correction/init.lua" ); end
if CONTENT[ACTIONS.PerfectCritical].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/perfect_critical/init.lua" ); end
if CONTENT[ACTIONS.PowerShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/power_shot/init.lua" ); end
if CONTENT[ACTIONS.ProjectileBurst].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_burst/init.lua" ); end
if CONTENT[ACTIONS.ProjectileEqualization].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_equalization/init.lua" ); end
if CONTENT[ACTIONS.ProjectileGravityWell].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_gravity_well/init.lua" ); end
if CONTENT[ACTIONS.ProjectileOrbit].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_orbit/init.lua" ); end
if CONTENT[ACTIONS.Revelation].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/revelation/init.lua" ); end
if CONTENT[ACTIONS.ShimmeringTreasure].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/shimmering_treasure/init.lua" ); end
if CONTENT[ACTIONS.ShuffleDeck].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/shuffle_deck/init.lua" ); end
if CONTENT[ACTIONS.SpectralShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spectral_shot/init.lua" ); end
if CONTENT[ACTIONS.SpellEfficiency].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spell_efficiency/init.lua" ); end
if CONTENT[ACTIONS.SpellMerge].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spell_merge/init.lua" ); end
if CONTENT[ACTIONS.ArcaneShot].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/arcane_shot/init.lua" ); end
if CONTENT[ACTIONS.SuperBounce].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/super_bounce/init.lua" ); end
if CONTENT[ACTIONS.TriggerHit].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_hit/init.lua" ); end
if CONTENT[ACTIONS.TriggerTimer].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_timer/init.lua" ); end
if CONTENT[ACTIONS.TriggerDeath].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_death/init.lua" ); end

if SETTINGS.Debug == true then
    if CONTENT[ACTIONS.WIP].enabled() then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/wip/init.lua" ); end
    if CONTENT[PERKS.WIP].enabled() then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/wip/init.lua" ); end
end

if MISC.CharmNerf.Enabled then ModLuaFileAppend( "data/scripts/items/drop_money.lua", "files/gkbrkn/misc/charm_nerf.lua" ); end

if HasFlagPersistent( MISC.TweakSpells.Enabled ) then
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/misc/tweak_spells.lua" );
end

if HasFlagPersistent( MISC.LooseSpellGeneration.Enabled ) then
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/misc/loose_spell_generation.lua" );
end

if HasFlagPersistent( MISC.LimitedAmmo.Enabled ) then
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/misc/limited_ammo.lua" );
end

if HasFlagPersistent( MISC.WandShopsOnly.Enabled ) then
    ModLuaFileAppend( "data/scripts/items/generate_shop_item.lua", "files/gkbrkn/misc/wand_shops_only.lua" );
end

if HasFlagPersistent( MISC.DisableSpells.Enabled ) then
    ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/misc/disable_spells.lua" );
end


function OnModPreInit()
    RemoveFlagPersistent("gkbrkn_loose_spell_generation_init");
    RemoveFlagPersistent("gkbrkn_tweak_spells_init");
    RemoveFlagPersistent("gkbrkn_upgraded_spells_init");
end

function OnPlayerSpawned( player_entity )
    DoFileEnvironment( "files/gkbrkn/player_spawned.lua", { player_entity = player_entity } );
end

function OnWorldPostUpdate()
    DoFileEnvironment( "files/gkbrkn/world_post_update.lua" );
end

--[[
function OnWorldInitialized()
end

function OnModPostInit()
end

]]