local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

--TODO a lot of this stuff should be done in a world update rather than a player update since it doesn't need to happen per player
--TODO in fact much of this could (and should) be done based on the camera position since the player won't always be here (polymorph)

local t = GameGetRealWorldTimeSinceStarted();
local now = GameGetFrameNum();

local player_entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( player_entity );
local children = EntityGetAllChildren( player_entity ) or {};
local wands = {};
local active_wand = nil;
local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
if inventory2 ~= nil then
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            wands = EntityGetChildrenWithTag( child, "wand" ) or {};
            break;
        end
    end
    if active_item ~= nil and EntityHasTag( active_item, "wand" ) then
        active_wand = tonumber( active_item );
    end
end
local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {};

--[[ Tweak: Reduced Electrocution ]]
if find_tweak("reduced_electrocution") then
    local electrocution_effect = GameGetGameEffect( player_entity, "ELECTROCUTION" );
    if electrocution_effect ~= 0 then
        if ComponentGetValue2( electrocution_effect, "frames" ) > 1 then
            ComponentSetValue2( electrocution_effect, "frames", math.max( 1, ComponentGetValue2( electrocution_effect, "frames" ) - 1 ) );
        end
    end
end

--[[ Invincibility Frames ]]
if HasFlagPersistent( MISC.InvincibilityFrames.FlashingFlag ) then
    local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" );
    local max_invincibility_frames = 0;
    for _,damage_model in pairs( damage_models ) do
        local invincibility_frames = ComponentGetValue2( damage_model, "invincibility_frames" );
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
            ComponentSetValue2( sprite, "alpha", alpha );
        end
    end
end

--[[ Limited Mana ]]
if find_game_modifier("limited_mana") then
    local nearby_wands = EntityGetWithTag( "wand" );
    for _,wand in pairs( nearby_wands ) do
        local ability = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" );
        if ability ~= nil then
            if EntityGetVariableNumber( wand, "gkbrkn_limited_mana", 0 ) == 0 and EntityGetVariableNumber( wand, "gkbrkn_duplicate_wand", 0 ) == 0 and EntityGetVariableNumber( wand, "gkbrkn_merge_wand", 0 ) == 0 then
                EntitySetVariableNumber( wand, "gkbrkn_limited_mana", 1 );
                local mana_max = ability_component_get_stat( ability, "mana_max" );
                local mana_charge_speed = ability_component_get_stat( ability, "mana_charge_speed" );
                local adjusted_mana_max = mana_max * math.pow( mana_charge_speed, 0.4 );
                ability_component_set_stat( ability, "mana", adjusted_mana_max );
                ability_component_set_stat( ability, "mana_max", adjusted_mana_max );
                ability_component_set_stat( ability, "mana_charge_speed", 0 );
            else
                local current_mana = tonumber( ability_component_get_stat( ability, "mana" ) );
                local mana_max = tonumber( ability_component_get_stat( ability, "mana_max" ) );
                if current_mana < mana_max then
                    ability_component_set_stat( ability, "mana_max", current_mana );
                end
            end
        end
    end
end

local is_debug_mode_enabled = HasFlagPersistent( FLAGS.DebugMode)

--[[ Infinite Money ]]
if is_debug_mode_enabled and find_dev_option( "infinite_money" ) then
    local wallet = EntityGetFirstComponent( player_entity, "WalletComponent" );
    if wallet then
        ComponentSetValue2( wallet, "money", 2000000000 );
    end
end

--[[ Cheap Rerolls ]]
if is_debug_mode_enabled and find_dev_option( "cheap_rerolls" ) then
    GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", "-1" );
end

--[[ Spell Recovery ]]
if is_debug_mode_enabled and find_dev_option( "infinite_spells" ) then
    GameRegenItemActionsInPlayer( player_entity );
end

--[[ Health Recovery ]]
local health_recovery = 0;
if is_debug_mode_enabled and find_dev_option( "recover_health" ) then
    health_recovery = 4/15;
end

if health_recovery ~= 0 then
    for _,damage_model in pairs( damage_models ) do
        local hp = ComponentGetValue2( damage_model, "hp" );
        local max_hp = ComponentGetValue2( damage_model, "max_hp" );
        local new_hp = math.min( max_hp, hp + health_recovery );
        ComponentSetValue2( damage_model, "hp", new_hp );
    end
end

--[[ Mana Recovery ]]
local mana_recovery = EntityGetVariableNumber( player_entity, "gkbrkn_mana_recovery", 0 );
if is_debug_mode_enabled and find_dev_option( "infinite_mana" ) then
    mana_recovery = 9999;
end

if mana_recovery ~= 0 then
    if #wands > 0 then
        for _,wand in pairs( wands ) do
            local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
            if ability ~= nil then
                local mana = ComponentGetValue2( ability, "mana" );
                local max_mana = ComponentGetValue2( ability, "mana_max" );
                if mana < max_mana then
                    ComponentSetValue2( ability, "mana", math.min( mana + mana_recovery, max_mana ) );
                end
            end
        end
    end
end

--[[ Passive Recharge ]]
local recharge_speed = EntityGetVariableNumber( player_entity, "gkbrkn_passive_recharge", 0.0 );
if HasFlagPersistent( MISC.PassiveRecharge.EnabledFlag ) and recharge_speed < MISC.PassiveRecharge.Speed then
    recharge_speed = MISC.PassiveRecharge.Speed;
end

if recharge_speed ~= 0 then
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
    local valid_wands = {};
    
    for _,wand in pairs(wands) do
        if tonumber( wand ) ~= tonumber( active_item ) then
            table.insert( valid_wands, wand );
        end
    end
    
    for _,wand in pairs( valid_wands ) do
        local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
        if ability ~= nil then
            local reload_frames_left = ComponentGetValue2( ability, "mReloadFramesLeft" );
            if reload_frames_left > 0 then
                ComponentSetValue2( ability, "mReloadFramesLeft", reload_frames_left - recharge_speed );
            end
        end
    end
end

--[[ Heal New Health ]]
-- TODO this might eventually need to be changed to variable storage
last_max_hp = last_max_hp or {};
for _,damage_model in pairs( damage_models ) do
    damage_model = tostring( damage_model );
    local max_hp = ComponentGetValue2( damage_model, "max_hp" );
    if last_max_hp[ damage_model ] == nil then
        last_max_hp[ damage_model ] = ComponentGetValue2( damage_model, "max_hp" );
    end
    if max_hp > last_max_hp[ damage_model ] then
        local current_hp = ComponentGetValue2( damage_model, "hp" );
        local hp_difference = max_hp - current_hp;
        local target_recovery = EntityGetVariableNumber( player_entity, "gkbrkn_max_health_recovery", 0.0 );
        if HasFlagPersistent( MISC.HealOnMaxHealthUp.EnabledFlag ) and target_recovery < 1.0 then
            target_recovery = 1.0;
        end
        if HasFlagPersistent( MISC.HealOnMaxHealthUp.FullHealFlag ) then
            target_recovery = 10000.0;
        end
        local gained_hp = (max_hp - last_max_hp[ damage_model ]) * target_recovery;
        if gained_hp > 0 then
            gained_hp = math.min( gained_hp, hp_difference );
            ComponentSetValue2( damage_model, "hp", current_hp + gained_hp );
            if math.ceil( gained_hp ) ~= 0 then
                GamePrint( "Regained "..math.ceil( gained_hp * 25 ).." health" );
            end
        end
        last_max_hp[ damage_model ] = max_hp;
    end
end

--[[ Quick Swap ]]
-- TODO definitely needs more work
if HasFlagPersistent( MISC.QuickSwap.EnabledFlag ) then
    local controls = EntityGetFirstComponent( player_entity, "ControlsComponent" );
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" );
    if controls ~= nil and inventory2 ~= nil then
        local active_item = ComponentGetValue2( inventory2, "mActiveItem" );
        if active_item == nil or active_item == 0 or EntityHasTag( active_item, "wand" ) == true then
            local use_button = ComponentGetValue2( controls, "mButtonDownThrow" );
            local use_button_frame = ComponentGetValue2( controls, "mButtonFrameThrow" );
            if use_button == true and now == use_button_frame then
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

--[[
if false then
    local controls = EntityGetFirstComponent( player_entity, "ControlsComponent" );
    if controls ~= nil then
        local VELOCITY_MAPPING = {
            mButtonDownLeft = {x = -1.0, y=0.0},
            mButtonDownRight = {x = 1.0, y=0.0},
            mButtonDownUp = {x = 0.0, y=-1.0},
            mButtonDownDown = {x = 0.0, y=1.0},
        }
        local fly_button = ComponentGetValue2( controls, "mButtonDownJump" );
        local fly_button_frame = ComponentGetValue2( controls, "mButtonFrameJump" );
        if fly_button and fly_button_frame == GameGetFrameNum() then
            local character_platforming = EntityGetFirstComponent( player_entity, "CharacterPlatformingComponent" );
            if character_platforming then
                ComponentSetValue2( character_platforming, "fly_speed_max_up", 0 );
                ComponentSetValue2( character_platforming, "fly_model_player", false );
            end
            local character_data = EntityGetFirstComponent( player_entity, "CharacterDataComponent" );
            if character_data then
                local vx, vy = ComponentGetValue2( character_data, "mVelocity" );
                local intended_movement_vector = { x=0, y=0 };
                for button,vector in pairs(VELOCITY_MAPPING) do
                    local is_down = ComponentGetValue2( controls, button );
                    if is_down then
                        intended_movement_vector.x = intended_movement_vector.x + vector.x;
                        intended_movement_vector.y = intended_movement_vector.y + vector.y;
                    end
                end
                ComponentSetValue2( character_data, "mVelocity", vx + intended_movement_vector.x * 300, vy + intended_movement_vector.y * 300 );
            end
        end
    end
end
]]

--[[ Auto-collect Gold ]]
if HasFlagPersistent( MISC.AutoPickupGold.EnabledFlag ) then
    local gold_nuggets = EntityGetWithTag( "gold_nugget" ) or {};
    for _,gold_nugget in pairs( gold_nuggets ) do
        if EntityHasTag( gold_nugget, "gkbrkn_special_goldnugget" ) == false then
            EntitySetTransform( gold_nugget, x, y );
            break;
        end
    end
end

--[[ Gold Tracking ]]
local gold_tracker_world = HasFlagPersistent( MISC.GoldPickupTracker.ShowTrackerFlag );
local gold_tracker_message = HasFlagPersistent( MISC.GoldPickupTracker.ShowMessageFlag );
if gold_tracker_world or gold_tracker_message then
    last_money = last_money or 0;
    money_picked_total = money_picked_total or 0;
    money_picked_time_last = money_picked_time_last or 0;
    local update_tracker = false;

    local wallet = EntityGetFirstComponent( player_entity, "WalletComponent" );
    if wallet ~= nil then
        local money = ComponentGetValue2( wallet, "money" );
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
                local amount_text = "$"..tostring( thousands_separator(money_picked_total) );
                EntityAddChild( player_entity, text );
                EntityAddComponent( text, "SpriteComponent", {
                    _tags="enabled_in_world",
                    image_file="mods/gkbrkn_noita/files/gkbrkn/font/font_small_numbers_gold.xml" ,
                    emissive="1",
                    is_text_sprite="1",
                    offset_x=tostring( #amount_text * 2 ),
                    offset_y="-6" ,
                    update_transform="1" ,
                    update_transform_rotation="0",
                    text=amount_text,
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

if now % 1 == 0 then
	local world_entity_id = GameGetWorldStateEntity();
    local world_state = EntityGetFirstComponent( world_entity_id, "WorldStateComponent" );
    local is_gold_forever = false;
    if world_state ~= nil then
        is_gold_forever = ComponentGetValue2( world_state, "perk_gold_is_forever" );
    end
    local gold_nuggets = EntityGetWithTag( "gold_nugget" ) or {};
    for _,gold_nugget in pairs( gold_nuggets ) do
        --[[ Persistent Gold ]]
        if HasFlagPersistent( MISC.PersistentGold.EnabledFlag ) then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            if lifetime_component ~= nil then
                EntityRemoveComponent( gold_nugget, lifetime_component );
            end
        end
        
        --[[ Lost Treasure ]]
        if is_lost_treasure( gold_nugget ) == false then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            -- don't track gold nuggets that won't despawn naturally
            if lifetime_component ~= nil then
                set_lost_treasure( gold_nugget );
            end
        end
            
        --[[ Gold Decay ]]
        if HasFlagPersistent( MISC.GoldDecay.EnabledFlag ) and is_gold_decay( gold_nugget ) == false then
            local lifetime_component = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
            if lifetime_component ~= nil then
                set_gold_decay( gold_nugget );
            end
        end
    end

    --[[ Combine Gold ]]
     if HasFlagPersistent( MISC.CombineGold.EnabledFlag ) then
        local nugget_sizes = { 10, 50, 200, 1000, 10000 };
        SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() );
        for _,gold_nugget in pairs( gold_nuggets ) do
            if EntityGetIsAlive( gold_nugget ) then
                local x, y = EntityGetTransform( gold_nugget );
                local nearby_gold_nuggets = EntityGetInRadiusWithTag( x, y, 64, "gold_nugget" );
                if #nearby_gold_nuggets > 1 then
                    local nearby_gold_nugget = EntityGetInRadiusWithTag( x, y, 64, "gold_nugget" )[1];
                    while nearby_gold_nugget == gold_nugget and #nearby_gold_nuggets > 1 do
                        nearby_gold_nugget = nearby_gold_nuggets[ Random() ];
                    end
                    if nearby_gold_nugget ~= gold_nugget and EntityGetIsAlive( nearby_gold_nugget ) then
                        local gold_value = 0;
                        local hp_value = 0;
                        local creation_frame = 0;
                        local kill_frame = 0;
                        local nuggets_to_combine = { gold_nugget, nearby_gold_nugget };
                        for _,nugget in pairs(nuggets_to_combine) do
                            local components = EntityGetComponent( nugget, "VariableStorageComponent" ) or {};
                            for _,component in pairs( components ) do 
                                if ComponentGetValue2( component, "name" ) == "gold_value" then
                                    gold_value = gold_value + ComponentGetValue2( component, "value_int" );
                                end
                                if ComponentGetValue2( component, "name" ) == "hp_value" then
                                    hp_value = hp_value + ComponentGetValue2( component, "value_float" );
                                end
                            end
                            local lifetime = EntityGetFirstComponent( nugget, "LifetimeComponent" );
                            if lifetime ~= nil then
                                kill_frame  = kill_frame + ComponentGetValue2( lifetime, "kill_frame" );
                                creation_frame  = creation_frame + ComponentGetValue2( lifetime, "creation_frame" );
                            end
                            clear_lost_treasure( nugget );
                            clear_gold_decay( nugget );
                            EntityKill( nugget );
                        end
                        gold_value = gold_value;
                        hp_value = hp_value;
                        creation_frame = math.ceil( creation_frame / 2 );
                        kill_frame = math.ceil( kill_frame / 2 );
                        local new_size = 10;
                        for i=2,#nugget_sizes do
                            local size = nugget_sizes[i];
                            if gold_value >= size then
                                new_size = size;
                            end
                        end
                        -- make new nug
                        if hp_value > 0 then
                            gold_nugget = EntityLoad( "data/entities/items/pickup/bloodmoney_"..new_size..".xml", x, y );
                        else
                            gold_nugget = EntityLoad( "data/entities/items/pickup/goldnugget_"..new_size..".xml", x, y );
                        end
                        local components = EntityGetComponent( gold_nugget, "VariableStorageComponent" ) or {};
                        for _,component in pairs( components ) do 
                            if gold_value and ComponentGetValue2( component, "name" ) == "gold_value" then
                                ComponentSetValue2( component, "value_int", gold_value );
                            end
                            if hp_value and ComponentGetValue2( component, "name" ) == "hp_value" then
                                ComponentSetValue2( component, "value_float", hp_value );
                            end
                        end
                        local lifetime = EntityGetFirstComponent( gold_nugget, "LifetimeComponent" );
                        if lifetime then
                            if is_gold_forever then
                                EntityRemoveComponent( gold_nugget, lifetime );
                            else 
                                if kill_frame ~= 0 and creation_frame ~= 0 then
                                    ComponentSetValue2( lifetime, "kill_frame", kill_frame );
                                    ComponentSetValue2( lifetime, "creation_frame", creation_frame );
                                else
                                    EntityRemoveComponent( gold_nugget, lifetime );
                                end
                            end
                        end
                        local item = EntityGetFirstComponent( gold_nugget, "ItemComponent" );
                        if item ~= nil then
                            if hp_value > 0 then
                                ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot("$item_bloodmoney").." ("..gold_value..")" );
                            else
                                ComponentSetValue2( item, "item_name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..gold_value..")" );
                            end
                        end

                        local ui_info = EntityGetFirstComponent( gold_nugget, "UIInfoComponent" );
                        if ui_info ~= nil then
                            if hp_value > 0 then
                                ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot("$item_bloodmoney").." ("..gold_value..")" );
                            else
                                ComponentSetValue2( ui_info, "name", GameTextGetTranslatedOrNot("$item_goldnugget").." ("..gold_value..")" );
                            end
                        end
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
    local current_succ_bonus = ComponentGetValue2( succ_bonus, "value_string" );
    local children = EntityGetAllChildren( player_entity );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            for _,item in pairs( EntityGetAllChildren( child ) or {} ) do
                local components = EntityGetAllComponents( item ) or {};
                for _,component in pairs(components) do
                    if ComponentGetTypeName( component ) == "MaterialSuckerComponent" then
                        local succ_size = ComponentGetValue2( component, "barrel_size" );
                        if succ_size ~= nil then
                            local item_succ_bonus = EntityGetFirstComponent( item, "VariableStorageComponent", "gkbrkn_material_compression" );
                            if item_succ_bonus == nil then
                                item_succ_bonus = EntityAddComponent( item, "VariableStorageComponent", {
                                    _tags="gkbrkn_material_compression,enabled_in_hand,enabled_in_inventory,enabled_in_world",
                                    value_string="0"
                                });
                            end
                            local item_current_succ_bonus = ComponentGetValue2( item_succ_bonus, "value_string" );
                            local succ_bonus_difference = current_succ_bonus - item_current_succ_bonus;
                            if succ_bonus_difference > 0 then
                                local new_succ_size = succ_size * math.pow( 2, succ_bonus_difference );
                                local succ_size_difference = new_succ_size - succ_size;
                                ComponentSetValue2( component, "barrel_size", new_succ_size );
                                ComponentSetValue2( item_succ_bonus, "value_string", current_succ_bonus );

                                local material_inventory = EntityGetFirstComponentIncludingDisabled(item, "MaterialInventoryComponent");
                                if material_inventory ~= nil and ComponentGetValue2 then
                                    local count_per_material_type = ComponentGetValue2( material_inventory, "count_per_material_type");
                                    for k,v in pairs(count_per_material_type) do
                                        if v ~= 0 then
                                            local ratio = v / succ_size;
                                            local amount_to_add = new_succ_size * ratio;
                                            AddMaterialInventoryMaterial( item, CellFactory_GetName(k-1), amount_to_add );
                                        end
                                    end
                                end
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
                    ComponentSetValue2( item, "preferred_inventory", "FULL" );
                end
            end
        end
    end
]]

--[[ Health Bars ]]
if HasFlagPersistent( MISC.HealthBars.EnabledFlag ) then
    if HasFlagPersistent( MISC.HealthBars.PrettyHealthBarsFlag ) then
        local nearby_mortal = EntityGetInRadiusWithTag( x, y, 512, "mortal" );
        local t = GameGetRealWorldTimeSinceStarted();
        for _,nearby in pairs( nearby_mortal ) do
            if EntityHasTag( nearby, "homing_target" ) and EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil then
                entity_draw_health_bar( nearby, 1 );
            end
        end
    else
        if now % 10 == 0 then
            local nearby_mortal = EntityGetInRadiusWithTag( x, y, 512, "mortal" );
            for _,nearby in pairs( nearby_mortal ) do
                if EntityHasTag( nearby, "homing_target" ) and EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil then
                    if entity_get_health_ratio( nearby ) < 1 then
                        add_entity_mini_health_bar( nearby );
                    end
                end
            end
        end
    end
end

if now % 10 == 0 then
    local nearby_enemies = EntityGetWithTag( "enemy" );
    --[[ Champions ]]
    if GameHasFlagRun( MISC.ChampionEnemies.EnabledFlag ) then
        for _,nearby in pairs( nearby_enemies ) do
            SetRandomSeed( now, x + y + nearby );

            --SetRandomSeed( x, y );
            if EntityHasTag( nearby, "polymorphed" ) == false and EntityHasNamedVariable( nearby, "goki_health" ) == false then
                if ( EntityHasTag( nearby, "gkbrkn_champions" ) == false or EntityHasTag( nearby, "gkbrkn_force_champion" ) == true ) and EntityHasTag( nearby, "gkbrkn_no_champion" ) == false and EntityHasTag( nearby, "drone_friendly" ) == false and does_entity_drop_gold( nearby ) == true then
                    if EntityHasTag( nearby, "gkbrkn_force_champion" ) or GameHasFlagRun( MISC.ChampionEnemies.AlwaysChampionsFlag ) or Random() <= MISC.ChampionEnemies.ChampionChance then
                        EntityAddTag( nearby, "gkbrkn_champions" );
                        EntityRemoveTag( nearby, "gkbrkn_force_champion" );
                        local is_mini_boss = false;
                        local kills = tonumber( StatsGetValue("enemies_killed") ) or 0;
                        if GameHasFlagRun( MISC.ChampionEnemies.MiniBossesFlag ) then
                            local next_mini_boss = tonumber( GlobalsGetValue( "gkbrkn_next_miniboss" ) ) or 0;
                            if kills >= next_mini_boss then
                                is_mini_boss = Random() <= MISC.ChampionEnemies.MiniBossChance;
                                if is_mini_boss == true then
                                    EntityAddTag( nearby, "gkbrkn_mini_boss" );
                                    GlobalsSetValue( "gkbrkn_next_miniboss", next_mini_boss + MISC.ChampionEnemies.MiniBossThreshold );
                                end
                            end
                        end

                        local valid_champion_types = {};
                        for index,champion_type_data in pairs( champion_types ) do
                            if (champion_type_data.validator == nil or champion_type_data.validator( nearby ) ~= false) then
                                table.insert( valid_champion_types, champion_type_data );
                            end
                        end

                        local champion_types_to_apply = 1;
                        local champions_encountered = tonumber( GlobalsGetValue( "gkbrkn_champion_enemies_encountered" ) ) or 0;
                        if GameHasFlagRun( MISC.ChampionEnemies.SuperChampionsFlag ) then
                            local extra_type_chance = MISC.ChampionEnemies.ExtraTypeChance + champions_encountered * 0.0012;
                            local random_roll = Random();
                            while random_roll <= extra_type_chance and champion_types_to_apply < #valid_champion_types do
                                champion_types_to_apply = champion_types_to_apply + 1;
                                extra_type_chance = extra_type_chance - random_roll;
                                random_roll = Random();
                            end
                        end

                        GlobalsSetValue( "gkbrkn_champion_enemies_encountered", champions_encountered + 1 );
                        
                        EntitySetVariableNumber( nearby, "gkbrkn_champion_modifier_amount", champion_types_to_apply );

                        local add_these_badges = {};

                        local apply_these_champion_types = {};
                        if is_mini_boss then
                            apply_these_champion_types = {
                                find_champion_type("damage_buff"),
                                find_champion_type("projectile_buff"),
                                find_champion_type("rapid_attack"),
                                find_champion_type("faster_movement"),
                                find_champion_type("armored"),
                                find_champion_type("jetpack"),
                                find_champion_type("reward"),
                                find_champion_type("burning"),
                            };
                            add_these_badges = {"mods/gkbrkn_noita/files/gkbrkn/champion_types/mini_boss/badge.xml"};
                        end

                        for i=1,math.min(#valid_champion_types, champion_types_to_apply) do
                            local champion_type_index = math.ceil( Random() * #valid_champion_types );
                            table.insert( apply_these_champion_types, valid_champion_types[ champion_type_index ] );
                            table.remove( valid_champion_types, champion_type_index );
                        end

                        --[[ Per champion type ]]
                        for _,champion_data in pairs( apply_these_champion_types ) do
                            if champion_data.badge ~= nil then
                                table.insert( add_these_badges, champion_data.badge );
                            end

                            --[[ Game Effects ]]
                            for _,game_effect in pairs( champion_data.game_effects or {} ) do
                                local effect = GetGameEffectLoadTo( nearby, game_effect, true );
                                if effect ~= nil then ComponentSetValue2( effect, "frames", -1 ); end
                            end

                            --[[ General Application ]]
                            if champion_data.apply ~= nil then
                                champion_data.apply( nearby );
                            end

                            --[[ Particle Emitter ]]
                            local particle_material = champion_data.particle_material;
                            if particle_material ~= nil then
                                local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/particles.xml" );
                                local emitter = EntityGetFirstComponent( emitter_entity, "ParticleEmitterComponent" );
                                if emitter ~= nil then
                                    ComponentSetValue2( emitter, "emitted_material_name", particle_material );
                                    EntityAddChild( nearby, emitter_entity );
                                end
                                ComponentSetValue2( emitter, "gravity", 0, -200 );
                            end

                            --[[ Mini-Boss Particle Emitter ]]
                            if is_mini_boss then
                                if particle_material ~= nil then
                                    local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/mini_boss_particles.xml" );
                                    EntityAddChild( nearby, emitter_entity );
                                end
                            end

                            --[[ Mini-Boss Health Bar ]]
                            if is_mini_boss and EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil then
                                add_entity_mini_health_bar( nearby );
                            end

                            --[[ Sprite Particle Emitter ]]
                            local sprite_particle_sprite_file = champion_data.sprite_particle_sprite_file;
                            if sprite_particle_sprite_file ~= nil then
                                local emitter_entity = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/sprite_particles.xml" );
                                local emitter = EntityGetFirstComponent( emitter_entity, "SpriteParticleEmitterComponent" );
                                if emitter ~= nil then
                                    ComponentSetValue2( emitter, "sprite_file", sprite_particle_sprite_file );
                                    EntityAddChild( nearby, emitter_entity );
                                end
                            end

                            --[[ Rewards Drop ]]
                            local has_reward_script = false;
                            for _,lua_component in pairs(EntityGetComponent(nearby,"LuaComponent")) do
                                if ComponentGetValue2( lua_component, "script_damage_received" ) == "mods/gkbrkn_noita/files/gkbrkn/champion_types/champion/damage_received.lua" then
                                    has_reward_script = true;
                                    break;
                                end
                            end
                            if not has_reward_script then
                                EntityAddComponent( nearby, "LuaComponent", {
                                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/champion/damage_received.lua"
                                });
                            end
                        end

                        if #add_these_badges > 0 then
                            local badges = EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/badges.xml" );
                            EntityAddChild( nearby, badges );
                            for _,badge_filepath in pairs( add_these_badges ) do
                                local badge = EntityCreateNew();
                                
                                local sprite = EntityAddComponent( badge, "SpriteComponent",{
                                    z_index="-9000",
                                    image_file=badge_filepath
                                });
                                ComponentSetValue2( sprite, "has_special_scale", true );
                                ComponentSetValue2( sprite, "z_index", -9000 );
                                EntityAddComponent( badge, "InheritTransformComponent",{
                                    only_position="1"
                                });
                                EntityAddChild( badges, badge );
                            end
                        end
                    else
                        EntityAddTag( nearby, "gkbrkn_no_champion" );
                    end
                end
            end
        end
    end

    --[[ Enemy Invincibility Frames ]]
    if GameHasFlagRun( FLAGS.EnemyInvincibilityFrames ) then
        for _,nearby in pairs( nearby_enemies ) do
            if not EntityHasTag( nearby, "gkbrkn_enemy_invincibility_frames" ) then
                EntityAddTag( nearby, "gkbrkn_enemy_invincibility_frames" )
                EntityAddComponent( nearby, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/invincibility_frames/damage_received.lua",
                });
            end
        end
    end

    --[[ Enemy Itangibility Frames ]]
    if GameHasFlagRun( FLAGS.EnemyIntangibilityFrames ) then
        for _,nearby in pairs( nearby_enemies ) do
            if not EntityHasTag( nearby, "gkbrkn_enemy_intangibility_frames" ) then
                EntityAddTag( nearby, "gkbrkn_enemy_intangibility_frames" );
                EntityAddComponent( nearby, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/champion_types/intangibility_frames/damage_received.lua",
                });
            end
        end
    end

    --[[ Custom Damage Numbers ]]
    if HasFlagPersistent( MISC.ShowDamageNumbers.EnabledFlag ) then
        local nearby_targets = EntityGetWithTag( "homing_target" );
        for _,target in pairs( nearby_targets ) do
            if EntityGetVariableNumber( target, "gkbrkn_custom_damage_numbers", 0 ) == 0 then
                EntitySetVariableNumber( target, "gkbrkn_custom_damage_numbers", 1 );
                EntityAddComponent( target, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/custom_damage_numbers.lua"
                });
            end
        end
    end

    --[[ Tweak - Blood Amount ]]
    if find_tweak("blood_amount") then
        for _,enemy in pairs( nearby_enemies ) do
            if EntityGetVariableNumber( enemy, "gkbrkn_blood_amount_tweak", 0 ) == 0 then
                EntitySetVariableNumber( enemy, "gkbrkn_blood_amount_tweak", 1 );
                EntityAddComponent( enemy, "LuaComponent", {
                    script_damage_received="mods/gkbrkn_noita/files/gkbrkn/misc/blood_tweak/projectile_damage_received.lua"
                } );
            end
        end
    end

    --[[ Entity Names ]]
    local nearby_mortal = EntityGetInRadiusWithTag( x, y, 512, "mortal" );
    if HasFlagPersistent( MISC.ShowEntityNames.EnabledFlag ) then
        for _,nearby in pairs( nearby_mortal ) do
            if EntityGetFirstComponent( nearby, "UIInfoComponent" ) == nil then
                EntityAddComponent( nearby, "UIInfoComponent", {
                    name=EntityGetName( nearby );
                });
            end
        end
    end

    --[[ Hero Mode Scaling ]]
    -- TODO find a better way to target enemies and bosses (dragon, pyramid, centipede)
    if GameHasFlagRun( MISC.HeroMode.EnabledFlag ) then
        local is_carnage_mode = GameHasFlagRun( MISC.HeroMode.CarnageDifficultyFlag );
        local speed_multiplier = 1.25;
        local critical_damage_resistance = 0.50;

        if is_carnage_mode then
            speed_multiplier = 2.0;
            critical_damage_resistance = 0.75;
        end

        local places_visited_multiplier = 1;
        local distance_multiplier = 1;
        if GameHasFlagRun( MISC.HeroMode.DistanceDifficultyFlag ) then
            places_visited_multiplier = tonumber( StatsGetValue("places_visited") );
            speed_multiplier = speed_multiplier + 0.05 * places_visited_multiplier;
            distance_multiplier = math.min( 1, math.pow( 0.85, places_visited_multiplier - 1 ) );
        end

        local orb_multiplier =  1;
        if GameHasFlagRun( MISC.HeroMode.OrbsDifficultyFlag ) then
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
            player_herd = ComponentGetValue2( player_genome, "herd_id" );
        end
        for _,nearby in pairs( nearby_enemies ) do
            if EntityGetVariableNumber( nearby, "gkbrkn_hero_mode", 0.0 ) == 0 and EntityHasNamedVariable( nearby, "goki_health" ) == false then
                EntitySetVariableNumber( nearby, "gkbrkn_hero_mode", 1.0 );
                local damage_models = EntityGetComponent( nearby, "DamageModelComponent" ) or {};
                if #damage_models > 0 then

                    local general_resistances = 1.00;
                    if is_carnage_mode then general_resistances = 0.50; end

                    local resistances = {
                        ice = general_resistances,
                        electricity = general_resistances,
                        radioactive = general_resistances,
                        slice = general_resistances,
                        projectile = general_resistances,
                        --healing = general_resistances,
                        physics_hit = general_resistances * 0.2,
                        explosion = general_resistances,
                        poison = general_resistances,
                        melee = general_resistances,
                        drill = general_resistances,
                        fire = general_resistances,
                    };

                    local resistance_multiplier = orb_multiplier * distance_multiplier;
                    for index,damage_model in pairs( damage_models ) do
                        for damage_type,multiplier in pairs( resistances ) do
                            local resistance = ComponentObjectGetValue2( damage_model, "damage_multipliers", damage_type );
                            resistance = resistance * multiplier * resistance_multiplier;
                            ComponentObjectSetValue2( damage_model, "damage_multipliers", damage_type, resistance );
                        end
                        if critical_damage_resistance ~= 1.0 then
                            ComponentSetValue2( damage_model, "critical_damage_resistance", critical_damage_resistance );
                        end
                    end

                    local attack_speed_divisor = 1.15 + 0.1 * places_visited_multiplier;
                    if is_carnage_mode then attack_speed_divisor = 1.80 + 0.2 * places_visited_multiplier; end

                    local animal_ais = EntityGetComponent( nearby, "AnimalAIComponent" ) or {};
                    if #animal_ais > 0 then
                        for _,ai in pairs( animal_ais ) do
                            ComponentSetValues( ai, {
                                aggressiveness_min=100,
                                aggressiveness_max=100,
                                escape_if_damaged_probability=0,
                                attack_if_damaged_probability=100,
                                hide_from_prey=false,
                                needs_food=false,
                                sense_creatures=true,
                                attack_only_if_attacked=false,
                                dont_counter_attack_own_herd=true,
                                creature_detection_angular_range_deg=180,
                            });
                            ComponentAdjustValues( ai, {
                                attack_melee_frames_between=function(value) return math.ceil( tonumber( value ) / attack_speed_divisor ) end,
                                attack_dash_frames_between=function(value) return math.ceil( tonumber( value ) / attack_speed_divisor ) end,
                                attack_ranged_frames_between=function(value) return math.ceil( tonumber( value ) / attack_speed_divisor ) end,
                            });
                        end
                    end
                end
                local character_platforming = EntityGetFirstComponent( nearby, "CharacterPlatformingComponent" );
                if character_platforming ~= nil then
                    local fly_velocity_x = ComponentGetValue2( character_platforming, "fly_velocity_x" );
                    ComponentAdjustValues( character_platforming, {
                        jump_velocity_x         = function(value) return value * speed_multiplier; end,
                        jump_velocity_y         = function(value) return value * speed_multiplier; end,
                        fly_smooth_y            = function(value) return false end,
                        fly_speed_mult          = function(value) return fly_velocity_x * speed_multiplier end,
                        fly_speed_max_up        = function(value) return fly_velocity_x * speed_multiplier end,
                        fly_speed_max_down      = function(value) return fly_velocity_x * speed_multiplier end,
                        fly_speed_change_spd    = function(value) return fly_velocity_x * speed_multiplier end,
                        run_velocity            = function(value) return value * speed_multiplier; end,
                        fly_velocity_x          = function(value) return fly_velocity_x * speed_multiplier; end,
                        --velocity_max_x          = function(value) return value * speed_multiplier; end,
                    });
                end
            end
            --[[ Force enemies to aggress the player at all times
            -- only do it twice a second to reduce performance hit
            if now % 30 == 0 and EntityGetVariableNumber( nearby, "gkbrkn_hero_mode", 0.0 ) == 1 then
                local charmed = GameGetGameEffectCount( nearby, "CHARM" );
                if charmed < 1 or is_carnage_mode then
                    local nearby_genome = EntityGetFirstComponent( nearby, "GenomeDataComponent" );
                    local nearby_herd = -1;
                    if nearby_genome ~= nil then
                        nearby_herd = ComponentGetValue2( nearby_genome, "herd_id" );
                        if player_herd ~= nearby_herd then
                            local animal_ais = EntityGetComponent( nearby, "AnimalAIComponent" ) or {};
                            for _,ai in pairs( animal_ais ) do
                                if ComponentGetValue2( ai, "tries_to_ranged_attack_friends" ) ~= false then
                                    ComponentSetValue2( ai, "mGreatestPrey", player_entity );
                                end
                            end
                        end
                    end
                end
            end
            ]]
        end
        
        for _,boss in pairs( EntityGetWithTag( "boss_centipede_active" ) or {} ) do
            if EntityGetVariableNumber( boss, "gkbrkn_hero_mode_boss", 0 ) == 0 then
                EntitySetVariableNumber( boss, "gkbrkn_hero_mode_boss", 1 );
                TryAdjustMaxHealth( boss, function( max, current ) return max + 400; end );
            end
        end
    end
end

--[[ Blood Magic ]]
if HasFlagPersistent( FLAGS.ShowDeprecatedContent ) then
    local blood_magic_stacks = EntityGetVariableNumber( player_entity, "gkbrkn_blood_magic_stacks", 0 );
    local blood_to_mana_ratio = MISC.PerkOptions.BloodMagic.BloodToManaRatio * blood_magic_stacks;
    if blood_magic_stacks ~= 0 then
        if #wands > 0 then
            local recoverable_mana = 0;
            for _,wand in pairs( wands ) do
                if tonumber( wand ) ~= tonumber( active_wand ) then
                    local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
                    if ability ~= nil then
                        ComponentSetValue2( ability, "mana", 0 );
                    end
                end
            end
            local mana = 0;
            local adjusted_mana_max = 0;
            local last_mana_health_pool = tonumber( EntityGetVariableNumber( player_entity, "gkbrkn_mana_health_pool", nil ) );
            local last_mana_health_pool_amount = tonumber( EntityGetVariableNumber( player_entity, "gkbrkn_mana_health_pool_amount", 0 ) );
            if active_wand ~= nil then
                local ability = WandGetAbilityComponent( active_wand, "AbilityComponent" );
                if ability ~= nil then
                    mana = ComponentGetValue2( ability, "mana" );
                    adjusted_mana_max = ComponentGetValue2( ability, "mana_max" ) / 25;
                    if mana > 0 then
                        recoverable_mana = recoverable_mana + mana;
                        ComponentSetValue2( ability, "mana", 0 );
                    end
                end
            end
            if last_mana_health_pool ~= active_wand then
                EntitySetVariableNumber( player_entity, "gkbrkn_mana_health_pool", active_wand );
                EntitySetVariableNumber( player_entity, "gkbrkn_mana_health_pool_amount", adjusted_mana_max );
                entity_adjust_health( player_entity, function( max_hp, hp )
                    local new_max_hp = max_hp - last_mana_health_pool_amount + adjusted_mana_max;
                    return new_max_hp, math.min( hp, new_max_hp );
                end );
            end
            if recoverable_mana ~= 0 then
                local recovery_rate_adjustment = math.min( 1, ( GameGetFrameNum() - EntityGetVariableNumber( player_entity, "gkbrkn_last_frame_damaged", 0 ) ) / 180 ) ^ 2;
                for _,damage_model in pairs( damage_models ) do
                    local hp = ComponentGetValue2( damage_model, "hp" );
                    local max_hp = ComponentGetValue2( damage_model, "max_hp" );
                    local new_hp = math.min( max_hp, hp + recoverable_mana * blood_to_mana_ratio / 25 * recovery_rate_adjustment );
                    ComponentSetValue2( damage_model, "hp", new_hp );
                    -- TODO when we can deal damage we won't need this
                    if new_hp <= 0 then
                        EntityKill( player_entity );
                    end
                end
            end
        end
    end
end

--[[ Less Particles ]]
if HasFlagPersistent( MISC.LessParticles.OtherStuffFlag ) then
    local nearby_entities = EntityGetInRadius( x, y, 256 );
    local disable = HasFlagPersistent( MISC.LessParticles.DisableCosmeticsFlag );
    _less_particle_entity_cache = _less_particle_entity_cache or {};
    for _,nearby in pairs( nearby_entities ) do
        if _less_particle_entity_cache[nearby] ~= true then
            _less_particle_entity_cache[nearby] = true;
            reduce_particles( nearby, disable );
        end
    end
end

dofile("mods/gkbrkn_noita/files/gkbrkn/misc/projectile_capture.lua");

--[[ Tweak - Shorten Blindness ]]
if find_tweak("blindness") then
    local blindness = GameGetGameEffectCount( player_entity, "BLINDNESS" );
    if blindness > 0 then
        local effect = GameGetGameEffect( player_entity, "BLINDNESS" );
        local frames = ComponentGetValue2( effect, "frames" );
        if frames > 600 then
            ComponentSetValue2( effect, "frames", 600 );
        end
    end
end

--[[ Game Modifier - Floor is Lava ]]
if GameHasFlagRun( FLAGS.FloorIsLava ) and now % 10 == 0 then
    local character_data = EntityGetFirstComponent( player_entity, "CharacterDataComponent" );
    if character_data ~= nil then
        local is_on_ground = ComponentGetValue2( character_data, "is_on_ground" );
        if is_on_ground == "1" then
            EntityInflictDamage( player_entity, 5/25, "DAMAGE_FIRE", "Floor is Lava", "NORMAL", 0, 0 );
        end
    end
end

--[[ Game Modifier - Infinite Flight ]]
if GameHasFlagRun( FLAGS.InfiniteFlight ) then
    local character_data = EntityGetFirstComponent( player_entity, "CharacterDataComponent" );
    if character_data ~= nil then
        ComponentSetValue2( character_data, "flying_needs_recharge", false );
    end
end

--[[ Game Modifier - Keep Moving ]]
old_position = old_position;
if GameHasFlagRun( FLAGS.KeepMoving ) then
    if GameGetFrameNum() > 180 and now % 15 == 0 then
        if old_position ~= nil then
            local death_barrier = EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/death_barrier.xml", old_position.x, old_position.y );
        end
        old_position = {x=x, y=y};
    end
end

if now % 60 == 0 then
    local world_wands = EntityGetWithTag( "wand" );

    --[[ Remove annoying edit wand prompt ]]
    if HasFlagPersistent( MISC.RemoveEditPrompt.EnabledFlag ) then
        local workshops = EntityGetWithTag( "workshop_untouched" );
        for _,workshop in pairs(workshops or {}) do
            EntityRemoveTag( workshop, "workshop_untouched" );
        end
    end

    --[[ Remove wands that aren't marked as special ]]
    if GameHasFlagRun( FLAGS.RemoveGenericWands ) then
        for _,wand in pairs( world_wands ) do
            local wand_parent = EntityGetParent( wand )
            local wand_holder = EntityGetParent( wand_parent );
            if wand_parent == 0 or wand_parent == nil or wand_holder == player_entity then
                if not wand_is_special( wand ) then
                    EntityKill( wand );
                end
            end
        end
    end

    --[[ Game Modifier - No-edit ]]
    if GameHasFlagRun( FLAGS.NoWandEditing ) then
        for _,wand in pairs( world_wands ) do
            if EntityGetVariableNumber( wand, "gkbrkn_no_edit", nil ) == nil then
                EntitySetVariableNumber( wand, "gkbrkn_no_edit", 1 )
                local wand_children = EntityGetAllChildren( wand ) or {};
                for _,child in pairs( wand_children ) do
                    local component = EntityGetFirstComponentIncludingDisabled( child, "ItemComponent" );
                    if component ~= nil then
                        ComponentSetValue2( component, "is_frozen", true );
                    end
                end
            end
            local component = EntityGetFirstComponentIncludingDisabled( wand, "ItemComponent" );
            if component ~= nil then
                ComponentSetValue2( component, "is_frozen", true );
            end
        end
    end
end

add_update_time( GameGetRealWorldTimeSinceStarted() - t );