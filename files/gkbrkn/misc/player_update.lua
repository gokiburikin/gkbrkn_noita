dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

--TODO a lot of this stuff should be done in a world update rather than a player update

local t = GameGetRealWorldTimeSinceStarted();
local now = GameGetFrameNum();

local player_entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( player_entity );
local children = EntityGetAllChildren( player_entity ) or {};

--[[
if now % 30 == 0 then
    local game_effect = GetGameEffectLoadTo( player_entity, "POLYMORPH_RANDOM", true );
    if game_effect ~= nil then
        ComponentSetValue( game_effect, "polymorph_target", "data/entities/animals/longleg.xml" );
        ComponentSetValue( game_effect, "frames", "30" );
    end
    local children = EntityGetAllChildren( player_entity ) or {};
	for i,child_entity in ipairs( children ) do
		if EntityGetName( child_entity ) == "cape" then
            local cx, cy = EntityGetTransform( child_entity );
            local verlet = EntityGetFirstComponent( child_entity, "VerletPhysicsComponent" );
            if ComponentGetValue( verlet, "m_is_culled_previous" ) == "1" then
                EntityRemoveFromParent( child_entity );
                EntitySetTransform( child_entity, x+cx, y+cy );
                EntityAddChild( player_entity, child_entity );
            end
            GamePrint( "is cape culled: ".. ComponentGetValue( verlet, "m_is_culled_previous", "0" ) );
			break;
		end
	end
end
]]

--[[ material immunities
TODO still can't really make use of this without polymorphing
if true then
    local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};
    for _,damage_model in pairs( damage_models ) do
        --adjust_material_damage( damage_model, function( materials, damage )
        --    table.insert( materials, "water");
        --    table.insert( damage, "0.1");
        --    return materials, damage;
        --end);
        --EntitySetComponentIsEnabled( entity, damage_model, true );
        --local polymorph = GetGameEffectLoadTo( entity, "POLYMORPH", true )
        --ComponentSetValue( polymorph, "frames", 1 );
    end
end
]]

--[[ Invincibility Frames ]]
if HasFlagPersistent( MISC.InvincibilityFrames.FlashEnabled ) then
    local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
    local max_invincibility_frames = 0;
    for _,damage_model in pairs( damage_models ) do
        local invincibility_frames = tonumber(ComponentGetValue( damage_model, "invincibility_frames" ));
        if invincibility_frames > max_invincibility_frames then
            max_invincibility_frames = invincibility_frames;
        end
    end

    if max_invincibility_frames > 0 then
        local sprites = {};
        local children = { player_entity };
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
local mana_recovery = EntityGetVariableNumber( player_entity, "gkbrkn_mana_recovery", 0 );
if mana_recovery ~= 0 then
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
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
local recharge_speed = EntityGetVariableNumber( player_entity, "gkbrkn_passive_recharge", 0.0 );
if HasFlagPersistent( MISC.PassiveRecharge.Enabled ) and recharge_speed < MISC.PassiveRecharge.Speed then
    recharge_speed = MISC.PassiveRecharge.Speed;
end
if recharge_speed ~= 0 then
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
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
local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
for _,damage_model in pairs( damage_models ) do
    local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    if last_max_hp[tostring(damage_model)] == nil then
        last_max_hp[tostring(damage_model)] = tonumber(ComponentGetValue( damage_model, "max_hp" ));
    end
    if max_hp > last_max_hp[tostring(damage_model)] then
        local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
        local hp_difference = max_hp - current_hp;
        local target_recovery = EntityGetVariableNumber( player_entity, "gkbrkn_max_health_recovery", 0.0 );
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
    local controls = EntityGetFirstComponent( player_entity, "ControlsComponent" );
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    if controls ~= nil and inventory2 ~= nil then
        local active_item = tonumber(ComponentGetValue( inventory2, "mActiveItem" ));
        if active_item == nil or active_item == 0 or EntityHasTag( active_item, "wand" ) == true then
            local alt_fire = ComponentGetValue( controls, "mButtonDownFire2" );
            local alt_fire_frame = ComponentGetValue( controls, "mButtonFrameFire2" );
            if alt_fire == "1" and now == tonumber(alt_fire_frame) then
                local inventory = nil;
                local swap_inventory = nil;
                for _,child in pairs(EntityGetAllChildren( player_entity )) do
                    if EntityGetName(child) == "inventory_quick" then
                        inventory = child;
                    elseif EntityGetName(child) == "gkbrkn_quick_swap_inventory" then
                        swap_inventory = child;
                    end
                end
                if swap_inventory == nil then
                    swap_inventory = EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/quick_swap_entity.xml");
                    EntityAddChild( player_entity, swap_inventory );
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

--[[ Auto-collect Gold ]]
if HasFlagPersistent( MISC.AutoPickupGold.Enabled ) then
    local gold_nuggets = EntityGetWithTag( "gold_nugget" ) or {};
    for _,gold_nugget in pairs( gold_nuggets ) do
        if EntityHasTag( gold_nugget, "gkbrkn_special_goldnugget" ) == false then
            EntitySetTransform( gold_nugget, x, y );
            break;
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

    local wallet = EntityGetFirstComponent( player_entity, "WalletComponent" );
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
                local x,y = EntityGetTransform( player_entity );
                local text = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/gold_tracking/gold_tracker.xml", x, y );
                EntityAddChild( player_entity, text );
                EntityAddComponent( text, "SpriteComponent", {
                    _tags="enabled_in_world",
                    image_file="mods/gkbrkn_noita/files/gkbrkn/font_pixel_white.xml" ,
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

if now % 10 == 0 then
    local gold_nuggets = EntityGetWithTag( "gold_nugget" ) or {};
    for _,gold_nugget in pairs( gold_nuggets ) do
        --[[ Persistent Gold ]]
        if HasFlagPersistent( MISC.PersistentGold.Enabled ) then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            if lifetime_component ~= nil then
                EntityRemoveComponent( gold_nugget, lifetime_component );
            end
        end
        
        --[[ Lost Treasure ]]
        if CONTENT[PERKS.LostTreasure].enabled() and is_lost_treasure( gold_nugget ) == false then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            -- don't track gold nuggets that won't despawn naturally
            if lifetime_component ~= nil then
                set_lost_treasure( gold_nugget );
            end
        end
            
        --[[ Gold Decay ]]
        if HasFlagPersistent( MISC.GoldDecay.Enabled ) and is_gold_decay( gold_nugget ) == false then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            if lifetime_component ~= nil then
                set_gold_decay( gold_nugget );
            end
        end
    end

    --[[ Combine Gold ]]
    if HasFlagPersistent( MISC.CombineGold.Enabled ) then
        local nugget_sizes = { 10, 50, 200, 1000, 10000 };
        for _,gold_nugget in pairs( gold_nuggets ) do
            if EntityHasTag( gold_nugget, "gkbrkn_special_goldnugget" ) == false then
                local average_kill_frame = 0;
                local average_creation_frame = 0;
                if EntityGetIsAlive( gold_nugget ) then
                    local lifetime = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
                    if lifetime ~= nil then
                        average_kill_frame  = average_kill_frame + tonumber( ComponentGetValue( lifetime, "kill_frame" ) );
                        average_creation_frame  = average_creation_frame + tonumber( ComponentGetValue( lifetime, "creation_frame" ) );
                    end
                    local gx, gy = EntityGetTransform( gold_nugget );
                    local check_radius = MISC.CombineGold.Radius or 48;
                    local nearby_gold_nuggets = EntityGetInRadiusWithTag( gx, gy, check_radius, "gold_nugget" ) or {};
                    local merge_sum = 0;
                    for _,nearby in pairs(nearby_gold_nuggets) do
                        if EntityHasTag( nearby, "gkbrkn_special_goldnugget" ) == false then
                            if tonumber(nearby) ~= tonumber(gold_nugget) then
                                local lifetime = EntityGetFirstComponent( nearby, "LifetimeComponent" );
                                if lifetime ~= nil then
                                    average_kill_frame  = average_kill_frame + tonumber( ComponentGetValue( lifetime, "kill_frame" ) );
                                    average_creation_frame  = average_creation_frame + tonumber( ComponentGetValue( lifetime, "creation_frame" ) );
                                end
                                local components = EntityGetComponent( nearby, "VariableStorageComponent" ) or {};
                                for _,component in pairs( components ) do 
                                    if ComponentGetValue( component, "name" ) == "gold_value" then
                                        local gold_value = ComponentGetValueInt( component, "value_int" );
                                        merge_sum = merge_sum + gold_value;
                                        clear_lost_treasure( nearby );
                                        clear_gold_decay( nearby );
                                        EntityKill( nearby );
                                        break;
                                    end
                                end
                            end
                        end
                    end
                    average_kill_frame = math.ceil( average_kill_frame / #nearby_gold_nuggets );
                    average_creation_frame = math.ceil( average_creation_frame / #nearby_gold_nuggets );
                    if merge_sum > 0 then
                        local new_size = nil;
                        local new_gold_value = nil;
                        local components = EntityGetComponent( gold_nugget, "VariableStorageComponent" ) or {};
                        for _,component in pairs( components ) do 
                            if ComponentGetValue( component, "name" ) == "gold_value" then
                                local gold_value = tonumber(ComponentGetValueInt( component, "value_int" ));
                                new_gold_value = merge_sum + gold_value;
                                for i=2,#nugget_sizes do
                                    local size = nugget_sizes[i];
                                    local previous_size = nugget_sizes[i - 1];
                                    if gold_value < size and new_gold_value >= size then
                                        new_size = size;
                                    end
                                end
                                ComponentSetValue( component, "value_int", new_gold_value );
                            end
                        end
                        if new_size ~= nil and new_gold_value ~= nil then
                            clear_lost_treasure( gold_nugget );
                            clear_gold_decay( gold_nugget );
                            EntityKill( gold_nugget );
                            gold_nugget = EntityLoad( "data/entities/items/pickup/goldnugget_"..new_size..".xml", gx, gy );
                            local components = EntityGetComponent( gold_nugget, "VariableStorageComponent" ) or {};
                            for _,component in pairs( components ) do 
                                if ComponentGetValue( component, "name" ) == "gold_value" then
                                    ComponentSetValue( component, "value_int", new_gold_value );
                                end
                            end
                        end
                        local lifetime = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
                        if lifetime ~= nil and average_kill_frame ~= 0 and average_creation_frame ~= 0 then
                            local old_kill_frame = tonumber( ComponentGetValue( lifetime, "kill_frame" ) );
                            local old_creation_frame = tonumber( ComponentGetValue( lifetime, "creation_frame" ) );
                            ComponentSetValue( lifetime, "kill_frame", average_kill_frame );
                            ComponentSetValue( lifetime, "creation_frame", average_creation_frame );
                        end
                        local item = EntityGetFirstComponent( gold_nugget, "ItemComponent" );
                        if item ~= nil then
                            ComponentSetValue( item, "item_name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..new_gold_value..")" );
                        end

                        local ui_info = EntityGetFirstComponent( gold_nugget, "UIInfoComponent" );
                        if ui_info ~= nil then
                            ComponentSetValue( ui_info, "name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..new_gold_value..")" );
                        end
                        break;
                    end
                end
            end
        end
    end
end

--[[ Material Compression ]]
-- TODO not sure how heavy this is to run every frame. item pickup & perk pickup event callback instead? look into it
local succ_bonus = EntityGetFirstComponent( player_entity, "VariableStorageComponent", "gkbrkn_material_compression" );
if succ_bonus ~= nil then
    local current_succ_bonus = tonumber( ComponentGetValue( succ_bonus, "value_string" ) );
    local children = EntityGetAllChildren( player_entity );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,item in pairs( EntityGetAllChildren( child ) ) do
                local components = EntityGetAllComponents( item ) or {};
                for _,component in pairs(components) do
                    if ComponentGetTypeName( component ) == "MaterialSuckerComponent" then
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
                                ComponentSetValue( component, "barrel_size", tostring( succ_size * math.pow( 2, succ_bonus_difference ) ) );
                                ComponentSetValue( item_succ_bonus, "value_string", tostring( current_succ_bonus ) );
                            end
                        end
                    end
                end
            end
            break;
        end
    end
end

--[[ Free Inventory

    TODO nothing seemed to work, put it off for now

    local children = EntityGetAllChildren( entity );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,item_entity in pairs( EntityGetAllChildren( child ) ) do
                local item = FindFirstComponentThroughTags( item_entity, "is_equipable_forced" );
                if item ~= nil then
                    ComponentSetValue( item, "preferred_inventory", "FULL" );
                end
            end
        end
    end
]]

if now % 10 == 0 then
    local nearby_enemies = EntityGetWithTag( "enemy" );
    --[[ Champions ]]
    if GameHasFlagRun( MISC.ChampionEnemies.Enabled ) then
        for _,nearby in pairs( nearby_enemies ) do
            SetRandomSeed( now, x + y + nearby );

            --SetRandomSeed( x, y );
            if EntityHasTag( nearby, "gkbrkn_no_champion" ) == false and EntityHasTag( nearby, "drone_friendly" ) == false and (EntityHasTag( nearby, "gkbrkn_force_champion" ) == true or EntityHasTag( nearby, "gkbrkn_champions" ) == false) and does_entity_drop_gold( nearby ) == true then
                EntityAddTag( nearby, "gkbrkn_champions" );
                if EntityHasTag( nearby, "gkbrkn_force_champion" ) or GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsEnabled ) or Random() <= MISC.ChampionEnemies.ChampionChance then
                    EntityRemoveTag( nearby, "gkbrkn_force_champion" );
                    local is_mini_boss = Random() <= MISC.ChampionEnemies.MiniBossChance;

                    local valid_champion_types = {};
                    for index,champion_type in pairs( CHAMPION_TYPES ) do
                        local champion_type_data = CONTENT[champion_type].options;
                        if CONTENT[champion_type].enabled() and (champion_type_data.validator == nil or champion_type_data.validator( nearby ) ~= false) then
                            table.insert( valid_champion_types, champion_type );
                        end
                    end

                    local champion_types_to_apply = 1;
                    local champions_encountered = tonumber( GlobalsGetValue( "gkbrkn_champion_enemies_encountered" ) ) or 0;
                    if GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsEnabled ) then
                        local extra_type_chance = MISC.ChampionEnemies.ExtraTypeChance + champions_encountered * 0.0012;
                        local random_roll = Random();
                        while random_roll <= extra_type_chance and champion_types_to_apply < #valid_champion_types do
                            champion_types_to_apply = champion_types_to_apply + 1;
                            extra_type_chance = extra_type_chance - random_roll;
                            random_roll = Random();
                        end
                    end

                    GlobalsSetValue( "gkbrkn_champion_enemies_encountered", champions_encountered + 1 );
                    
                    --[[ Things to apply to all champions ]]
                    EntityAddComponent( nearby, "LuaComponent", {
                        script_shot="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/shot_champion.lua"
                    });
                    local animal_ais = EntityGetComponent( nearby, "AnimalAIComponent" ) or {};
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
                            });
                            ComponentAdjustValues( ai, {
                                max_distance_to_cam_to_start_hunting=function( value ) return  tonumber( value ) * 2; end,
                                creature_detection_range_x=function( value ) return  tonumber( value ) * 2; end,
                                creature_detection_range_y=function( value ) return  tonumber( value ) * 2; end,
                                --attack_dash_distance=function(value) return math.max( tonumber( value ), 150 ) end,
                            });
                        end
                    end
                    local character_platforming = EntityGetFirstComponent( nearby, "CharacterPlatformingComponent" );
                    local speed_multiplier = 1.25;
                    if character_platforming ~= nil then
                        ComponentSetMetaCustom( character_platforming, "run_velocity", tostring( tonumber( ComponentGetMetaCustom( character_platforming, "run_velocity" ) ) * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "jump_velocity_x", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_x" ) ) * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "jump_velocity_y", tostring( tonumber( ComponentGetValue( character_platforming, "jump_velocity_y" ) ) * speed_multiplier ) );
                        local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
                        ComponentSetMetaCustom( character_platforming, "fly_velocity_x", tostring( fly_velocity_x * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "fly_smooth_y", "0" );
                        ComponentSetValue( character_platforming, "fly_speed_mult", tostring( fly_velocity_x * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "fly_speed_max_up", tostring( fly_velocity_x * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "fly_speed_max_down", tostring( fly_velocity_x * speed_multiplier ) );
                        ComponentSetValue( character_platforming, "fly_speed_change_spd", tostring( fly_velocity_x * speed_multiplier ) );
                    end
                    local damage_models = EntityGetComponent( nearby, "DamageModelComponent" );
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
                        if is_mini_boss then
                            resistances.physics_hit = 0.10;
                        end
                        for index,damage_model in pairs( damage_models ) do
                            for damage_type,multiplier in pairs( resistances ) do
                                local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                                resistance = resistance * multiplier;
                                ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                            end

                            local current_hp = tonumber(ComponentGetValue( damage_model, "hp" ));
                            local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
                            local new_max = max_hp * 1.25;
                            if is_mini_boss then
                                new_max = max_hp * 6;
                            end
                            local regained = new_max - current_hp;
                            ComponentSetValue( damage_model, "max_hp", tostring( new_max ) );
                            ComponentSetValue( damage_model, "hp", tostring( current_hp + regained ) );
                        end
                    end

                    local add_these_badges = {};

                    local apply_these_champion_types = {};
                    if is_mini_boss then
                        apply_these_champion_types = {
                            CHAMPION_TYPES.Damage,
                            CHAMPION_TYPES.Projectile,
                            CHAMPION_TYPES.Haste,
                            CHAMPION_TYPES.Fast,
                            CHAMPION_TYPES.Armored,
                            CHAMPION_TYPES.Jetpack,
                            CHAMPION_TYPES.Reward,
                        };
                        add_these_badges = {"mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprites/mini_boss.xml"};
                    end

                    for i=1,math.min(#valid_champion_types, champion_types_to_apply) do
                        local champion_type_index = math.ceil( Random() * #valid_champion_types );
                        table.insert( apply_these_champion_types, valid_champion_types[ champion_type_index ] );
                        table.remove( valid_champion_types, champion_type_index );
                    end

                    --[[ Per champion type ]]
                    for _,champion_type in pairs(apply_these_champion_types) do
                        local champion_data = CONTENT[champion_type].options;
                        
                        if champion_data.badge ~= nil then
                            table.insert( add_these_badges, champion_data.badge );
                        end

                        --[[ Game Effects ]]
                        for _,game_effect in pairs( champion_data.game_effects or {} ) do
                            local effect = GetGameEffectLoadTo( nearby, game_effect, true );
                            if effect ~= nil then ComponentSetValue( effect, "frames", "-1" ); end
                        end

                        --[[ General Application ]]
                        if champion_data.apply ~= nil then
                            champion_data.apply( nearby );
                        end

                        --[[ Particle Emitter ]]
                        local particle_material = champion_data.particle_material;
                        if particle_material ~= nil then
                            local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/particles.xml" );
                            local emitter = EntityGetFirstComponent( emitter_entity, "ParticleEmitterComponent" );
                            if emitter ~= nil then
                                ComponentSetValue( emitter, "emitted_material_name", particle_material );
                                EntityAddChild( nearby, emitter_entity );
                            end
                            ComponentSetValueVector2( emitter, "gravity", 0, -200 );
                        end

                        --[[ Sprite Particle Emitter ]]
                        local sprite_particle_sprite_file = champion_data.sprite_particle_sprite_file;
                        if sprite_particle_sprite_file ~= nil then
                            local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/sprite_particles.xml" );
                            local emitter = EntityGetFirstComponent( emitter_entity, "SpriteParticleEmitterComponent" );
                            if emitter ~= nil then
                                ComponentSetValue( emitter, "sprite_file", sprite_particle_sprite_file );
                                EntityAddChild( nearby, emitter_entity );
                            end
                        end

                        --[[ Rewards Drop ]]
                        EntityAddComponent( nearby, "LuaComponent", {
                            script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/scripts/damage_received.lua"
                        });
                    end

                    if #add_these_badges > 0 then
                        local badges = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/badges.xml" );
                        EntityAddChild( nearby, badges );
                        for _,badge_filepath in pairs( add_these_badges ) do
                            local badge = EntityCreateNew();
                            
                            local sprite = EntityAddComponent( badge, "SpriteComponent",{
                                z_index="-9000",
                                image_file=badge_filepath
                            });
                            ComponentSetValue( sprite, "has_special_scale", "1");
                            ComponentSetValue( sprite, "z_index", "-9000");
                            EntityAddComponent( badge, "InheritTransformComponent",{
                                only_position="1"
                            });
                            EntityAddChild( badges, badge );
                        end
                    end
                end
            end
        end
    end

    --[[ Health Bars ]]
    if HasFlagPersistent( MISC.HealthBars.Enabled ) then
        for _,nearby in pairs( nearby_enemies ) do
            if EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil then
                EntityAddComponent( nearby, "HealthBarComponent" );
                EntityAddComponent( nearby, "SpriteComponent", { 
                    _tags="health_bar,ui,no_hitbox",
                    _enabled="1",
                    alpha="1",
                    has_special_scale="1",
                    image_file="mods/gkbrkn_noita/files/gkbrkn/misc/health_bar.png",
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

    --[[ Hero Mode Scaling ]]
    -- TODO find a better way to target enemies and bosses (dragon, pyramid, centipede)
    if GameHasFlagRun( MISC.HeroMode.Enabled ) then
        local speed_multiplier = 1.25; 

        local distance = EntityGetVariableNumber( player_entity, "gkbrkn_hero_mode_distance", 0.0 );
        local distance_multiplier = math.pow( 0.9, math.floor(distance / 7000) );
        local velocity = EntityGetFirstComponent( player_entity, "VelocityComponent" );
        local vx,vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local magnitude = math.sqrt( vx * vx );
        if magnitude > 0.01 then
            EntitySetVariableNumber( player_entity, "gkbrkn_hero_mode_distance", distance + magnitude );
        end

        local orb_multiplier =  1;
        if GameHasFlagRun( MISC.HeroMode.OrbsIncreaseDifficultyEnabled ) then
            orb_multiplier =  1 / math.pow( 1.1, GameGetOrbCountThisRun() );
        end

        --[[ aI states
            2 - go home?
            4 - go home?
            5 - jump
            7 - piss
            9 - wander?
            11 - makes longlegs jump around
            13 - melee attack
            14 - dash attack?
            15 - ranged attack
            21 - last valid state
        ]]

        local player_genome = EntityGetFirstComponent( player_entity, "GenomeDataComponent" );
        local player_herd = -1;
        if player_genome ~= nil then
            player_herd = ComponentGetMetaCustom( player_genome, "herd_id" );
        end
        for _,nearby in pairs( nearby_enemies ) do
            if EntityGetVariableNumber( nearby, "gkbrkn_hero_mode", 0.0 ) == 0 then
                EntitySetVariableNumber( nearby, "gkbrkn_hero_mode", 1.0 );
                local damage_models = EntityGetComponent( nearby, "DamageModelComponent" );
                if damage_models ~= nil then

                    local resistances = {
                        ice = 0.50,
                        electricity = 0.50,
                        radioactive = 0.50,
                        slice = 0.50,
                        projectile = 0.50,
                        healing = 0.50,
                        physics_hit = 0.50,
                        explosion = 0.50,
                        poison = 0.50,
                        melee = 0.50,
                        drill = 0.50,
                        fire = 0.50,
                    };
                    local resistance_multiplier = orb_multiplier * distance_multiplier;
                    for index,damage_model in pairs( damage_models ) do
                        for damage_type,multiplier in pairs( resistances ) do
                            local resistance = tonumber( ComponentObjectGetValue( damage_model, "damage_multipliers", damage_type ) );
                            resistance = resistance * multiplier * orb_multiplier * distance_multiplier;
                            ComponentObjectSetValue( damage_model, "damage_multipliers", damage_type, tostring( resistance ) );
                        end
                    end

                    local animal_ais = EntityGetComponent( nearby, "AnimalAIComponent" ) or {};
                    if #animal_ais > 0 then
                        for _,ai in pairs( animal_ais ) do
                            ComponentSetValues( ai, {
                                aggressiveness_min="100",
                                aggressiveness_max="100",
                                escape_if_damaged_probability="0",
                                attack_if_damaged_probability="100",
                                hide_from_prey="0",
                                needs_food="0",
                                sense_creatures="1",
                                attack_only_if_attacked="0",
                                dont_counter_attack_own_herd="1",
                                creature_detection_angular_range_deg="180",
                            });
                            ComponentAdjustValues( ai, {
                                attack_melee_frames_between=function(value) return math.ceil( tonumber( value ) / 1.25 ) end,
                                attack_dash_frames_between=function(value) return math.ceil( tonumber( value ) / 1.25 ) end,
                                attack_ranged_frames_between=function(value) return math.ceil( tonumber( value ) / 1.25 ) end,
                            });
                        end
                    end
                end
                local character_platforming = EntityGetFirstComponent( nearby, "CharacterPlatformingComponent" );
                if character_platforming ~= nil then
                    local fly_velocity_x = tonumber( ComponentGetMetaCustom( character_platforming, "fly_velocity_x" ) );
                    ComponentAdjustValues( character_platforming, {
                        jump_velocity_x = function(value) return tonumber( value ) * speed_multiplier; end,
                        jump_velocity_y = function(value) return tonumber( value ) * speed_multiplier; end,
                        fly_smooth_y = function(value) return "0" end,
                        fly_speed_mult = function(value) return tonumber( fly_velocity_x )  * speed_multiplier end,
                        fly_speed_max_up = function(value) return tonumber( fly_velocity_x )  * speed_multiplier end,
                        fly_speed_max_down = function(value) return tonumber( fly_velocity_x )  * speed_multiplier end,
                        fly_speed_change_spd = function(value) return tonumber( fly_velocity_x )  * speed_multiplier end,
                    });
                    ComponentAdjustMetaCustoms( character_platforming, {
                        run_velocity = function(value) return tonumber( value ) * speed_multiplier; end,
                        fly_velocity_x = function(value) return fly_velocity_x * speed_multiplier; end,
                        velocity_max_x = function(value) return tonumber( value ) * speed_multiplier; end,
                    });
                end

                -- this is an attempt to fix enemies getting stuck in meat piles which is dumb
                EntityAddComponent( nearby, "CellEaterComponent", {
                    radius="2",
                    eat_probability="25",
                } );

                EntityAddComponent( nearby, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/hero_mode/damage_received.lua"
                });
            end
            --[[
            -- only do it twice a second to reduce performance hit
            ]]
            if now % 30 == 0 and EntityGetVariableNumber( nearby, "gkbrkn_hero_mode", 0.0 ) == 1 then
                local charmed = GameGetGameEffectCount( nearby, "CHARM" );
                if charmed < 1 then
                    local nearby_genome = EntityGetFirstComponent( nearby, "GenomeDataComponent" );
                    local nearby_herd = -1;
                    if nearby_genome ~= nil then
                        nearby_herd = ComponentGetMetaCustom( nearby_genome, "herd_id" );
                        if player_herd ~= nearby_herd then
                            local animal_ais = EntityGetComponent( nearby, "AnimalAIComponent" ) or {};
                            for _,ai in pairs( animal_ais ) do
                                if ComponentGetValue( ai, "tries_to_ranged_attack_friends" ) ~= "1" then
                                    ComponentSetValue( ai, "mGreatestPrey", tostring( player_entity ) );
                                end
                            end
                        end
                    end
                end
            end
        end

        local nearby_wands = EntityGetInRadiusWithTag( x, y, 256, "wand" );
        for _,wand in pairs( nearby_wands ) do
            if EntityGetVariableNumber( wand, "gkbrkn_hero_wand", 0 ) == 0 and EntityGetVariableNumber( wand, "gkbrkn_duplicate_wand", 0 ) == 0 and EntityGetVariableNumber( wand, "gkbrkn_loadout_wand", 0 ) == 0 then
                --local ability = EntityGetFirstComponent( wand, "AbilityComponent", false );
                local x, y = EntityGetTransform( wand );
                SetRandomSeed( now, x + y + wand );
                local ability = FindFirstComponentByType( wand, "AbilityComponent" );
                if ability ~= nil then
                    EntitySetVariableNumber( wand, "gkbrkn_hero_wand", 1 );
                    local mana_multiplier = rand( 1.25, 1.5 );
                    ability_component_adjust_stats( ability, {
                        --shuffle_deck_when_empty = function(value) end,
                        --actions_per_round = function(value) end,
                        --speed_multiplier = function(value) end,
                        mana_max = function(value) return math.floor( tonumber( value ) * mana_multiplier ); end,
                        mana = function(value) return math.floor( tonumber( value ) * mana_multiplier ); end,
                        deck_capacity = function(value) return math.min( 25, tonumber( value ) + Random( 1, 2 ) ); end,
                        reload_time = function(value) return math.min( tonumber( value ), math.floor( tonumber( value ) * rand( 0.75, 0.95 ) ) ); end,
                        fire_rate_wait = function(value) return math.min( tonumber( value ), math.floor( tonumber( value ) * rand( 0.75, 0.95 ) ) ); end,
                        spread_degrees = function(value) return tonumber( value ) - Random( 0, 4 ); end,
                        mana_charge_speed = function(value) return math.ceil( ( tonumber( value ) + Random( 20, 30 ) ) * rand( 1.10, 1.25 ) ); end,
                    } );
                end
            end
        end
    end
end

--[[ Less Particles ]]
-- TODO update this one too
local nearby_entities = EntityGetInRadius( x, y, 256 );
if HasFlagPersistent( MISC.LessParticles.OtherStuffEnabled ) then
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

dofile("mods/gkbrkn_noita/files/gkbrkn/misc/projectile_capture.lua");

--[[ Tweak - Shorten Blindness ]]
if CONTENT[TWEAKS.Blindness].enabled() then
    local blindness = GameGetGameEffectCount( player_entity, "BLINDNESS" );
    if blindness > 0 then
        local effect = GameGetGameEffect( player_entity, "BLINDNESS" );
        local frames = tonumber( ComponentGetValue( effect, "frames" ) );
        if frames > 600 then
            ComponentSetValue( effect, "frames", 600 );
        end
    end
end

add_update_time( GameGetRealWorldTimeSinceStarted() - t );