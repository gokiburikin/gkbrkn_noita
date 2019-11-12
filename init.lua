--[[

changelog
    fix rapid fire extra modifier thanks to newly gained information about extra modifiers
    fix golden blood working on the boss which stopped the end portal from spawning
    fix power shot stopping some projectiles from bouncing
    fix duplicate spell being misnamed causing it to never load
    buff damage plus - bounce (+3 bounces, +25% bounce energy)
    improve less particles, add disable cosmetic particles

kill streaks events
grze events
passives as mini perks
    greed

HitEffect considerations
    ElectricitySourceComponent
    DamageNearbyEntitiesComponent
    WormAttractorComponent

Projectile Mods
    Copy Spell (cast the next spell_
Lucky Favour
    A small chance to evade damage

TODO
    look into what it takes to perform actions with an AbilityComponent

TODO
    deprecate spell efficiency and mana efficiency (perks can stack easily now)
    make proj mods work for enemies (use herd id to find actual enemies)
        path correction
    disable spell wrapping (mostly for testing purposes)
    golden recharge (picking up gold reduces the recharge time on the wand) (passive? perk?)

UTILITY
    TODO
        Spell Power (utility stat on wand stat windows) (not yet possible?)

ACTIONS
    TODO
        Swarm Projectile Modifier (like Spellbundle, but a proper modifier and on enemies)
        Sticky Projectile Modifier (stick to surfaces / enemies) (useful for what kinds of projectiles?)

PERKS
    TODO
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
if HasFlagPersistent("gkbrkn_first_launch") == false then
    AddFlagPersistent("gkbrkn_first_launch")
    for _,option in pairs(OPTIONS) do
        if option.EnabledByDefault == true then
            AddFlagPersistent( option.PersistentFlag );
        end
    end
end
ModLuaFileAppend( "data/scripts/gun/gun.lua", "files/gkbrkn/append_gun.lua" );
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "files/gkbrkn/append_gun_extra_modifiers.lua" );
if PERKS.DuplicateWand.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/duplicate_wand/init.lua" ); end
if PERKS.Enraged.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/enraged/init.lua" ); end
if PERKS.GoldenBlood.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/golden_blood/init.lua" ); end
if PERKS.LivingWand.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/living_wand/init.lua" ); end
if PERKS.LostTreasure.Enabled then
    dofile( "files/gkbrkn/perk_lost_treasure_update.lua");
    ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/lost_treasure/init.lua" );
end
if PERKS.ManaEfficiency.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/mana_efficiency/init.lua" ); end
if PERKS.PassiveRecharge.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/passive_recharge/init.lua" ); end
if PERKS.RapidFire.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/rapid_fire/init.lua" ); end
if PERKS.Resilience.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/resilience/init.lua" ); end
if PERKS.SpellEfficiency.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/spell_efficiency/init.lua" ); end
if PERKS.KnockbackImmunity.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/knockback_immunity/init.lua" ); end
if PERKS.AlwaysCast.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/always_cast/init.lua" ); end
if PERKS.WIP.Enabled then ModLuaFileAppend( "data/scripts/perks/perk_list.lua", "files/gkbrkn/perks/wip/init.lua" ); end

if ACTIONS.BounceDamage.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/bounce_damage/init.lua" ); end
if ACTIONS.BreakCast.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/break_cast/init.lua" ); end
if ACTIONS.Buckshot.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/arcane_buckshot/init.lua" ); end
if ACTIONS.CollisionDetection.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/collision_detection/init.lua" ); end
if ACTIONS.DrawDeck.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/draw_deck/init.lua" ); end
if ACTIONS.DuplicateSpell.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/duplicate_spell/init.lua" ); end
if ACTIONS.ExtraProjectile.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/extra_projectile/init.lua" ); end
if ACTIONS.GoldenBlessing.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/golden_blessing/init.lua" ); end
if ACTIONS.LifetimeDamage.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/lifetime_damage/init.lua" ); end
if ACTIONS.MagicLight.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/magic_light/init.lua" ); end
if ACTIONS.ManaEfficiency.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/mana_efficiency/init.lua" ); end
if ACTIONS.ManaRecharge.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/mana_recharge/init.lua" ); end
if ACTIONS.MicroShield.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/micro_shield/init.lua" ); end
if ACTIONS.NgonShape.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/ngon_shape/init.lua" ); end
if ACTIONS.OrderDeck.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/order_deck/init.lua" ); end
if ACTIONS.PassiveRecharge.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/passive_recharge/init.lua" ); end
if ACTIONS.PathCorrection.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/path_correction/init.lua" ); end
if ACTIONS.PerfectCritical.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/perfect_critical/init.lua" ); end
if ACTIONS.PowerShot.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/power_shot/init.lua" ); end
if ACTIONS.ProjectileBurst.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_burst/init.lua" ); end
if ACTIONS.ProjectileGravityWell.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_gravity_well/init.lua" ); end
if ACTIONS.ProjectileOrbit.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/projectile_orbit/init.lua" ); end
if ACTIONS.Revelation.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/revelation/init.lua" ); end
if ACTIONS.ShimmeringTreasure.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/shimmering_treasure/init.lua" ); end
if ACTIONS.ShuffleDeck.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/shuffle_deck/init.lua" ); end
if ACTIONS.SpectralShot.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spectral_shot/init.lua" ); end
if ACTIONS.SpellEfficiency.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spell_efficiency/init.lua" ); end
if ACTIONS.SpellMerge.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/spell_merge/init.lua" ); end
if ACTIONS.SniperShot.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/arcane_shot/init.lua" ); end
if ACTIONS.WIP.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/wip/init.lua" ); end
if ACTIONS.TriggerHit.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_hit/init.lua" ); end
if ACTIONS.TriggerTimer.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_timer/init.lua" ); end
if ACTIONS.TriggerDeath.Enabled then ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "files/gkbrkn/actions/trigger_death/init.lua" ); end

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