dofile_once( "files/gkbrkn/lib/variables.lua" );
dofile_once( "files/gkbrkn/config.lua" );
dofile_once( "files/gkbrkn/helper.lua" );

--GamePrint( GetUpdatedEntityID() );

local t = GameGetRealWorldTimeSinceStarted();
local now = GameGetFrameNum();

function IsGoldNuggetLostTreasure( entity )
    return EntityGetFirstComponent( entity, "LuaComponent", "gkbrkn_lost_treasure" ) ~= nil
end
function IsGoldNuggetDecayTracked( entity )
    return EntityGetFirstComponent( entity, "LuaComponent", "gkbrkn_gold_decay" ) ~= nil;
end

local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local children = EntityGetAllChildren( entity ) or {};

--[[ material immunities
if _apply_material ~= true and now % 180 == 0 then
    _apply_material = true;
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" ) or {};
    for _,damage_model in pairs( damage_models ) do
        adjust_material_damage( damage_model, function( materials, damage )
            table.insert( materials, "water");
            table.insert( damage, "0.1");
            return materials, damage;
        end);
        --EntitySetComponentIsEnabled( entity, damage_model, true );
        local polymorph = GetGameEffectLoadTo( entity, "POLYMORPH", true )
        ComponentSetValue( polymorph, "frames", 1 );
    end
end
]]

--[[ Invincibility Frames ]]
if HasFlagPersistent( MISC.InvincibilityFrames.FlashEnabled ) then
    local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
    local max_invincibility_frames = 0;
    for _,damage_model in pairs( damage_models ) do
        local invincibility_frames = tonumber(ComponentGetValue( damage_model, "invincibility_frames" ));
        if invincibility_frames > max_invincibility_frames then
            max_invincibility_frames = invincibility_frames;
        end
    end

    if max_invincibility_frames > 0 then
        local sprites = {};
        local children = { entity };
        for _,child in pairs( children ) do
            local child_sprites = EntityGetComponent( child, "SpriteComponent" );
            if child_sprites ~= nil and #child_sprites > 0 then
                for _,sprite in pairs( child_sprites ) do
                    table.insert( sprites, sprite );
                end
            end

            local child_children = EntityGetAllChildren( child );
            if child_children ~= nil and #child_children > 0 then
                for _,child_child in pairs(child_children ) do
                    table.insert( children, child_child );
                end
            end
        end

        local alpha = math.floor( now / 2 ) % 2;
        if max_invincibility_frames == 1 then
            alpha = 1;
        end
        
        for _,sprite in pairs( sprites ) do
            ComponentSetValue( sprite, "alpha", alpha );
        end
    end
end

--[[ Mana Recovery ]]
local mana_recovery = EntityGetVariableNumber( entity, "gkbrkn_mana_recovery", 0 );
if mana_recovery ~= 0 then
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    if inventory2 ~= nil then
        for key, child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                valid_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
                break;
            end
        end

        for _,wand in pairs(valid_wands) do
            local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
            if ability ~= nil then
                local mana = tonumber( ComponentGetValue( ability, "mana" ) );
                local max_mana = tonumber( ComponentGetValue( ability, "mana_max" ) );
                if mana < max_mana then
                    ComponentSetValue( ability, "mana", tostring( math.min( mana + mana_recovery, max_mana ) ) );
                end
            end
        end
    end
end

--[[ Passive Recharge ]]
local recharge_speed = EntityGetVariableNumber( entity, "gkbrkn_passive_recharge", 0.0 );
if HasFlagPersistent( MISC.PassiveRecharge.Enabled ) and recharge_speed < MISC.PassiveRecharge.Speed then
    recharge_speed = MISC.PassiveRecharge.Speed;
end
if recharge_speed ~= 0 then
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    local active_item = ComponentGetValue( inventory2, "mActiveItem" );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,wand in pairs( EntityGetChildrenWithTag( child, "wand" ) or {} ) do
                if tonumber(wand) ~= tonumber(active_item) then
                    table.insert( valid_wands, wand );
                end
            end
            break;
        end
    end
    
    for _,wand in pairs( valid_wands ) do
        local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
        if ability ~= nil then
            local reload_frames_left = tonumber( ComponentGetValue( ability, "mReloadFramesLeft" ) );
            if reload_frames_left > 0 then
                ComponentSetValue( ability, "mReloadFramesLeft", tostring( reload_frames_left - recharge_speed ) );
            end
        end
    end
end

--[[ Heal New Health ]]
-- TODO this might eventually need to be changed to variable storage
last_max_hp = last_max_hp or {};
local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
for _,damage_model in pairs( damage_models ) do
    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    if last_max_hp[tostring(damage_model)] == nil then
        last_max_hp[tostring(damage_model)] = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    end
    if max_hp > last_max_hp[tostring(damage_model)] then
        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
        local hp_difference = max_hp - current_hp;
        local target_recovery = EntityGetVariableNumber( entity, "gkbrkn_max_health_recovery", 0.0 );
        if HasFlagPersistent( MISC.HealOnMaxHealthUp.Enabled ) and target_recovery < 1.0 then
            target_recovery = 1.0;
        end
        if HasFlagPersistent( MISC.HealOnMaxHealthUp.FullHeal ) then
            target_recovery = 1000.0;
        end
        local gained_hp = (max_hp - last_max_hp[tostring(damage_model)]) * target_recovery;
        if gained_hp > 0 then
            gained_hp = math.min( gained_hp, hp_difference );
            ComponentSetValue( damage_model, "hp", tostring( current_hp + gained_hp ) );
            if math.ceil(gained_hp) ~= 0 then
                GamePrint("Regained "..math.ceil(gained_hp * 25).." health");
            end
        end
        last_max_hp[tostring(damage_model)] = max_hp;
    end
end

--[[ Quick Swap ]]
-- TODO definitely needs more work
if HasFlagPersistent( MISC.QuickSwap.Enabled ) then
    local controls = EntityGetFirstComponent( entity, "ControlsComponent" );
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    if controls ~= nil and inventory2 ~= nil then
        local active_item = tonumber(ComponentGetValue( inventory2, "mActiveItem" ));
        if active_item == nil or active_item == 0 or EntityHasTag( active_item, "wand" ) == true then
            local alt_fire = ComponentGetValue( controls, "mButtonDownFire2" );
            local alt_fire_frame = ComponentGetValue( controls, "mButtonFrameFire2" );
            if alt_fire == "1" and now == tonumber(alt_fire_frame) then
                local inventory = nil;
                local swap_inventory = nil;
                for _,child in pairs(EntityGetAllChildren( entity )) do
                    if EntityGetName(child) == "inventory_quick" then
                        inventory = child;
                    elseif EntityGetName(child) == "gkbrkn_quick_swap_inventory" then
                        swap_inventory = child;
                    end
                end
                if swap_inventory == nil then
                    swap_inventory = EntityLoad("files/gkbrkn/misc/quick_swap_entity.xml");
                    EntityAddChild( entity, swap_inventory );
                end
                if inventory ~= nil and swap_inventory ~= nil then
                    local inventory_entities = EntityGetAllChildren( inventory ) or {};
                    local swap_inventory_entities = EntityGetAllChildren( swap_inventory ) or {};
                    for _,child in pairs(inventory_entities) do EntityRemoveFromParent( child ); end
                    for _,child in pairs(swap_inventory_entities) do EntityRemoveFromParent( child ); end
                    for _,child in pairs(inventory_entities) do EntityAddChild( swap_inventory, child ); end
                    for _,child in pairs(swap_inventory_entities) do EntityAddChild( inventory, child ); end
                end
            end
        end
    end
end

--[[ Gold Tracking ]]
local gold_tracker_world = HasFlagPersistent( MISC.GoldPickupTracker.ShowTrackerEnabled );
local gold_tracker_message = HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageEnabled );
if gold_tracker_world or gold_tracker_message then
    last_money = last_money or 0;
    money_picked_total = money_picked_total or 0;
    money_picked_time_last = money_picked_time_last or 0;
    local update_tracker = false;

    local wallet = EntityGetFirstComponent( entity, "WalletComponent" );
    if wallet ~= nil then
        local money = ComponentGetValue( wallet, "money" );
        if money - last_money > 0 then
            money_picked_total = money_picked_total + money - last_money;
            money_picked_time_last = now;
            update_tracker = true;
        end
        last_money = money;
    end

    if money_picked_total > 0 then
        if gold_tracker_world then
            if update_tracker then
                local gold_trackers = EntityGetWithTag( "gkbrkn_gold_tracker" ) or {};
                for _,gold_tracker in pairs( gold_trackers ) do
                    EntityKill( gold_tracker );
                end
                local x,y = EntityGetTransform( entity );
                local text = EntityLoad( "files/gkbrkn/misc/gold_tracking/gold_tracker.xml", x, y );
                EntityAddChild( entity, text );
                EntityAddComponent( text, "SpriteComponent", {
                    _tags="enabled_in_world",
                    image_file="files/gkbrkn/font_pixel_white.xml" ,
                    emissive="1",
                    is_text_sprite="1",
                    offset_x="8" ,
                    offset_y="-4" ,
                    update_transform="1" ,
                    update_transform_rotation="0",
                    text="$"..tostring(money_picked_total),
                    has_special_scale="1",
                    special_scale_x="0.6667",
                    special_scale_y="0.6667",
                    z_index="-9000",
                });
            end
        end
        if now - money_picked_time_last >= MISC.GoldPickupTracker.TrackDuration then
            if gold_tracker_message then
                GamePrint( "Picked up $"..money_picked_total );
            end
            money_picked_total = 0;
        end
    end
end

--[[ Lost Treasure ]]
local check_radius = 192;

-- iterate through all components of all entities around all players to find
-- nuggets we haven't tracked
local natural_nuggets = {};
local nearby_entities = EntityGetInRadiusWithTag( x, y, check_radius, "item_physics" );
for _,entity in pairs( nearby_entities ) do
    -- TODO  this is technically safer since disabled components don't show up, but if it's disabled then
    -- we probably don't want to consider this nugget anyway
    if CONTENT[PERKS.LostTreasure].enabled() and IsGoldNuggetLostTreasure( entity ) == false then
        local components = EntityGetComponent( entity, "LuaComponent" );
        if components ~= nil then
            for _,component in pairs(components) do
                -- TODO there needs to be a better more future proofed way to get gold nuggets
                if ComponentGetValue( component, "script_item_picked_up" ) == "data/scripts/items/gold_pickup.lua" then
                    EntityAddComponent( entity, "LuaComponent", {
                        execute_every_n_frame = "-1",
                        remove_after_executed = "1",
                        script_item_picked_up = "files/gkbrkn/perks/lost_treasure/gold_pickup.lua",
                    });
                    EntityAddComponent( entity, "LuaComponent", {
                        _tags="gkbrkn_lost_treasure",
                        execute_on_removed="1",
                        execute_every_n_frame="-1",
                        script_source_file = "files/gkbrkn/perks/lost_treasure/gold_removed.lua",
                    });
                    --local ex, ey = EntityGetTransform( entity );
                    --GamePrint( "New nuggy found at "..ex..", "..ey );
                    break;
                end
            end
        end
    end
    if HasFlagPersistent( MISC.GoldDecay.Enabled ) and IsGoldNuggetDecayTracked( entity ) == false then
        local components = EntityGetComponent( entity, "LuaComponent" );
        if components ~= nil then
            for _,component in pairs(components) do
                -- TODO there needs to be a better more future proofed way to get gold nuggets
                if ComponentGetValue( component, "script_item_picked_up" ) == "data/scripts/items/gold_pickup.lua" then
                    EntityAddComponent( entity, "LuaComponent", {
                        execute_every_n_frame = "-1",
                        remove_after_executed = "1",
                        script_item_picked_up = "files/gkbrkn/misc/gold_decay/gold_pickup.lua",
                    });
                    EntityAddComponent( entity, "LuaComponent", {
                        _tags="gkbrkn_gold_decay",
                        execute_on_removed="1",
                        execute_every_n_frame="-1",
                        script_source_file = "files/gkbrkn/misc/gold_decay/gold_removed.lua",
                    });
                    --local ex, ey = EntityGetTransform( entity );
                    --GamePrint( "New nuggy found at "..ex..", "..ey );
                end
            end
        end
    end
end

--[[ Material Compression ]]
-- TODO not sure how heavy this is to run every frame. item pickup & perk pickup event callback instead? look into it
local succ_bonus = EntityGetFirstComponent( entity, "VariableStorageComponent", "gkbrkn_material_compression" );
if succ_bonus ~= nil then
    local current_succ_bonus = tonumber( ComponentGetValue( succ_bonus, "value_string" ) );
    local children = EntityGetAllChildren( entity );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,item in pairs( EntityGetAllChildren( child ) ) do
                local components = EntityGetAllComponents( item ) or {};
                for _,component in pairs(components) do
                    local succ_size = tonumber( ComponentGetValue( component, "barrel_size" ) );
                    if succ_size ~= nil then
                        local item_succ_bonus = EntityGetFirstComponent( item, "VariableStorageComponent", "gkbrkn_material_compression" );
                        if item_succ_bonus == nil then
                            item_succ_bonus = EntityAddComponent( item, "VariableStorageComponent", {
                                _tags="gkbrkn_material_compression,enabled_in_hand,enabled_in_inventory,enabled_in_world",
                                value_string="0"
                            });
                        end
                        local item_current_succ_bonus = tonumber( ComponentGetValue( item_succ_bonus, "value_string" ) );
                        local succ_bonus_difference = current_succ_bonus - item_current_succ_bonus;
                        if succ_bonus_difference > 0 then
                            ComponentSetValue( component, "barrel_size", tostring( succ_size * math.pow( 2, succ_bonus_difference )  ) );
                            ComponentSetValue( item_succ_bonus, "value_string", tostring(current_succ_bonus) );
                        end
                    end
                end
            end
            break;
        end
    end
end

--[[ Champions ]]
if HasFlagPersistent( MISC.ChampionEnemies.Enabled ) then
    local nearby_enemies = EntityGetInRadiusWithTag( x, y, 256, "enemy" );
    for _,entity in pairs( nearby_enemies ) do
        SetRandomSeed( x, y );
        if EntityHasTag( entity, "gkbrkn_force_champion" ) == true or EntityHasTag( entity, "gkbrkn_champions" ) == false then
            EntityAddTag( entity, "gkbrkn_champions" );
            if EntityHasTag( entity, "gkbrkn_force_champion" ) or HasFlagPersistent( MISC.ChampionEnemies.AlwaysChampionsEnabled ) or Random() <= MISC.ChampionEnemies.ChampionChance then
                EntityRemoveTag( entity, "gkbrkn_force_champion" );
                local valid_champion_types = {};
                for index,champion_type in pairs( CHAMPION_TYPES ) do
                    local champion_type_data = CONTENT[champion_type].options;
                    if CONTENT[champion_type].enabled() and (champion_type_data.validator == nil or champion_type_data.validator( entity ) ~= false) then
                        table.insert( valid_champion_types, champion_type );
                    end
                end

                local champion_types_to_apply = 1;
                if HasFlagPersistent( MISC.ChampionEnemies.SuperChampionsEnabled ) then
                    while Random() <= MISC.ChampionEnemies.ExtraTypeChance and champion_types_to_apply < #valid_champion_types do
                        champion_types_to_apply = champion_types_to_apply + 1;
                    end
                end
                
                --[[ Things to apply to all champions ]]
                EntityAddComponent( entity, "LuaComponent", {
                    script_shot="files/gkbrkn/misc/champion_enemies/scripts/shot_champion.lua"
                });
                local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
                if #animal_ais > 0 then
                    for _,ai in pairs( animal_ais ) do
                        ComponentSetValues( ai, {
                            aggressiveness_min="100",
                            aggressiveness_max="100",
                            escape_if_damaged_probability="0",
                            hide_from_prey="0",
                            needs_food="0",
                            sense_creatures="1",
                            attack_only_if_attacked="0",
                            creature_detection_check_every_x_frames="60",
                            creature_detection_angular_range_deg="180",
                            dont_counter_attack_own_herd="1",
                            mGreatestPrey=entity,
                        });
                        ComponentAdjustValues( ai, {
                            max_distance_to_cam_to_start_hunting=function( value ) return  tonumber( value ) * 2; end,
                            creature_detection_range_x=function( value ) return  tonumber( value ) * 2; end,
                            creature_detection_range_y=function( value ) return  tonumber( value ) * 2; end,
                            attack_dash_frames_between=function( value ) return tonumber( value ) / 3; end,
                        });
                    end
                end
                local character_platforming = EntityGetFirstComponent( entity, "CharacterPlatformingComponent" );
                if character_platforming ~= nil then
                    ComponentSetMetaCustom( character_platforming, "run_velocity", tostring( tonumber( ComponentGetMetaCustom( character_platforming, "run_velocity" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "jump_velocity_x", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_x" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "jump_velocity_y", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_y" ) ) * 2 ) );
                    ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_up" ) ) * 3 ) );
                    ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_max_down" ) ) * 3 ) );
                    ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( tonumber( ComponentGetValue( character_platforming, "fly_speed_change_spd" ) ) * 3 ) );
                    ComponentSetMetaCustom( character_platforming, "fly_velocity_x", tostring( tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) ) * 3 ) );
                end
                local damage_models = EntityGetComponent( entity, "DamageModelComponent" );
                if damage_models ~= nil then
                    local resistances = {
                        ice = 0.67,
                        electricity = 0.67,
                        radioactive = 0.67,
                        slice = 0.67,
                        projectile = 0.67,
                        healing = 0.67,
                        physics_hit = 0.67,
                        explosion = 0.67,
                        poison = 0.67,
                        melee = 0.67,
                        drill = 0.67,
                        fire = 0.67,
                    };
                    for index,damage_model in pairs( damage_models ) do
                        for damage_type,multiplier in pairs( resistances ) do
                            local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                            resistance = resistance * multiplier;
                            ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                        end

                        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
                        local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
                        local new_max = max_hp * 1.5;
                        local regained = new_max - current_hp;
                        ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
                        ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );

                        local critical_damage_resistance = tonumber( ComponentGetValue( damage_model, "critical_damage_resistance" ) );
                        ComponentSetValue( damage_model, "critical_damage_resistance", tostring( math.max( critical_damage_resistance, 0.67 ) ) );
                    end
                end
                local badges = EntityLoad( "files/gkbrkn/misc/champion_enemies/badges.xml");
                EntityAddChild( entity, badges );

                --[[ Per champion type ]]
                for i=1,champion_types_to_apply do
                    local champion_type_index = math.ceil( math.random() * #valid_champion_types );
                    if champion_type_index == 0 then
                        break;
                    end
                    local champion_type = valid_champion_types[ champion_type_index ];
                    table.remove( valid_champion_types, champion_type_index );
                    local champion_data = CONTENT[champion_type].options;

                    if champion_data.badge ~= nil then
                        local badge = EntityCreateNew();
                        
                        local sprite = EntityAddComponent( badge, "SpriteComponent",{
                            z_index="-9000",
                            image_file=champion_data.badge
                        });
                        ComponentSetValue( sprite, "has_special_scale", "1");
                        ComponentSetValue( sprite, "z_index", "-9000");
                        EntityAddComponent( badge, "InheritTransformComponent",{
                            only_position="1"
                        });
                        EntityAddChild( badges, badge );
                    end

                    --[[ Game Effects ]]
                    for _,game_effect in pairs( champion_data.game_effects or {} ) do
                        local effect = GetGameEffectLoadTo( entity, game_effect, true );
                        if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
                    end

                    --[[ General Application ]]
                    if champion_data.apply ~= nil then
                        champion_data.apply( entity );
                    end

                    --[[ Particle Emitter ]]
                    local particle_material = champion_data.particle_material;
                    if particle_material ~= nil then
                        local emitter_entity = EntityLoad( "files/gkbrkn/misc/champion_enemies/particles.xml" );
                        local emitter = EntityGetFirstComponent( emitter_entity, "ParticleEmitterComponent" );
                        if emitter ~= nil then
                            ComponentSetValue( emitter, "emitted_material_name", particle_material );
                            EntityAddChild( entity, emitter_entity );
                        end
                        ComponentSetValueVector2( emitter, "gravity", 0, -200 );
                    end

                    --[[ Sprite Particle Emitter ]]
                    local sprite_particle_sprite_file = champion_data.sprite_particle_sprite_file;
                    if sprite_particle_sprite_file ~= nil then
                        local emitter_entity = EntityLoad( "files/gkbrkn/misc/champion_enemies/sprite_particles.xml" );
                        local emitter = EntityGetFirstComponent( emitter_entity, "SpriteParticleEmitterComponent" );
                        if emitter ~= nil then
                            ComponentSetValue( emitter, "sprite_file", sprite_particle_sprite_file );
                            EntityAddChild( entity, emitter_entity );
                        end
                    end

                    --[[ Rewards Drop ]]
                    EntityAddComponent( entity, "LuaComponent", {
                        script_damage_received="files/gkbrkn/misc/champion_enemies/scripts/damage_received.lua"
                    });
                end
            end
        end
    end
end

--[[ Health Bars ]]
if HasFlagPersistent( MISC.HealthBars.Enabled ) then
    local nearby_enemies = EntityGetInRadiusWithTag( x, y, 256, "enemy" );
    for _,entity in pairs( nearby_enemies ) do
        if EntityGetFirstComponent( entity, "HealthBarComponent" ) == nil then
            EntityAddComponent( entity, "HealthBarComponent" );
            EntityAddComponent( entity, "SpriteComponent", { 
                _tags="health_bar,ui,no_hitbox",
                _enabled="1",
                alpha="1",
                has_special_scale="1",
                image_file="files/gkbrkn/misc/health_bar.png",
                is_text_sprite="0",
                next_rect_animation="",
                offset_x="11",
                offset_y="-4",
                rect_animation="",
                special_scale_x="0.2",
                special_scale_y="0.6",
                ui_is_parent="0",
                update_transform="1",
                visible="1",
                z_index="-9000",
            });
        end
    end
end

--[[ Less Particles ]]
nearby_entities = EntityGetInRadius( x, y, 256 );
if HasFlagPersistent( MISC.LessParticles.Enabled ) then
    local disable = HasFlagPersistent( MISC.LessParticles.DisableEnabled );
    _less_particle_entity_cache = _less_particle_entity_cache or {};
    for _,nearby in pairs( nearby_entities ) do
        if _less_particle_entity_cache[nearby] ~= true then
            _less_particle_entity_cache[nearby] = true;
            local particle_emitters = EntityGetComponent( nearby, "ParticleEmitterComponent" ) or {};
            for _,emitter in pairs( particle_emitters ) do
                if ComponentGetValue( emitter, "emit_cosmetic_particles" ) == "1" and ComponentGetValue( emitter, "create_real_particles" ) == "0" and ComponentGetValue( emitter, "emit_real_particles" ) == "0" then
                    if disable then
                        EntitySetComponentIsEnabled( nearby, emitter, false );
                    else
                        ComponentSetValue( emitter, "count_max", "1" );
                        ComponentSetValue( emitter, "collide_with_grid", "0" );
                        ComponentSetValue( emitter, "is_trail", "0" );
                        local lifetime_min = tonumber( ComponentGetValue( emitter, "lifetime_min" ) );
                        ComponentSetValue( emitter, "lifetime_min", tostring( math.min( lifetime_min * 0.5, 0.1 ) ) );
                        local lifetime_max = tonumber( ComponentGetValue( emitter, "lifetime_max" ) );
                        ComponentSetValue( emitter, "lifetime_max", tostring( math.min( lifetime_max * 0.5, 0.5 ) ) );
                    end
                end
            end
            local sprite_particle_emitters = EntityGetComponent( nearby, "SpriteParticleEmitterComponent" ) or {};
            for _,emitter in pairs( sprite_particle_emitters ) do
                if disable then
                    EntitySetComponentIsEnabled( nearby, emitter, false );
                else
                    if ComponentGetValue( emitter, "entity_file" ) == "" then
                        ComponentSetValue( emitter, "count_max", "1" );
                        ComponentSetValue( emitter, "emission_interval_min_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_min_frames" ) ) * 2 ) ) );
                        ComponentSetValue( emitter, "emission_interval_max_frames", tostring( math.ceil( tonumber( ComponentGetValue( emitter, "emission_interval_max_frames" ) ) * 2 ) ) );
                    end
                end
            end
        end
    end
end

--[[ Tweak - Shorten Blindness ]]
if CONTENT[TWEAKS.Blindness].enabled() then
    local blindness = GameGetGameEffectCount( entity, "BLINDNESS" );
    if blindness > 0 then
        local effect = GameGetGameEffect( entity, "BLINDNESS" );
        local frames = tonumber( ComponentGetValue( effect, "frames" ) );
        if frames > 600 then
            ComponentSetValue( effect, "frames", 600 );
        end
    end
end

local update_time = GameGetRealWorldTimeSinceStarted() - t;
GlobalsSetValue("gkbrkn_update_time",update_time);