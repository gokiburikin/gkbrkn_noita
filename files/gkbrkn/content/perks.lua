dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once("data/scripts/gun/procedural/gun_procedural.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua");


table.insert( perk_list,
    generate_perk_entry( "GKBRKN_BLOOD_MAGIC", "blood_magic", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_blood_magic_stacks", 0.0, function( value ) return value + 1.0; end );
        local damage_multiplier = 5;
        local adjustments = {
            ice = damage_multiplier,
            electricity = damage_multiplier,
            radioactive = damage_multiplier,
            slice = damage_multiplier,
            projectile = damage_multiplier,
            --healing = damage_multiplier,
            physics_hit = damage_multiplier,
            explosion = damage_multiplier,
            poison = damage_multiplier,
            melee = damage_multiplier,
            drill = damage_multiplier,
            fire = damage_multiplier,
        };
        local damage_models = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        for index,damage_model in pairs( damage_models ) do
            for damage_type,adjustment in pairs( adjustments ) do
                local multiplier = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                multiplier = multiplier * adjustment;
                ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( multiplier ) );
            end
        end
	end, true
) );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DEMOLITIONIST", "demolitionist", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_demolitionist_bonus", 0.0, function(value) return tonumber( value ) + 2; end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_DIPLOMATIC_IMMUNITY", "diplomatic_immunity", false, function( entity_perk_item, entity_who_picked, item_name )
        GameAddFlagRun( FLAGS.CalmGods );
        GlobalsSetValue( "TEMPLE_SPAWN_GUARDIAN", "0" );
	end
) );

function does_wand_have_an_always_cast( wand )
    local children = EntityGetAllChildren( wand ) or {};
    for _,action in pairs( children ) do
        local item_component = FindFirstComponentByType( action, "ItemComponent" );
        if item_component ~= nil then
            if ComponentGetValue( item_component, "permanently_attached" ) == "1" then
                return true;
            end
        end
    end
end

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DISENCHANT_SPELL", "disenchant_spell", false, function( entity_perk_item, entity_who_picked, item_name )
        local base_wand = nil;
        local wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
        for key,child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                wands = EntityGetChildrenWithTag( child, "wand" );
                break;
            end
        end
        if #wands > 0 then
            local filtered_wands = {};
            for _,wand in pairs(wands) do
                if does_wand_have_an_always_cast( wand ) then
                    table.insert( filtered_wands, wand );
                end
            end
            if #filtered_wands > 0 then
                wands = filtered_wands;
                local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
                local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
                for _,wand in pairs( wands ) do
                    if wand == active_item then
                        base_wand = wand;
                        break;
                    end
                end
                if base_wand == nil then
                    base_wand =  random_from_array( wands );
                end
            end
        end
        if base_wand ~= nil then
            local children = EntityGetAllChildren( base_wand );
            --[[ TODO this is probably fine to not run since the slot should exist already
            local ability_component = WandGetAbilityComponent( base_wand );
                if ability_component ~= nil then
                local deck_capacity = tonumber( ComponentObjectGetValue( ability_component, "gun_config", "deck_capacity" ) );
                ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring( deck_capacity - 1 ) );
            end
            ]]

            local actions = {};
            for i,v in ipairs( children ) do
                local components = EntityGetAllComponents( v );
                for _,component in pairs(components) do
                    if ComponentGetValue( component, "permanently_attached" ) == "1" then
                        table.insert( actions, component );
                    end
                end
            end
            if #actions > 0 then
                local to_attach = random_from_array( actions );
                if to_attach ~= nil then
                    ComponentSetValue( to_attach, "permanently_attached", "0" );
                end
            end
        end
	end
));

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_DUPLICATE_WAND", "duplicate_wand", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local base_wand = WandGetActiveOrRandom( entity_who_picked );
        if base_wand ~= nil then
            local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/placeholder_wand.xml", x, y-8 );
            EntitySetVariableNumber( copy_wand, "gkbrkn_duplicate_wand", 1 );
            CopyWand( base_wand, copy_wand );
            local item = EntityGetFirstComponent( copy_wand, "ItemComponent" );
            if item ~= nil then
                ComponentSetValue( item, "play_hover_animation", "1" );
            end
        end
	end
) );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_EXTRA_PROJECTILE", "extra_projectile", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_extra_projectiles", 0.0, function( value ) return value + 1; end );
	end
));

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_FRAGILE_EGO", "fragile_ego", true, function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, {
            ice = 0.25,
            electricity = 0.25,
            radioactive = 0.25,
            slice = 0.25,
            projectile = 0.25,
            healing = 0.25,
            physics_hit = 0.25,
            explosion = 0.25,
            poison = 0.25,
            melee = 0.25,
            drill = 0.25,
            fire = 0.25,
        });
        EntityAddComponent( entity_who_picked, "LuaComponent",{
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/fragile_ego/damage_received.lua",
            execute_every_n_frame="-1"
        })
	end
));

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_GOLDEN_BLOOD", "golden_blood", true, function( entity_perk_item, entity_who_picked, item_name )
        local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if damagemodels ~= nil then
            for i,damagemodel in ipairs( damagemodels ) do
                ComponentSetValue( damagemodel, "blood_material", "gold" );
                ComponentSetValue( damagemodel, "blood_spray_material", "gold" );
                ComponentSetValue( damagemodel, "blood_multiplier", "0.2" );
                ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_yellow_$[1-3].xml" );
                ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_yellow_$[1-3].xml" );
            end
        end
	end, true
));

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_HEALTHIER_HEART", "healthier_heart", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_max_health_recovery", 0.0, function( value ) return value + 1.0; end );
	end
));

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_HYPER_CASTING", "hyper_casting", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_hyper_casting", 0, function( value ) return tonumber( value ) + 1; end );
	end
));

table.insert( perk_list,
    -- TODO this can be made into an enemy usable perk
    generate_perk_entry( "GKBRKN_INVINCIBILITY_FRAMES", "invincibility_frames", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_invincibility_frames", 0.0, function( value ) return value + 20.0 end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_KNOCKBACK_IMMUNITY", "knockback_immunity", true, function( entity_perk_item, entity_who_picked, item_name )
        local components = EntityGetComponent( entity_who_picked, "DamageModelComponent" );
        if components ~= nil then
            for i,dataComponent in pairs( components ) do
                ComponentSetValue( dataComponent, "minimum_knockback_force", "100000" );
            end
        end
	end
));

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_LEAD_BOOTS", "lead_boots", false, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_lead_boots", 1 );
	end
) );


table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_LIVING_WAND", "living_wand", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local valid_wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
		for key, child in pairs(children) do
			if EntityGetName( child ) == "inventory_quick" then
                valid_wands = EntityGetChildrenWithTag( child, "wand" );
                break;
			end
        end

        if #valid_wands > 0 then
            local base_wand = random_from_array( valid_wands );
            GameKillInventoryItem( entity_who_picked, base_wand );
            EntityAddChild( entity_who_picked, EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/living_wand/anchor.xml" ) );

            local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/living_wand/ghost.xml", x, y );
            local living_wand = EntityGetWithTag( "gkbrkn_living_wand_"..tostring(copy_wand) )[1];
            CopyWand( base_wand, living_wand );

        end
	end, true
) );

local tracker_variable = "gkbrkn_lost_treasure_tracker";
table.insert( perk_list,
    generate_perk_entry( "GKBRKN_LOST_TREASURE", "lost_treasure", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );
        local tracker = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", tracker_variable );
        if tracker ~= nil then
            local spawner = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/perks/lost_treasure/spawner.xml", 0, 0 );
            local current_lost_treasure_count = tonumber(ComponentGetValue( tracker, "value_string" ));
            EntityAddComponent( spawner, "VariableStorageComponent", {
                _tags=tracker_variable,
                name=tracker_variable,
                value_string=tostring(current_lost_treasure_count)
            });
            ComponentSetValue( tracker, "value_string", "0" )
            EntityAddChild( entity_who_picked, spawner );
        end
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MAGIC_LIGHT", "magic_light", false, function( entity_perk_item, entity_who_picked, item_name )
        local magic_light = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/perks/magic_light/magic_light.xml" );
        EntityAddChild( entity_who_picked, magic_light );
	end, true
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MANA_EFFICIENCY", "mana_efficiency", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_mana_efficiency", } );
	end, true
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MANA_MASTERY", "mana_mastery", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_mana_mastery", 0.0, function( value ) return value + 1.0; end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MANA_RECOVERY", "mana_recovery", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_mana_recovery", 0.0, function( value ) return value + 1.6666667; end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MATERIAL_COMPRESSION", "material_compression", false, function( entity_perk_item, entity_who_picked, item_name )
        local succ_bonus = EntityGetFirstComponent( entity_who_picked, "VariableStorageComponent", "gkbrkn_material_compression" );
        if succ_bonus == nil then
            succ_bonus = EntityAddComponent( entity_who_picked, "VariableStorageComponent", {
                _tags="gkbrkn_material_compression",
                value_string="0"
            });
        end
        ComponentSetValue( succ_bonus, "value_string", tostring( tonumber( ComponentGetValue( succ_bonus, "value_string" ) + 1 ) ) );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MEGACAST", "megacast", false, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_draw_remaining", 1 );
	end
) );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_MERGE_WANDS", "merge_wands", false, function( entity_perk_item, entity_who_picked, item_name )
        local x, y = EntityGetTransform( entity_who_picked );

        local held_wands = {};
        local active_wand = nil;
        local children = EntityGetAllChildren( entity_who_picked ) or {};
        local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
        if inventory2 ~= nil then
            for key, child in pairs( children ) do
                if EntityGetName( child ) == "inventory_quick" then
                    held_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
                    break;
                end
            end
            for _,wand in pairs( held_wands ) do
                local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
                if wand == active_item then
                    active_wand = wand;
                end
            end
        end

        if #held_wands > 0 then
            local comparisons = {
                shuffle_deck_when_empty=function( current_value, previous_value ) if current_value == "false" then return current_value; end end,
                actions_per_round=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
                speed_multiplier=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
                deck_capacity=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
                reload_time=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
                fire_rate_wait=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
                spread_degrees=function( current_value, previous_value ) if tonumber(previous_value) > tonumber(current_value) then return current_value; end end,
                mana_charge_speed=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
                mana_max=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
                mana=function( current_value, previous_value ) if tonumber(previous_value) < tonumber(current_value) then return current_value; end end,
            }

            local best_values = {
                shuffle_deck_when_empty="true",
                actions_per_round=1,
                speed_multiplier=1,
                deck_capacity=0,
                reload_time=99999,
                fire_rate_wait=99999,
                spread_degrees=0,
                mana_charge_speed=0,
                mana_max=0,
                mana=0,
            };

            for _,wand in pairs( held_wands ) do
                local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
                for stat,comparison in pairs( comparisons ) do
                    local current_value = best_values[stat];
                    local outcome = comparison( ability_component_get_stat( ability, stat ), current_value );
                    best_values[stat] = outcome or current_value;
                end
            end

            local held_actions = {};
            for _,wand in pairs( held_wands ) do
                while true do
                    if wand == active_wand then
                        local removed_spell = wand_remove_first_action( wand, true, true );
                        if not removed_spell then
                            break;
                        else
                            table.insert( held_actions, removed_spell );
                        end
                    else
                        if not wand_explode_random_action( wand, false, false, x, y ) then
                            break;
                        end
                    end
                end
                GameKillInventoryItem( entity_who_picked, wand );
                EntitySetTransform( item, -9999, -9999 );
                EntityRemoveFromParent( wand );
            end
            
            if inventory2 ~= nil then
                local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
                if inventory2 ~= nil then
                    ComponentSetValue( inventory2, "mInitialized", 0 );
                    ComponentSetValue( inventory2, "mForceRefresh", 1 );
                end
            end

            local copy_wand = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/placeholder_wand.xml", x, y-8 );
            EntitySetVariableNumber( copy_wand, "gkbrkn_merged_wand", 1 );

            initialize_wand( copy_wand, { name="merged wand", stats=best_values } );

            for _,held_action in pairs( held_actions ) do
                wand_attach_action( copy_wand, held_action );
            end

            local item = EntityGetFirstComponent( copy_wand, "ItemComponent" );
            if item ~= nil then
                ComponentSetValue( item, "play_hover_animation", "1" );
            end
        end
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_MULTICAST", "multicast", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_draw_actions_bonus", 0, function(value) return tonumber( value ) + 2 end );
	end, true
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_PASSIVE_RECHARGE", "passive_recharge", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_passive_recharge", 0.0, function( value ) return value + 1; end );
	end, true
) );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_PROMOTE_SPELL", "promote_spell", false, function( entity_perk_item, entity_who_picked, item_name )
        local base_wand = nil;
        local wands = {};
        local children = EntityGetAllChildren( entity_who_picked );
        for key,child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                wands = EntityGetChildrenWithTag( child, "wand" );
                break;
            end
        end
        if #wands > 0 then
            local filtered_wands = {};
            for _,wand in pairs( wands ) do
                if wand_is_always_cast_valid( wand ) then
                    table.insert( filtered_wands, wand );
                end
            end
            if #filtered_wands > 0 then
                wands = filtered_wands;
                local inventory2 = EntityGetFirstComponent( entity_who_picked, "Inventory2Component" );
                local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
                for _,wand in pairs( wands ) do
                    if wand == active_item then
                        base_wand = wand;
                        break;
                    end
                end
                if base_wand == nil then
                    base_wand =  random_from_array( wands );
                end
            end
        end
        if base_wand ~= nil then
            local children = EntityGetAllChildren( base_wand );
            local ability_component = WandGetAbilityComponent( base_wand );
                if ability_component ~= nil then
                local deck_capacity = tonumber( ComponentObjectGetValue( ability_component, "gun_config", "deck_capacity" ) );
                ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring( deck_capacity + 1 ) );
            end

            local actions = {};
            for i,v in ipairs( children ) do
                local components = EntityGetAllComponents( v );
                for _,component in pairs(components) do
                    if ComponentGetValue( component, "permanently_attached" ) == "0" then
                        table.insert( actions, component );
                    end
                end
            end
            if #actions > 0 then
                local to_attach = random_from_array( actions );
                if to_attach ~= nil then
                    ComponentSetValue( to_attach, "permanently_attached", "1" );
                end
            end
            --wand_lock( base_wand );
        end
	end
));

table.insert( perk_list,
    -- TODO this can be made to support enemies
    generate_perk_entry( "GKBRKN_PROTAGONIST", "protagonist", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_low_health_damage_bonus", 0.0, function( value ) return value + 2.00; end );
	end
) );

table.insert( perk_list, 
    generate_perk_entry( "GKBRKN_QUEUE_CASTING", "queue_casting", false, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_force_trigger_death", 1 );
	end, true
));

table.insert( perk_list,
    -- TODO this can be made to support enemies
    generate_perk_entry( "GKBRKN_RAPID_FIRE", "rapid_fire", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_rapid_fire", 0.0, function( value ) return value + 1; end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_RESILIENCE", "resilience", true, function( entity_perk_item, entity_who_picked, item_name )
        TryAdjustDamageMultipliers( entity_who_picked, {
            fire=0.33,
            radioactive=0.33,
            poison=0.33,
            electricity=0.33,
        } );
	end, true
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_SHORT_TEMPER", "short_temper", true, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/short_temper/damage_received.lua"
        });
    end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_SPELL_EFFICIENCY", "spell_efficiency", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "ShotEffectComponent", { extra_modifier = "gkbrkn_spell_efficiency", } );
	end, true
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_SWAPPER", "swapper", true, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", {
            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/perks/swapper/damage_received.lua"
        });
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_THRIFTY_SHOPPER", "thrifty_shopper", false, function( entity_perk_item, entity_who_picked, item_name )
        GlobalsSetValue( "TEMPLE_SHOP_ITEM_COUNT", tostring( tonumber( GlobalsGetValue( "TEMPLE_SHOP_ITEM_COUNT", "5" ) ) + 2 ) );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_TREASURE_RADAR", "treasure_radar", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAddComponent( entity_who_picked, "LuaComponent", 
        { 
            script_source_file = "mods/gkbrkn_noita/files/gkbrkn/perks/treasure_radar/update.lua",
            execute_every_n_frame = "1",
        } );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_WANDSMITH", "wandsmith", false, function( entity_perk_item, entity_who_picked, item_name )
        EntityAdjustVariableNumber( entity_who_picked, "gkbrkn_wandsmith_stacks", 0.0, function( value ) return value + 1; end );
	end
) );

table.insert( perk_list,
    generate_perk_entry( "GKBRKN_RECURSION", "recursion", true, function( entity_perk_item, entity_who_picked, item_name )
        EntitySetVariableNumber( entity_who_picked, "gkbrkn_recursion_stacks", EntityGetVariableNumber( entity_who_picked, "gkbrkn_recursion_stacks", 0 ) + 3 );
        TryAdjustMaxHealth( entity_who_picked, function( max_health ) return max_health * 0.67; end );
    end
) );