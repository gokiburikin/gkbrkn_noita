local options = {
    GoldPickupTracker = {
        TrackDuration = 180, -- in game frames
        ShowMessageFlag = "gkbrkn_gold_tracking_message",
        ShowTrackerFlag = "gkbrkn_gold_tracking_in_world",
    },
    --CharmNerf = {
    --    Enabled = "gkbrkn_charm_nerf",
    --},
    InvincibilityFrames = {
        Duration = "gkbrkn_invincibility_frames_duration",
        EnabledFlag = "gkbrkn_invincibility_frames",
        FlashingFlag = "gkbrkn_invincibility_frames_flashing",
    },
    HealOnMaxHealthUp = {
        EnabledFlag = "gkbrkn_max_health_heal",
        FullHealFlag = "gkbrkn_max_health_heal_full",
    },
    LooseSpellGeneration = { EnabledFlag = "gkbrkn_loose_spell_generation", },
    ChampionEnemies = {
        EnabledFlag = "gkbrkn_champion_enemies",
        SuperChampionsFlag = "gkbrkn_champion_enemies_super",
        AlwaysChampionsFlag = "gkbrkn_champion_enemies_always",
        MiniBossesFlag = "gkbrkn_champion_enemies_mini_bosses",
        ValourFlag = "gkbrkn_champion_enemies_valour",
        ShowIconsFlag = "gkbrkn_champion_enemies_show_icons",
        ChampionChance = 0.20,
        MiniBossChance = 0.10, -- rolled after champion chance only if mini boss kill threshold has been met
        MiniBossThreshold = 50, -- the amount of enemies that must be killed before a miniboss can spawn
        ExtraTypeChance = 0.05,
        ValourBonus = 3,
    },
    QuickSwap = { EnabledFlag = "gkbrkn_quick_swap", },
    LessParticles = {
        PlayerProjectilesFlag = "gkbrkn_less_particles_player",
        OtherStuffFlag = "gkbrkn_less_particles_other_stuff",
        DisableCosmeticsFlag = "gkbrkn_less_particles_disable_cosmetic"
    },
    RainbowProjectiles = { EnabledFlag = "gkbrkn_rainbow_projectiles" },
    RandomStart = {
        RandomWandsFlag = "gkbrkn_random_start_random_wands",
        RandomPrimaryWandFlag = "gkbrkn_random_start_primary_wand",
        RandomSecondaryWandFlag = "gkbrkn_random_start_secondary_wand",
        RandomExtraWandFlag = "gkbrkn_random_start_extra_wand",
        RandomHealthFlag = "gkbrkn_random_start_random_health",
        MinimumHP = 50,
        MaximumHP = 150,
        CustomWandGenerationFlag = "gkbrkn_random_start_custom_wands",
        RandomCapeColorFlag = "gkbrkn_random_start_random_cape",
        RandomFlaskFlag = "gkbrkn_random_start_random_flask",
        RandomPerkFlag = "gkbrkn_random_start_random_perk",
        RandomPerksFlag = "gkbrkn_random_start_random_perks",
    },
    LegendaryWands = {
        EnabledFlag = "gkbrkn_legendary_wands",
        SpawnWeighting = 0.03,
    },
    ExtendedWandGeneration = { EnabledFlag = "gkbrkn_extended_wand_generation", },
    ChaoticWandGeneration = { EnabledFlag = "gkbrkn_chaotic_wand_generation", },
    AlternativeWandGeneration = { EnabledFlag = "gkbrkn_alternative_wand_generation", },
    ShowFPS = { EnabledFlag = "gkbrkn_show_fps", },
    HealthBars = {
        EnabledFlag = "gkbrkn_health_bars",
        PrettyHealthBarsFlag = "gkbrkn_health_bars_pretty",
    },
    PackShops = {
        EnabledFlag = "gkbrkn_pack_shops",
        RandomCardsPerPack = 1,
        CardsPerPack = 4,
    },
    GoldDecay = { EnabledFlag = "gkbrkn_gold_decay",},
    GoldLifetime = { EnabledFlag = "gkbrkn_gold_lifetime_multiplier", },
    PersistentGold = { EnabledFlag = "gkbrkn_persistent_gold", },
    AutoPickupGold = { EnabledFlag = "gkbrkn_auto_pickup_gold", },
    CombineGold = {
        EnabledFlag = "gkbrkn_combine_gold",
        Radius = 48,
    },
    PassiveRecharge = {
        EnabledFlag = "gkbrkn_passive_recharge",
        Speed = 1
    },
    TargetDummy = {
        EnabledFlag = "gkbrkn_target_dummy",
        AllowEnvironmentalDamage = "gkbrkn_target_dummy_environmental"
    },
    SlotMachine = { EnabledFlag = "gkbrkn_slot_machine", },
    ShopReroll = { EnabledFlag = "gkbrkn_shop_reroll", },
    Loadouts = {
        ManageFlag = "gkbrkn_loadouts_manage",
        EnabledFlag = "gkbrkn_loadouts_enabled",
        UnlockLoadouts = "gkbrkn_unlock_loadouts",
        CapeColorFlag = "gkbrkn_loadouts_cape_color",
        PlayerSpritesFlag = "gkbrkn_loadouts_player_sprites",
        ClassyFrameworkIntegrationFlag = "gkbrkn_classy_framework_integration",
        SelectableClassesIntegrationFlag = "gkbrkn_selectable_classes_integration",
    },
    HeroMode = {
        EnabledFlag = "gkbrkn_hero_mode",
        OrbsDifficultyFlag = "gkbrkn_hero_mode_orb_scale",
        DistanceDifficultyFlag = "gkbrkn_hero_mode_distance_scale",
        CarnageDifficultyFlag = "gkbrkn_hero_mode_carnage",
    },
    NoPregenWands = { EnabledFlag = "gkbrkn_no_pregen_wands", },
    ChestsContainPerks = {
        EnabledFlag = "gkbrkn_chests_contain_perks",
        Chance=0.12,
        SuperChance=0.25,
        RemovePerkTag=false, -- this makes it so that picking up other perks doesn't kill this perk. might have side effects!!!
        DontKillOtherPerks=true,
    },
    ManageExternalContent = { EnabledFlag = "gkbrkn_manage_external_content", },
    ShowModTips = {
        EnabledFlag = "gkbrkn_mod_tips",
        Tips = {
            "$mod_tips_gkbrkn_tip_1",
            "$mod_tips_gkbrkn_tip_2",
            "$mod_tips_gkbrkn_tip_3",
            "$mod_tips_gkbrkn_tip_4",
            "$mod_tips_gkbrkn_tip_5",
            "$mod_tips_gkbrkn_tip_6",
            "$mod_tips_gkbrkn_tip_7",
            "$mod_tips_gkbrkn_tip_8",
            "$mod_tips_gkbrkn_tip_9",
            "$mod_tips_gkbrkn_tip_10",
        }
    },
    Badges = { EnabledFlag = "gkbrkn_show_badges", },
    ShowEntityNames = { EnabledFlag = "gkbrkn_show_entity_names", },
    ShowPerkDescriptions = { EnabledFlag = "gkbrkn_show_perk_descriptions", },
    ShowDamageNumbers = { EnabledFlag = "gkbrkn_show_damage_numbers", },
    FixedCamera = { EnabledFlag = "gkbrkn_fixed_camera", OldBehaviourFlag = "gkbrkn_fixed_camera_old" },
    Events = { EnabledFlag = "gkbrkn_events", },
    AutoHide = { EnabledFlag = "gkbrkn_auto_hide", },
    RemoveEditPrompt = { EnabledFlag = "gkbrkn_remove_edit_prompt", },
    PerkOptions = {
        MagicFocus = {
            DecayFrames = 60,
            ChargeFrames = 240,
        },
        BloodMagic = {
            BloodToManaRatio = 1,
            FreeAlwaysCasts = true,
            DamageMultiplier = 5,
        },
        Resilience = { 
            Resistances = {
                fire=0.33,
                radioactive=0.33,
                poison=0.33,
                electricity=0.33,
            }
        },
        ManaEfficiency = {
            Discount = 0.33
        },
        SpellEfficiency = {
            RetainChance = 0.33
        },
        LivingWand = {
            TeleportDistance = 128
        }
    },
    TweakOptions = {
        BloodAmountMultiplier = 0.98
    }
}
--# intercept this line
return options