dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
local memoize_game_modifiers = {};
function find_game_modifier( id )
    local game_modifier = nil;
    if memoize_game_modifiers[id] then
        game_modifier = memoize_game_modifiers[id];
    else
        for _,entry in pairs(game_modifiers) do
            if entry.id == id then
                game_modifier = entry;
                memoize_game_modifiers[id] = entry;
            end
        end
    end
    return game_modifier;
end

game_modifiers = {
    {
        id = "goo_mode",
        name = "$game_modifier_name_gkbrkn_goo_mode",
        description = "$game_modifier_desc_gkbrkn_goo_mode",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                dofile_once( "data/scripts/perks/perk.lua" );
                local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
                local x, y = EntityGetTransform( player_entity );
                GameCreateParticle( "creepy_liquid", x - 50, y, 5, 0, 0, false, false );
            end,
            run_flags = { FLAGS.GooMode }
        }
    },
    {
        id = "poly_goo_mode",
        name = "$game_modifier_name_gkbrkn_poly_goo_mode",
        description = "$game_modifier_desc_gkbrkn_poly_goo_mode",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
                local x, y = EntityGetTransform( player_entity );
                GameCreateParticle( "poly_goo", x - 50, y, 5, 0, 0, false, false );
            end,
            run_flags = { FLAGS.PolyGooMode }
        }
    },
    {
        id = "hot_goo_mode",
        name = "$game_modifier_name_gkbrkn_hot_goo_mode",
        description = "$game_modifier_desc_gkbrkn_hot_goo_mode",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end

                local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
                for _,damage_model in pairs( damage_models ) do
                    adjust_material_damage( damage_model, function( materials, damage )
                        table.insert( materials, "hot_goo");
                        table.insert( damage, "0.003");
                        return materials, damage;
                    end);
                    EntitySetComponentIsEnabled( player_entity, damage_model, true );
                    local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                    ComponentSetValue( polymorph, "frames", 1 );
                end

                local x, y = EntityGetTransform( player_entity );
                GameCreateParticle( "hot_goo", x - 50, y, 5, 0, 0, false, false );
            end,
            run_flags = { FLAGS.HotGooMode }
        }
    },
    {
        id = "killer_goo_mode",
        name = "$game_modifier_name_gkbrkn_killer_goo_mode",
        description = "$game_modifier_desc_gkbrkn_killer_goo_mode",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
                local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
                for _,damage_model in pairs( damage_models ) do
                    adjust_material_damage( damage_model, function( materials, damage )
                        table.insert( materials, "killer_goo");
                        table.insert( damage, "0.001");
                        table.insert( materials, "corruption");
                        table.insert( damage, "0.001");
                        return materials, damage;
                    end);
                    EntitySetComponentIsEnabled( player_entity, damage_model, true );
                    local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                    ComponentSetValue( polymorph, "frames", 1 );
                end

                local x, y = EntityGetTransform( player_entity );
                GameCreateParticle( "killer_goo", x - 50, y, 5, 0, 0, false, false );
            end,
            run_flags = { FLAGS.KillerGooMode }
        }
    },
    {
        id = "alt_killer_goo_mode",
        name = "$game_modifier_name_gkbrkn_alt_killer_goo_mode",
        description = "$game_modifier_desc_gkbrkn_alt_killer_goo_mode",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                local perk_entity = perk_spawn( x, y, "REMOVE_FOG_OF_WAR" );
                if perk_entity ~= nil then
                    perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
                end
                local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
                for _,damage_model in pairs( damage_models ) do
                    adjust_material_damage( damage_model, function( materials, damage )
                        table.insert( materials, "alt_killer_goo");
                        table.insert( damage, "0.001");
                        table.insert( materials, "alt_corruption");
                        table.insert( damage, "0.001");
                        return materials, damage;
                    end);
                    EntitySetComponentIsEnabled( player_entity, damage_model, true );
                    local polymorph = GetGameEffectLoadTo( player_entity, "POLYMORPH", true )
                    ComponentSetValue( polymorph, "frames", 1 );
                end

                local x, y = EntityGetTransform( player_entity );
                GameCreateParticle( "alt_killer_goo", x - 50, y, 5, 0, 0, false, false );
            end,
            run_flags = { FLAGS.AltKillerGooMode }
        }
    },
    {
        id = "limited_mana",
        name = "$game_modifier_name_gkbrkn_limited_mana",
        description = "$game_modifier_desc_gkbrkn_limited_mana",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.LimitedMana } }
    },
    {
        id = "remove_generic_wands",
        name = "$game_modifier_name_gkbrkn_remove_generic_wands",
        description = "$game_modifier_desc_gkbrkn_remove_generic_wands",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.RemoveGenericWands } }
    },
    {
        id = "no_edit",
        name = "$game_modifier_name_gkbrkn_no_edit",
        description = "$game_modifier_desc_gkbrkn_no_edit",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.NoWandEditing } }
    },
    {
        id = "limited_ammo",
        name = "$game_modifier_name_gkbrkn_limited_ammo",
        description = "$game_modifier_desc_gkbrkn_limited_ammo",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.LimitedAmmo } }
    },
    {
        id = "unlimited_ammo",
        name = "$game_modifier_name_gkbrkn_unlimited_ammo",
        description = "$game_modifier_desc_gkbrkn_unlimited_ammo",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.UnlimitedAmmo } }
    },
    {
        id = "no_hit",
        name = "$game_modifier_name_gkbrkn_no_hit",
        description = "$game_modifier_desc_gkbrkn_no_hit",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                EntityAddComponent( player_entity, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/no_hit/player_damage_received.lua"
                });
            end,
            run_flags = { FLAGS.NoHit }
        }
    },
    {
        id = "order_wands_only",
        name = "$game_modifier_name_gkbrkn_order_wands_only",
        description = "$game_modifier_desc_gkbrkn_order_wands_only",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.OrderWandsOnly } }
    },
    {
        id = "shuffle_wands_only",
        name = "$game_modifier_name_gkbrkn_shuffle_wands_only",
        description = "$game_modifier_desc_gkbrkn_shuffle_wands_only",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.ShuffleWandsOnly } }
    },
    {
        id = "guaranteed_always_cast",
        name = "$game_modifier_name_gkbrkn_guaranteed_always_cast",
        description = "$game_modifier_desc_gkbrkn_guaranteed_always_cast",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.GuaranteedAlwaysCast } }
    },
    {
        id = "spell_shops_only",
        name = "$game_modifier_name_gkbrkn_spell_shops_only",
        description = "$game_modifier_desc_gkbrkn_spell_shops_only",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.SpellShopsOnly } }
    },
    {
        id = "wand_shops_only",
        name = "$game_modifier_name_gkbrkn_wand_shops_only",
        description = "$game_modifier_desc_gkbrkn_wand_shops_only",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.WandShopsOnly } },
        tags = {goki_thing = true}
    },
    {
        id = "free_shops",
        name = "$game_modifier_name_gkbrkn_free_shops",
        description = "$game_modifier_desc_gkbrkn_free_shops",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.FreeShops } }
    },
    {
        id = "rebalance_shops",
        name = "$game_modifier_name_gkbrkn_rebalance_shops",
        description = "$game_modifier_desc_gkbrkn_rebalance_shops",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.RebalanceShops } },
        tags = {goki_thing = true}
    },
    {
        id = "floor_is_lava",
        name = "$game_modifier_name_gkbrkn_floor_is_lava",
        description = "$game_modifier_desc_gkbrkn_floor_is_lava",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.FloorIsLava } }
    },
    {
        id = "infinite_flight",
        name = "$game_modifier_name_gkbrkn_infinite_flight",
        description = "$game_modifier_desc_gkbrkn_infinite_flight",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.InfiniteFlight } }
    },
    {
        id = "disintegrate_corpses",
        name = "$game_modifier_name_gkbrkn_disintegrate_corpses",
        description = "$game_modifier_desc_gkbrkn_disintegrate_corpses",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.DisintegrateCorpses } }
    },
    {
        id = "keep_moving",
        name = "$game_modifier_name_gkbrkn_keep_moving",
        description = "$game_modifier_desc_gkbrkn_keep_moving",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.KeepMoving } }
    },
    {
        id = "kick_spells_off_wands",
        name = "$game_modifier_name_gkbrkn_kick_spells_off_wands",
        description = "$game_modifier_desc_gkbrkn_kick_spells_off_wands",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.KickSpellsOffWands } },
        tags = {goki_thing = true}
    },
    {
        id = "kick_spells_around",
        name = "$game_modifier_name_gkbrkn_kick_spells_around",
        description = "$game_modifier_desc_gkbrkn_kick_spells_around",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.KickSpellsAround } },
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "enemy_invincibility_frames",
        name = "$game_modifier_name_gkbrkn_enemy_invincibility_frames",
        description = "$game_modifier_desc_gkbrkn_enemy_invincibility_frames",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.EnemyInvincibilityFrames } }
    },
    {
        id = "enemy_intangibility_frames",
        name = "$game_modifier_name_gkbrkn_enemy_intangibility_frames",
        description = "$game_modifier_desc_gkbrkn_enemy_intangibility_frames",
        author = "$ui_author_name_goki_dev",
        options = { run_flags = { FLAGS.EnemyIntangibilityFrames } },
        tags = {goki_thing = true}
    },
    {
        id = "angry_gods",
        name = "$game_modifier_name_gkbrkn_angry_gods",
        description = "$game_modifier_desc_gkbrkn_angry_gods",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "1" );
            end,
            run_flags = { FLAGS.AngryGods }
        }
    },
    {
        id = "no_hit_lite",
        name = "$game_modifier_name_gkbrkn_no_hit_lite",
        description = "$game_modifier_desc_gkbrkn_no_hit_lite",
        author = "$ui_author_name_goki_dev",
        options = {
            player_spawned_callback = function( player_entity )
                EntityAddComponent( player_entity, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/teleport_on_hit.lua"
                } );
            end,
            run_flags = { FLAGS.HitsTeleportToLastHolyMountain }
        }
    },
    {
        -- Uses Persistent Flags
        id = "disable_random_spells",
        name = "$game_modifier_name_gkbrkn_disable_random_spells",
        description = "$game_modifier_desc_gkbrkn_disable_random_spells",
        author = "$ui_author_name_goki_dev",
    },
    {
        -- Uses Persistent Flags
        id = "generate_random_spellbooks",
        name = "$game_modifier_name_gkbrkn_generate_random_spellbooks",
        description = "$game_modifier_desc_gkbrkn_generate_random_spellbooks",
        author = "$ui_author_name_goki_dev",
        tags = {goki_thing = true}
    }
}