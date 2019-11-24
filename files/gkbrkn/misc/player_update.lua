local t = GameGetRealWorldTimeSinceStarted();
local now = GameGetFrameNum();

if _ONCE == nil then
    _ONCE = true;
    dofile( "files/gkbrkn/helper.lua" );
    dofile( "files/gkbrkn/config.lua" );
    dofile( "files/gkbrkn/lib/variables.lua" );
    function DoFileEnvironment( filepath, environment )
        if environment == nil then environment = {} end
        local status,result = pcall( setfenv( loadfile( filepath ), setmetatable( environment, { __index = getfenv() } ) ) );
        if status == false then print_error( result ); end
        return environment;
    end
    function IsGoldNuggetLostTreasure( entity )
        return EntityGetFirstComponent( entity, "LuaComponent", "gkbrkn_lost_treasure" ) ~= nil
    end
    function IsGoldNuggetDecayTracked( entity )
        return EntityGetFirstComponent( entity, "LuaComponent", "gkbrkn_gold_decay" ) ~= nil;
    end
end

local entity = GetUpdatedEntityID();
local children = EntityGetAllChildren( entity ) or {};

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
if HasFlagPersistent( MISC.PassiveRecharge.Enabled ) then
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
                ComponentSetValue( ability, "mReloadFramesLeft", tostring( reload_frames_left - 1  ) );
            end
        end
    end
end

--[[ Heal New Health ]]
if last_max_hp == nil then
    last_max_hp = {};
end
local entity = GetUpdatedEntityID();
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
if HasFlagPersistent( MISC.QuickSwap.Enabled ) then
    local controls = EntityGetFirstComponent( entity, "ControlsComponent" );
    local inventory2 = EntityGetFirstComponent( entity, "Inventory2Component" );
    if controls ~= nil and inventory2 ~= nil then
        local active_item = ComponentGetValue( inventory2, "mActiveItem" );
        if active_item == nil or EntityHasTag( active_item, "wand" ) == true then
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
                    z_index="1.6",
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
local x, y = EntityGetTransform( entity );
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

local update_time = GameGetRealWorldTimeSinceStarted() - t;
GlobalsSetValue("gkbrkn_update_time",update_time);