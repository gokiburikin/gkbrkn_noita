if not ModIsEnabled("gkbrkn_noita") then return end
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
--##DEV local STATS = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/wands.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/cheats.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )

-- TODO a lot of this stuff should be its own scripts attached to the player when they are activated
-- realistically the time spent in this file is very small so it's not necessary and will
-- not help with frame rate but it is still wasteful

--##DEV local t = GameGetRealWorldTimeSinceStarted()
local now = GameGetFrameNum()

local player_entity = GetUpdatedEntityID()

local x, y = EntityGetTransform( player_entity )
local vx, vy = ComponentGetValue2( EntityGetFirstComponent( player_entity, "CharacterDataComponent" ), "mVelocity" )

local _inventory_quick = nil
local get_inventory_quick = function()
    if _inventory_quick then return _inventory_quick end
    local children = EntityGetAllChildren( player_entity ) or {}
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            _inventory_quick = child
            return child
        end
    end
end

local get_active_item = function()
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" )
    if not inventory2 then return end
    return ComponentGetValue2( inventory2, "mActiveItem" )
end

local get_wands = function()
    return EntityGetChildrenWithTag( get_inventory_quick(), "wand" ) or {}
end

-- Hacks fix for loadout management
-- TODO replace with a SetTimeOut
if GameHasFlagRun( FLAGS.DelayInit ) and now == tonumber( GlobalsGetValue("gkbrkn_delay_init_frame","0") ) then
    DoFileEnvironment( "mods/gkbrkn_noita/files/gkbrkn/misc/random_start/init.lua", { player_entity = player_entity } )
    if GameHasFlagRun( FLAGS.FixLoadoutIntegration ) then
        for _,item in pairs( EntityGetAllChildren( inventory_quick ) ) do
            EntityRemoveFromParent( item )
            GamePickUpInventoryItem( player_entity, item, false )
        end
    end
end

--try_parse_setting_changes()

--[[ Stray Pixel Cleanup ]]
function no_pixels_in_rect( x1, y1, x2, y2 )
    for y=y1,y2,1 do
        local d, _, _ = RaytracePlatforms( x1, y, x2, y )
        if d then
            return false
        end
    end
    return true
end

function no_pixels_in_border( x1, y1, x2, y2 )
    local d, _, _ = RaytracePlatforms( x1, y1, x2, y1 )
    if d then return false end
    d, _, _ = RaytracePlatforms( x1, y2, x2, y2 )
    if d then return false end
    d, _, _ = RaytracePlatforms( x1, y1, x1, y2 )
    if d then return false end
    d, _, _ = RaytracePlatforms( x2, y1, x2, y2 )
    if d then return false end
    return true
end

-- Thanks to Binary Wolf for the removal code
function delete_area( x, y, radius )
    local ent = EntityCreateNew()
    EntitySetTransform(ent, x, y)
    EntityAddComponent2(ent, "CellEaterComponent", {
        ["radius"] = radius,
        ["eat_dynamic_physics_bodies"] = true,
        ["ignored_material_tag"] = "[box2d]"
    })
    EntityAddComponent2(ent, "MagicConvertMaterialComponent", {
        ["radius"] = radius,
        ["temperature_reaction_temp"] = 100,
        ["kill_when_finished"] = false
    })
    EntityAddComponent2(ent, "LifetimeComponent", {
        ["lifetime"] = 2
    })
end

function stray_pixel_cleanup( x, y, r, show )
    local s = "data/ui_gfx/1px_white.png"
    if no_pixels_in_border( math.floor(x - r), math.floor(y - r), math.floor(x + r), math.floor(y + r)) and
    not no_pixels_in_rect( math.floor(x - r), math.floor(y - r), math.floor(x + r), math.floor(y + r)) then
        s = "data/ui_gfx/cross_red.png"
        delete_area( x, y, r )
        return true
    end
    if show == true then
        GameCreateSpriteForXFrames(s, math.floor(x - r), math.floor(y - r), true, 0, 0, 1, true)
        GameCreateSpriteForXFrames(s, math.floor(x + r), math.floor(y - r), true, 0, 0, 1, true)
        GameCreateSpriteForXFrames(s, math.floor(x - r), math.floor(y + r), true, 0, 0, 1, true)
        GameCreateSpriteForXFrames(s, math.floor(x + r), math.floor(y + r), true, 0, 0, 1, true)
    end
    return false
end

local stray_pixel_radius = setting_get( MISC.StrayPixelCleanup.RadiusFlag, 0 )
if stray_pixel_radius > 0 then
    stray_pixel_cleanup( x + vx * 0.1, y - 8 + vy * 0.1, now % stray_pixel_radius + 1 )
end

-- Used by multiple things below
local damage_models = EntityGetComponent( player_entity, "DamageModelComponent" ) or {}

--[[ Invincibility Frames ]]
if setting_get( MISC.InvincibilityFrames.FlashingFlag, false ) then
    local max_invincibility_frames = 0
    for _,damage_model in pairs( damage_models ) do
        local invincibility_frames = ComponentGetValue2( damage_model, "invincibility_frames" )
        if invincibility_frames > max_invincibility_frames then
            max_invincibility_frames = invincibility_frames
        end
    end

    if max_invincibility_frames > 0 then
        local sprites = {}
        local children = { player_entity }
        for _,child in pairs( children ) do
            local child_sprites = EntityGetComponent( child, "SpriteComponent" )
            if child_sprites ~= nil and #child_sprites > 0 then
                for _,sprite in pairs( child_sprites ) do
                    table.insert( sprites, sprite )
                end
            end

            local child_children = EntityGetAllChildren( child )
            if child_children ~= nil and #child_children > 0 then
                for _,child_child in pairs(child_children ) do
                    table.insert( children, child_child )
                end
            end
        end

        local alpha = math.floor( now / 2 ) % 2
        if max_invincibility_frames == 1 then
            alpha = 1
        end
        
        for _,sprite in pairs( sprites ) do
            ComponentSetValue2( sprite, "alpha", alpha )
        end
    end
end

--[[ Cheat - Infinite Flight ]]
if setting_get( "cheat_infinite_flight", false ) then
    local character_data = EntityGetFirstComponent( player_entity, "CharacterDataComponent" )
    if character_data ~= nil then
        --ComponentSetValue2( character_data, "flying_needs_recharge", false )
        ComponentSetValue2( character_data, "mFlyingTimeLeft", ComponentGetValue2( character_data, "fly_time_max" ) )
    end
end

--[[ Infinite Money ]]
if setting_get( "cheat_infinite_money", false ) then
    local wallet = EntityGetFirstComponent( player_entity, "WalletComponent" )
    if wallet then
        ComponentSetValue2( wallet, "money", 2000000000 )
    end
end

--[[ Cheap Rerolls ]]
if setting_get( "cheat_cheap_rerolls", false ) then
    GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", "-1" )
end

--[[ Spell Recovery ]]
if setting_get( "cheat_infinite_spells", false ) or GameHasFlagRun( FLAGS.UnlimitedAmmo ) then
    -- This can cause wand reseting though i'm not sure why it suddenly started happening
    --GameRegenItemActionsInPlayer( player_entity )
    for _,card in pairs(EntityGetWithTag( "card_action" )) do
        local item = EntityGetFirstComponentIncludingDisabled( card, "ItemComponent" )
        if item then
            ComponentSetValue2(item, "uses_remaining", -2 )
        end
    end
end

--[[ Invincibility ]]
if setting_get( "cheat_invincibility", false ) then
    for _,damage_model in pairs( damage_models ) do
        ComponentSetValue2( damage_model, "invincibility_frames", 2 )
    end
end

--[[ No Polymorph ]]
if setting_get( "cheat_no_polymorph", false ) then
    EntityAddTag( player_entity, "polymorphable_NOT" )
else
    EntityRemoveTag( player_entity, "polymorphable_NOT" )
end

--[[ Health Recovery ]]
if setting_get( "cheat_recover_health", false ) then
    for _,damage_model in pairs( damage_models ) do
        local hp = ComponentGetValue2( damage_model, "hp" )
        local max_hp = ComponentGetValue2( damage_model, "max_hp" )
        ComponentSetValue2( damage_model, "hp", math.min( max_hp, hp + max_hp / 60.0 ) )
    end
end

--[[ Mana Recovery ]]
local mana_recovery = EntityGetVariableNumber( player_entity, "gkbrkn_mana_recovery", 0 )
if setting_get( "cheat_infinite_mana", false ) then
    mana_recovery = 9999
end

if mana_recovery ~= 0 then
    for _,wand in pairs( get_wands() ) do
        local ability = WandGetAbilityComponent( wand, "AbilityComponent" )
        if ability ~= nil then
            local mana = ComponentGetValue2( ability, "mana" )
            local max_mana = ComponentGetValue2( ability, "mana_max" )
            if mana < max_mana then
                ComponentSetValue2( ability, "mana", math.min( mana + mana_recovery, max_mana ) )
            end
        end
    end
end

--[[ No Damage Flashing ]]
if setting_get( FLAGS.NoDamageFlashing, false ) then
    local effect = GetGameEffectLoadTo( player_entity, "NO_DAMAGE_FLASH", true )
    if effect ~= nil and effect ~= 0 then ComponentSetValue2( effect, "frames", 2 ) end
end

--[[ Heal New Health ]]
-- TODO this might eventually need to be changed to variable storage
last_max_hp = last_max_hp or {}
for _,damage_model in pairs( damage_models ) do
    local max_hp = ComponentGetValue2( damage_model, "max_hp" )
    if last_max_hp[ damage_model ] == nil then
        last_max_hp[ damage_model ] = ComponentGetValue2( damage_model, "max_hp" )
    end
    if max_hp > last_max_hp[ damage_model ] then
        local current_hp = ComponentGetValue2( damage_model, "hp" )
        local hp_difference = max_hp - current_hp
        local gained_hp = 0
        local heal_on_max_hp = setting_get( MISC.HealOnMaxHealthUp.RangeFlag, 0 )
        if heal_on_max_hp == 2 then
            gained_hp = hp_difference
        else
            local recovery_percent = EntityGetVariableNumber( player_entity, "gkbrkn_max_health_recovery", 0.0 )
            if heal_on_max_hp > 0 and recovery_percent < 1.0 then
                recovery_percent = 1.0
            end
            gained_hp = (max_hp - last_max_hp[ damage_model ]) * recovery_percent
        end
        if gained_hp > 0 then
            gained_hp = math.min( gained_hp, hp_difference )
            ComponentSetValue2( damage_model, "hp", current_hp + gained_hp )
            if math.ceil( gained_hp ) ~= 0 then
                GamePrint("Regained "..math.ceil( gained_hp * 25 ).." health")
            end
        end
        last_max_hp[ damage_model ] = max_hp
    end
end

local controls = EntityGetFirstComponentIncludingDisabled( player_entity, "ControlsComponent" )
if setting_get( FLAGS.LockControlsWhenPanelOpen, false ) then
    if GlobalsGetValue( FLAGS.ConfigMenuOpen ) == "1" then
        ComponentSetValue2( controls, "enabled", false )
        for _,k in ipairs({"mButtonDownLeft","mButtonDownRight","mButtonDownUp","mButtonDownDown","mButtonDownFly"}) do
            ComponentSetValue2( controls, k, false )
        end
    else
        ComponentSetValue2( controls, "enabled", true )
    end
elseif GlobalsGetValue( "gkbrkn_enable_controls" ) == "1" then
    GlobalsSetValue( "gkbrkn_enable_controls", "0" )
    ComponentSetValue2( controls, "enabled", true )
end

--[[ Quick Swap ]]
if setting_get( MISC.QuickSwap.EnabledFlag, false ) then
    local controls = EntityGetFirstComponent( player_entity, "ControlsComponent" )
    if not controls then return end
    
    local inventory2 = EntityGetFirstComponent( player_entity, "Inventory2Component" )
    if not inventory2 then return end
    
    local active_item = ComponentGetValue2( inventory2, "mActiveItem" )
    if active_item == nil or active_item == 0 or ( EntityHasTag( active_item, "wand" ) == true or EntityGetFirstComponent( active_item, "PotionComponent" ) == nil) then
        local use_button = ComponentGetValue2( controls, "mButtonDownThrow" )
        local use_button_frame = ComponentGetValue2( controls, "mButtonFrameThrow" )
        if use_button == true and now == use_button_frame then
            local inventory = nil
            local swap_inventory = nil
            for _,child in pairs(EntityGetAllChildren( player_entity )) do
                if EntityGetName(child) == "inventory_quick" then
                    inventory = child
                elseif EntityGetName(child) == "gkbrkn_quick_swap_inventory" then
                    swap_inventory = child
                end
            end
            if swap_inventory == nil then
                swap_inventory = EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/quick_swap_entity.xml")
                EntityAddChild( player_entity, swap_inventory )
            end
            if inventory ~= nil and swap_inventory ~= nil then
                local inventory_entities = EntityGetAllChildren( inventory ) or {}
                local swap_inventory_entities = EntityGetAllChildren( swap_inventory ) or {}
                for _,child in pairs(inventory_entities) do EntityRemoveFromParent( child ) end
                for _,child in pairs(swap_inventory_entities) do EntityRemoveFromParent( child ) end
                for _,child in pairs(inventory_entities) do EntityAddChild( swap_inventory, child ) end
                for _,child in pairs(swap_inventory_entities) do EntityAddChild( inventory, child ) end
            end
        end
    end
end

--[[ Gold Tracking ]]
local gold_tracker_world = setting_get( MISC.GoldPickupTracker.ShowTrackerFlag, false )
local gold_tracker_message = setting_get( MISC.GoldPickupTracker.ShowMessageFlag, false )
if gold_tracker_world or gold_tracker_message then
    last_money = last_money or 0
    money_picked_total = money_picked_total or 0
    money_picked_time_last = money_picked_time_last or 0
    local update_tracker = false

    local wallet = EntityGetFirstComponent( player_entity, "WalletComponent" )
    if wallet ~= nil then
        local money = ComponentGetValue2( wallet, "money" ) or 0
        if money - last_money > 0 then
            money_picked_total = money_picked_total + money - last_money
            money_picked_time_last = now
            update_tracker = true
        end
        last_money = money
    end

    if money_picked_total > 0 then
        if gold_tracker_world then
            if update_tracker then
                local gold_text_sprite = EntityGetFirstComponent( player_entity, "SpriteComponent", "gkbrkn_gold_tracker" )
                if not gold_text_sprite then
                    gold_text_sprite = EntityAddComponent2( player_entity, "SpriteComponent", {
                        image_file = "mods/gkbrkn_noita/files/gkbrkn/font/font_small_numbers_gold.xml",
                        emissive = true,
                        is_text_sprite = true,
                        offset_x = 0,
                        offset_y = -6,
                        update_transform = true,
                        update_transform_rotation = false,
                        text = "",
                        has_special_scale = true,
                        special_scale_x = 0.6667,
                        special_scale_y = 0.6667,
                        z_index = -2
                    })
                    ComponentAddTag( gold_text_sprite, "gkbrkn_gold_tracker" )
                end
                if gold_text_sprite then
                    local amount_text = "$"..tostring( thousands_separator(money_picked_total) )
                    ComponentSetValue2( gold_text_sprite, "visible", true )
                    ComponentSetValue2( gold_text_sprite, "offset_x", #amount_text * 2 )
                    ComponentSetValue2( gold_text_sprite, "text", amount_text )
                    EntityRefreshSprite( player_entity, gold_text_sprite )
                end
            end
        end
        if now - money_picked_time_last >= MISC.GoldPickupTracker.TrackDuration then
            local gold_text_sprite = EntityGetFirstComponent( player_entity, "SpriteComponent", "gkbrkn_gold_tracker" )
            if gold_tracker_message then GamePrint("Picked up $"..money_picked_total) end
            if gold_text_sprite then ComponentSetValue2( gold_text_sprite, "visible", false ) end
            money_picked_total = 0
        end
    end
end

-- Auto-collect Gold
if setting_get( MISC.AutoPickupGold.EnabledFlag, false ) then
    for _,e in pairs(EntityGetWithTag("gold_nugget")) do
        EntityApplyTransform( e, EntityGetFirstHitboxCenter( player_entity ) )
    end
end

--[[ Heal Temple Statues 
if true then
    for _,entity in pairs(EntityGetWithTag("prop")) do
        local filepath = EntityGetFilename(entity)
        if filepath == "data/entities/props/temple_statue_01.xml" or filepath == "data/entities/props/temple_statue_02.xml" then
            local damage_model = EntityGetFirstComponentIncludingDisabled(entity,"DamageModelComponent")
            ComponentSetValue2( damage_model, "critical_hit_resistance", 0 )
            ComponentSetValue2( damage_model, "hp", 1200 )
        end
    end
end
]]

if setting_get( FLAGS.ShowWandScores, false ) then
    local wand_score_serialized = ""
    for _,e in pairs(EntityGetInRadiusWithTag( x, y, 32, "wand") or {}) do
        if EntityGetRootEntity( e ) == e then
            local s = get_wand_score( e )
            wand_score_serialized = wand_score_serialized .. tostring(e).."="..s..","
        end
    end
    ModSettingSet( "gkbrkn_wand_scores", wand_score_serialized )
end

last_emit_check = last_emit_check or 0
if now - last_emit_check >= 60 then
    last_emit_check = now
    local emit = false
    if GameHasFlagRun( MISC.HeroMode.OrbsDifficultyFlag ) and GameGetOrbCountThisRun() > tonumber( GlobalsGetValue( "gkbrkn_last_orbs_collected", "0" )) then
        GlobalsSetValue( "gkbrkn_last_orbs_collected", tostring(GameGetOrbCountThisRun()))
        emit = true
    end
    if GameHasFlagRun( MISC.HeroMode.DistanceDifficultyFlag ) and tonumber( StatsGetValue("places_visited") ) > tonumber(GlobalsGetValue( "gkbrkn_last_places_visited", "0" )) then
        GlobalsSetValue( "gkbrkn_last_places_visited", StatsGetValue("places_visited"))
        emit = true
    end
    if emit then
        GamePlaySound( "data/audio/Desktop/event_cues.snd", "event_cues/heartbeat/create", x, y )
        GamePrintImportant( "Your foes grow stronger")
    end
end

local has_entity_taken_damage = function( e )
    local dmg = EntityGetFirstComponent( e, "DamageModelComponent" )
    if not dmg then return false end
    return ComponentGetValue2( dmg, "hp" ) < ComponentGetValue2( dmg, "max_hp" )
end

--[[ Health Bars ]]
local health_bars = setting_get( MISC.HealthBars.RangeFlag )
if health_bars == 2 then
    for _,nearby in pairs( EntityGetInRadiusWithTag( x, y, 300, "enemy" ) ) do
        if has_entity_taken_damage( nearby ) and EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil and not EntityHasVarTag( nearby, "gkbrkn_no_health_bar") then
            entity_draw_health_bar( nearby, 1 )
        end
    end
elseif health_bars == 1 and now % 30 == 0 then
    for _,nearby in pairs( EntityGetInRadiusWithTag( x, y, 300, "enemy" ) ) do
        if has_entity_taken_damage( nearby ) and EntityGetFirstComponent( nearby, "HealthBarComponent" ) == nil and not EntityHasVarTag( nearby, "gkbrkn_no_health_bar") then
            add_entity_mini_health_bar( nearby )
        end
    end
end

--[[ Tweak - Shorten Blindness ]]
if setting_get("tweak_blindness") then
    local blindness = GameGetGameEffectCount( player_entity, "BLINDNESS" )
    if blindness > 0 then
        local effect = GameGetGameEffect( player_entity, "BLINDNESS" )
        local frames = ComponentGetValue2( effect, "frames" )
        if frames > 600 then
            ComponentSetValue2( effect, "frames", 600 )
        end
    end
end

--[[ Tweak: Reduced Electrocution ]]
if setting_get("tweak_reduced_electrocution") then
    local electrocution_effect = GameGetGameEffect( player_entity, "ELECTROCUTION" )
    if electrocution_effect ~= 0 then
        if ComponentGetValue2( electrocution_effect, "frames" ) > 1 then
            ComponentSetValue2( electrocution_effect, "frames", math.max( 1, ComponentGetValue2( electrocution_effect, "frames" ) - 1 ) )
        end
    end
end

--[[ Game Modifier - Floor is Lava ]]
if GameHasFlagRun( FLAGS.FloorIsLava ) and now % 10 == 0 then
    local character_data = EntityGetFirstComponent( player_entity, "CharacterDataComponent" )
    if character_data ~= nil then
        local is_on_ground = ComponentGetValue2( character_data, "is_on_ground" )
        if is_on_ground == true then
            EntityInflictDamage( player_entity, 5/25, "DAMAGE_FIRE", "Floor is Lava", "NONE", 0, 0 )
        end
    end
end

--[[ Game Modifier - Keep Moving ]]
old_position = old_position
if GameHasFlagRun( FLAGS.KeepMoving ) then
    if GameGetFrameNum() > 180 and now % 15 == 0 then
        if old_position ~= nil then
            local death_barrier = EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/death_barrier.xml", old_position.x, old_position.y )
        end
        old_position = {x=x, y=y}
    end
end

--[[ Siphon Heals ]]
local siphon_healing = tonumber(GlobalsGetValue("gkbrkn_siphon_heals", "0"))
if siphon_healing > 0 then
    GlobalsSetValue("gkbrkn_siphon_heals", tostring( siphon_healing - 1) )
    EntityInflictDamage( player_entity, -1.0/25.0, "DAMAGE_HEALING", "siphon", "NONE", 0, 0, player, x, y, 0 )
    local s = EntityLoad( "data/entities/particles/heal.xml", x, y )
    EntityAddComponent2( s, "LifetimeComponent", {lifetime=1})
    EntityAddChild( player_entity, s )
    GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/create", x, y )
end

--##DEV STATS.add_and_count("player_update",GameGetRealWorldTimeSinceStarted()-t)