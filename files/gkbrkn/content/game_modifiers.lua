dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua")

local goo_mode_init = function( material )
    local temp_file = [[_spawn_music_trigger = spawn_music_trigger
    function spawn_music_trigger( x, y ) _spawn_music_trigger( x, y ); GameCreateParticle( "]]..material..[[", x+20, y+50, 50, 0, 0, false, false ) end]]
    ModTextFileSetContent( "mods/gkbrkn_noita/files/gkbrkn/scratch/goo_mode.lua", temp_file )
    ModLuaFileAppend( "data/scripts/biomes/temple_altar_left.lua", "mods/gkbrkn_noita/files/gkbrkn/scratch/goo_mode.lua" )
    ModLuaFileAppend( "data/scripts/biomes/temple_altar_left_empty.lua", "mods/gkbrkn_noita/files/gkbrkn/scratch/goo_mode.lua" )
end

game_modifiers = {
    {
        id = FLAGS.GooMode,
        name = "$game_modifier_name_gkbrkn_goo_mode",
        description = "$game_modifier_desc_gkbrkn_goo_mode",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                local x, y = EntityGetTransform( player_entity )
                GameCreateParticle( "creepy_liquid", x - 80, y, 50, 0, 0, false, false )
            end,
            init_callback = function()
                goo_mode_init( "creepy_liquid" )
            end
        }
    },
    {
        id = FLAGS.PolyGooMode,
        name = "$game_modifier_name_gkbrkn_poly_goo_mode",
        description = "$game_modifier_desc_gkbrkn_poly_goo_mode",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                local x, y = EntityGetTransform( player_entity )
                GameCreateParticle( "poly_goo", x - 80, y, 50, 0, 0, false, false )
            end,
            init_callback = function()
                ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/poly_goo.xml" )
                goo_mode_init( "poly_goo" )
            end,
        }
    },
    {
        id = FLAGS.HotGooMode,
        name = "$game_modifier_name_gkbrkn_hot_goo_mode",
        description = "$game_modifier_desc_gkbrkn_hot_goo_mode",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                change_materials_that_damage( player_entity, { hot_goo = 0.003 } )
                local x, y = EntityGetTransform( player_entity )
                GameCreateParticle( "hot_goo", x - 80, y, 50, 0, 0, false, false )
            end,
            init_callback = function()
                ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/hot_goo.xml" )
                goo_mode_init( "hot_goo" )
            end,
        }
    },
    {
        id = FLAGS.KillerGooMode,
        name = "$game_modifier_name_gkbrkn_killer_goo_mode",
        description = "$game_modifier_desc_gkbrkn_killer_goo_mode",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                change_materials_that_damage( player_entity, { killer_goo = 0.01, corruption = 0.001 } )
                local x, y = EntityGetTransform( player_entity )
                GameCreateParticle( "killer_goo", x - 80, y, 50, 0, 0, false, false )
            end,
            init_callback = function()
                ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/killer_goo.xml" )
                goo_mode_init( "killer_goo" )
            end,
        }
    },
    {
        id = FLAGS.AltKillerGooMode,
        name = "$game_modifier_name_gkbrkn_alt_killer_goo_mode",
        description = "$game_modifier_desc_gkbrkn_alt_killer_goo_mode",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                change_materials_that_damage( player_entity, { alt_killer_goo = 0.01, alt_corruption = 0.001 } )
                local x, y = EntityGetTransform( player_entity )
                GameCreateParticle( "alt_killer_goo", x - 80, y, 50, 0, 0, false, false )
            end,
            init_callback = function()
                ModMaterialsFileAdd( "mods/gkbrkn_noita/files/gkbrkn/materials/alt_killer_goo.xml" )
                goo_mode_init( "alt_killer_goo" )
            end,
        }
    },
    {
        id = FLAGS.PlayerTakesPhysicsDamage,
        name = "$game_modifier_name_gkbrkn_player_takes_physics_damage",
        description = "$game_modifier_desc_gkbrkn_player_takes_physics_damage",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                local damage_model_comp = EntityGetFirstComponentIncludingDisabled(player_entity, "DamageModelComponent")
                if damage_model_comp then ComponentSetValue2(damage_model_comp, "physics_objects_damage", true) end
            end,
        },
        tags = {carnage = true}
    },
    {
        id = FLAGS.LimitedMana,
        name = "$game_modifier_name_gkbrkn_limited_mana",
        description = "$game_modifier_desc_gkbrkn_limited_mana",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.LimitedMana } }
    },
    {
        id = FLAGS.RemoveGenericWands,
        name = "$game_modifier_name_gkbrkn_remove_generic_wands",
        description = "$game_modifier_desc_gkbrkn_remove_generic_wands",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.RemoveGenericWands } }
    },
    {
        id = FLAGS.NoWandEditing,
        name = "$game_modifier_name_gkbrkn_no_edit",
        description = "$game_modifier_desc_gkbrkn_no_edit",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.NoWandEditing } }
    },
    {
        id = FLAGS.LimitedAmmo,
        name = "$game_modifier_name_gkbrkn_limited_ammo",
        description = "$game_modifier_desc_gkbrkn_limited_ammo",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.LimitedAmmo } }
    },
    {
        id = FLAGS.UnlimitedAmmo,
        name = "$game_modifier_name_gkbrkn_unlimited_ammo",
        description = "$game_modifier_desc_gkbrkn_unlimited_ammo",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.UnlimitedAmmo } }
    },
    {
        id = FLAGS.NoHit,
        name = "$game_modifier_name_gkbrkn_no_hit",
        description = "$game_modifier_desc_gkbrkn_no_hit",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                EntityAddComponent( player_entity, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/no_hit/player_damage_received.lua"
                })
            end,
            run_flags = { FLAGS.NoHit }
        }
    },
    {
        id = FLAGS.OrderWandsOnly,
        name = "$game_modifier_name_gkbrkn_order_wands_only",
        description = "$game_modifier_desc_gkbrkn_order_wands_only",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.OrderWandsOnly } }
    },
    {
        id = FLAGS.ShuffleWandsOnly,
        name = "$game_modifier_name_gkbrkn_shuffle_wands_only",
        description = "$game_modifier_desc_gkbrkn_shuffle_wands_only",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.ShuffleWandsOnly } }
    },
    {
        id = FLAGS.GuaranteedAlwaysCast,
        name = "$game_modifier_name_gkbrkn_guaranteed_always_cast",
        description = "$game_modifier_desc_gkbrkn_guaranteed_always_cast",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.GuaranteedAlwaysCast } }
    },
    {
        id = FLAGS.SpellShopsOnly,
        name = "$game_modifier_name_gkbrkn_spell_shops_only",
        description = "$game_modifier_desc_gkbrkn_spell_shops_only",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.SpellShopsOnly } }
    },
    {
        id = FLAGS.WandShopsOnly,
        name = "$game_modifier_name_gkbrkn_wand_shops_only",
        description = "$game_modifier_desc_gkbrkn_wand_shops_only",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.WandShopsOnly } },
    },
    {
        id = FLAGS.FreeShops,
        name = "$game_modifier_name_gkbrkn_free_shops",
        description = "$game_modifier_desc_gkbrkn_free_shops",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.FreeShops } }
    },
    {
        id = FLAGS.FloorIsLava,
        name = "$game_modifier_name_gkbrkn_floor_is_lava",
        description = "$game_modifier_desc_gkbrkn_floor_is_lava",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.FloorIsLava } }
    },
    {
        id = FLAGS.KeepMoving,
        name = "$game_modifier_name_gkbrkn_keep_moving",
        description = "$game_modifier_desc_gkbrkn_keep_moving",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.KeepMoving } }
    },
    {
        id = FLAGS.KickSpellsOffWands,
        name = "$game_modifier_name_gkbrkn_kick_spells_off_wands",
        description = "$game_modifier_desc_gkbrkn_kick_spells_off_wands",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.KickSpellsOffWands } },
    },
    {
        id = FLAGS.KickSpellsAround,
        name = "$game_modifier_name_gkbrkn_kick_spells_around",
        description = "$game_modifier_desc_gkbrkn_kick_spells_around",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.KickSpellsAround } },
        default = true,
    },
    {
        id = FLAGS.EnemyInvincibilityFrames,
        name = "$game_modifier_name_gkbrkn_enemy_invincibility_frames",
        description = "$game_modifier_desc_gkbrkn_enemy_invincibility_frames",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.EnemyInvincibilityFrames } }
    },
    {
        id = FLAGS.EnemyIntangibilityFrames,
        name = "$game_modifier_name_gkbrkn_enemy_intangibility_frames",
        description = "$game_modifier_desc_gkbrkn_enemy_intangibility_frames",
        author = "goki_dev",
        local_content = true,
        options = { run_flags = { FLAGS.EnemyIntangibilityFrames } },
    },
    {
        id = FLAGS.AngryGods,
        name = "$game_modifier_name_gkbrkn_angry_gods",
        description = "$game_modifier_desc_gkbrkn_angry_gods",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" )
            end,
            run_flags = { FLAGS.AngryGods }
        }
    },
    {
        id = "no_hit_lite",
        name = "$game_modifier_name_gkbrkn_no_hit_lite",
        description = "$game_modifier_desc_gkbrkn_no_hit_lite",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( player_entity )
                EntityAddComponent( player_entity, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/teleport_on_hit.lua"
                } )
            end,
            run_flags = { FLAGS.HitsTeleportToLastHolyMountain }
        }
    },
    {
        id = "darkness",
        name = "$game_modifier_name_gkbrkn_darkness",
        description = "$game_modifier_desc_gkbrkn_darkness",
        author = "goki_dev",
        local_content = true,
        options = {
            world_post_init_callback = function()
                local biomes = {
                    "coalmine",
                    "mountain_hall",
                    "coalmine_alt",
                    "excavationsite",
                    "fungicave",
                    "snowcave",
                    "snowcastle",
                    "rainforest",
                    "rainforest_open",
                    "vault",
                    "crypt",
                }
                for _,biome_name in pairs( biomes ) do
                    BiomeObjectSetValue( "data/biome/" .. biome_name .. ".xml", "modifiers", "fog_of_war_delta", 10 )
                end
            end
        }
    },
    {
        id = "cursed_rock",
        name = "$game_modifier_name_gkbrkn_cursed_rock",
        description = "$game_modifier_desc_gkbrkn_cursed_rock",
        author = "goki_dev",
        local_content = true,
        tags = {carnage = true},
        options = {
            world_post_init_callback = function()
                ConvertMaterialEverywhere( CellFactory_GetType( "rock_hard_border" ), CellFactory_GetType( "rock_static_cursed" ) )
            end
        }
    },
    {
        id = FLAGS.WandstoneStart,
        name = "$game_modifier_name_gkbrkn_wandstone_start",
        description = "$game_modifier_desc_gkbrkn_wandstone_start",
        author = "goki_dev",
        local_content = true,
        options = {
            player_spawned_callback = function( e )
                local x, y = EntityGetTransform( e )
                local inventory_quick = nil
                for _,c in pairs(EntityGetAllChildren(e)) do
                    if EntityGetName(c) == "inventory_quick" then
                        inventory_quick = c
                        break
                    end
                end
                EntityAddChild( inventory_quick, EntityLoad("data/entities/items/pickup/wandstone.xml"))
            end
        }
    },
    {
        id = FLAGS.DiviniumStart,
        name = "$game_modifier_name_gkbrkn_divinium_start",
        description = "$game_modifier_desc_gkbrkn_divinium_start",
        author = "goki_dev",
        local_content = true,
        tags = {carnage = true},
        options = {
            player_spawned_callback = function( e )
                local x, y = EntityGetTransform( e )
                local inventory_quick = nil
                for _,c in pairs(EntityGetAllChildren(e)) do
                    if EntityGetName(c) == "inventory_quick" then
                        inventory_quick = c
                        break
                    end
                end
                local potion = EntityLoad( "data/entities/items/pickup/potion.xml", x, y )
                RemoveMaterialInventoryMaterial( potion )
                AddMaterialInventoryMaterial( potion, "gkbrkn_edit_wands", 1000 )
                EntityAddChild( inventory_quick, potion )
            end
        }
    },
    {
        -- Uses Persistent Flags
        id = "disable_random_spells",
        name = "$game_modifier_name_gkbrkn_disable_random_spells",
        description = "$game_modifier_desc_gkbrkn_disable_random_spells",
        author = "goki_dev",
        local_content = true,
    }
}