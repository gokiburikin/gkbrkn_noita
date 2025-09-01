
--##DEV local STATS = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua" )
print("[goki's things] setting up GUI")
local WAND_HELPER = dofile( "mods/gkbrkn_noita/files/gkbrkn/lib/wand_helper.lua" )
local is_game_paused = false

-- Force cache refresh to ensure we have the latest files
__loaded = {}
local STATS = dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua")
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/inventories.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua")
dofile_once( "data/scripts/lib/coroutines.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )

local CONTENT = {}
GKBRKN_CONFIG.parse_content( false, true, CONTENT )
local SETTINGS                      = GKBRKN_CONFIG.SETTINGS
local OPTIONS                       = GKBRKN_CONFIG.OPTIONS
local CONTENT_ACTIVATION_TYPE       = GKBRKN_CONFIG.CONTENT_ACTIVATION_TYPE

local content_type = nil
local sort_cache = {}
SetRandomSeed( 137, 931 )
local tip_index = math.ceil( Random() * #MISC.ShowModTips.Tips )
local tip = GameTextGetTranslatedOrNot( MISC.ShowModTips.Tips[tip_index] )
local z_index = -9000
local show_deprecated_content = false
local manage_external_content = false
local target_dummy_mode = false
local hidden = false
local hide_menu_frame = GameGetFrameNum() + 300

local gui = GuiCreate()
local full_screen_width, full_screen_height = GuiGetScreenDimensions( gui )
GuiStartFrame( gui )
local screen_width, screen_height = GuiGetScreenDimensions( gui )

local action_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/action_data.lua" )( true )
local perk_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/perk_data.lua" )()

local gokiui = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/gokiui.lua" )( gui, 0, z_index )
gokiui.register_settings( OPTIONS )
local next_id = gokiui.next_id
local reset_id = gokiui.reset_id
local iterate_settings = gokiui.iterate_settings
local refresh_settings = gokiui.refresh_settings
local do_custom_tooltip = gokiui.do_custom_tooltip
local word_wrap = gokiui.word_wrap

local action_type_to_border_sprite = {
	[ACTION_TYPE_PROJECTILE] = "data/ui_gfx/inventory/item_bg_projectile.png",
	[ACTION_TYPE_STATIC_PROJECTILE] = "data/ui_gfx/inventory/item_bg_static_projectile.png",
	[ACTION_TYPE_MODIFIER] = "data/ui_gfx/inventory/item_bg_modifier.png",
	[ACTION_TYPE_DRAW_MANY] = "data/ui_gfx/inventory/item_bg_draw_many.png",
	[ACTION_TYPE_MATERIAL] = "data/ui_gfx/inventory/item_bg_material.png",
	[ACTION_TYPE_OTHER] = "data/ui_gfx/inventory/item_bg_other.png",
	[ACTION_TYPE_UTILITY] = "data/ui_gfx/inventory/item_bg_utility.png",
	[ACTION_TYPE_PASSIVE] = "data/ui_gfx/inventory/item_bg_passive.png",
}

local is_action_unlocked = function( action )
	local valid = false
	if action then
		if action.spawn_requires_flag ~= nil then
			local flag_name = action.spawn_requires_flag
			local flag_status = HasFlagPersistent( flag_name )
			if flag_status then valid = true end
			-- Music Notes
			--if action.spawn_probability == "0" then  valid = false end
		else
			valid = true
		end
		return valid
	end
end

local force_toggle_inventory = function()
    local controls = EntityGetFirstComponent( player,"ControlsComponent" )
    if controls then
        ComponentSetValue2( controls, "mButtonDownInventory", true )
        ComponentSetValue2( controls, "mButtonFrameInventory", GameGetFrameNum() + 1 )
    end
    GlobalsSetValue( "gkbrkn_toggle_inventory", "1" )
end

local already_forced_toggle = false
local force_inventory_refresh = function()
	already_forced_toggle = true
	local player = EntityGetWithTag("player_unit")[1]
	local i2 = EntityGetFirstComponentIncludingDisabled( player, "Inventory2Component" )
	if not i2 then return end
	ComponentSetValue2( i2, "mForceRefresh", true )
end

local _function_call_queue = {}
local queue_function_call = function( callback, ... )
	_function_call_queue[{...}] = callback
	if not already_forced_toggle then force_inventory_refresh() end
end
local handle_function_call_queue = function()
	already_forced_toggle = false
	for args,callback in pairs(_function_call_queue) do
		callback(unpack(args))
	end
	_function_call_queue = {}
end

local disable_starting_perks = function()
	for k,v in pairs( perk_data ) do
		setting_remove( "sp_perk_"..v.id )
	end
end

local do_stats = function( gui )
	for _,key in ipairs({"settings_get","player_shot","process_entity","player_update","draw_action","do_gui"}) do
		local total = STATS.get(key)
		local count = STATS.get_count(key)
		GuiLayoutBeginHorizontal( gui, 0, 0 )
			GuiColorSetForNextWidget( gui, 0.0, 0.5, 1.0, 1.0 )
			GuiText( gui, 0, 0, key.."  ")
			GuiColorSetForNextWidget( gui, 1.0, 1.0, 1.0, 1.0 )
			GuiText( gui, 1, 0, decimal_format(total * 1000,3) )
			gokiui.color_disabled()
			GuiText( gui, 0, 0, "ms  ")
			GuiText( gui, 0, 0, count )
			gokiui.color_disabled()
			GuiText( gui, 0, 0, "c  " )
			if count > 0 then
				GuiText( gui, 0, 0, decimal_format(total / count * 1000, 3) )
				gokiui.color_disabled()
				GuiText( gui, 0, 0, "ms/c" )
			end
		GuiLayoutEnd( gui )
	end
	local cx, cy = GameGetCameraPos()
	local entity_count = #EntityGetInRadius( cx, cy, math.huge )
	GuiText( gui, 0, 0, entity_count.." Entities")
	GuiText( gui, 0, 0, (GlobalsGetValue( "gkbrkn_champion_enemies_encountered" ) or 0).." Champions Encountered")
	GuiText( gui, 0, 0, (StatsGetValue("places_visited") or 0).." Places Visited")
end

local mass_toggle = function( gui, group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
	GuiLayoutBeginHorizontal( gui, 0, 0 )
	if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then
		for _,group in pairs( group_setting.settings ) do
			for _,setting in pairs( group.settings ) do
				setting_set( setting.key, true )
				setting.current = true
			end
		end
	end
	GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
	if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then
		for _,group in pairs( group_setting.settings ) do
			for _,setting in pairs( group.settings ) do
				setting_set( setting.key, false )
				setting.current = false
			end
		end
	end
	GuiLayoutEnd( gui )
end

local do_group_toggle = function( gui, group_setting)
	GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
	if GuiButton( gui, next_id(), 0, 0, "[Enable Group]" ) then
		for _,setting in pairs( group_setting.settings ) do
			setting_set( setting.key, true )
			setting.current = true
		end
	end
	GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
	if GuiButton( gui, next_id(), 0, 0, "[Disable Group]" ) then
		for _,setting in pairs( group_setting.settings ) do
			setting_set( setting.key, false )
			setting.current = false
		end
	end
end

local do_content_author = function( gui, group_setting )
	local content = group_setting.settings[1].type_data.content
	GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 )
	GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( find_content_type(content.type).display_name ) )
	gokiui.color_disabled()
	GuiText( gui, 0, 0, "by" )
	GuiColorSetForNextWidget( gui, 0.5, 0.75, 1.0, 1.0 )
	GuiText( gui, 0, 0, (GameTextGetTranslatedOrNot( content.author ) or "Unknown") )
end

local do_group_header = function( gui, group_setting )
	GuiLayoutAddVerticalSpacing( gui, 10 )
	GuiLayoutBeginHorizontal( gui, 0, 0 )
	do_content_author( gui, group_setting )
	GuiLayoutAddHorizontalSpacing( gui, 10 )
	do_group_toggle( gui, group_setting )
	GuiLayoutEnd( gui )
end

local deprecation_tooltip = function( gui, setting )
	if setting.type_data.content.deprecated and show_deprecated_content then
		GuiColorSetForNextWidget( gui, 1.0, 0.5, 1.0, 1.0 )
		GuiText( gui, 0, 0, word_wrap( "This content is deprecated" )  ) -- LOCALIZE
	end
	if not setting.type_data.content.loaded then
		GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 )
		GuiText( gui, 0, 0, word_wrap( "This content is currently unloaded" ) ) -- LOCALIZE
		if setting_get( setting.key ) then
			GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.0, 1.0 )
			GuiText( gui, 0, 0, word_wrap( "This content will be enabled next restart" ) ) -- LOCALIZE
		end
	elseif not setting_get( setting.key ) then
		GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.0, 1.0 )
		GuiText( gui, 0, 0, word_wrap( "This content will be disabled next restart" ) ) -- LOCALIZE
	end
end

local toggle_vanilla = function()
	iterate_settings( function( setting )
		if setting.type_data ~= nil and setting.type_data.content ~= nil then
			setting_set( setting.key, false )
		else
			setting_set( setting.key, setting.disable )
		end
		setting.current = setting_get(setting.key)
	end )
	setting_set( FLAGS.DisableNewContent, true )
	disable_starting_perks()
	refresh_settings()
end

local toggle_default = function()
	iterate_settings( function( setting )
		setting_set( setting.key, setting.default )
		setting.current = setting_get(setting.key)
	end )
	disable_starting_perks()
	refresh_settings()
end

local toggle_content_by_tag = function( tag, do_default )
	if do_default then
		toggle_default()
	end
	iterate_settings( function( setting )
		if setting.type_data ~= nil and setting.type_data.content ~= nil then
			if setting.type_data.content.tags[tag] then
				setting_set( setting.key, setting.type_data.content.tags[tag] )
				setting.current = setting.type_data.content.tags[tag]
			end
		else
			if setting.tags[tag] then
				setting_set( setting.key, setting.tags[tag] )
				setting.current = setting.tags[tag]
			end
		end
	end )
end

local set_content_by_tag = function( tag, value, do_default )
	if do_default then
		toggle_default()
	end
	iterate_settings( function( setting )
		if setting.type_data ~= nil and setting.type_data.content ~= nil then
			if setting.type_data.content.tags[tag] then
				setting_set( setting.key, value )
				setting.current = value
			end
		else
			if setting.tags[tag] then
				setting_set( setting.key, value )
				setting.current = value
			end
		end
	end )
end

local do_inventory_buttons = function()
	gokiui.z_set( gui, -50 )
	local sort_inventory = GuiImageButton( gui, next_id(), 190, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/wand_sort.png" )
	GuiTooltip( gui, "Sort spells in the inventory by name", "" )
	local remove_all_actions_from_wands = GuiImageButton( gui, next_id(), 198, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/wand_to_inventory.png" )
	GuiTooltip( gui, "Move all spells from every wand to the inventory", "" )
	local explode_actions = GuiImageButton( gui, next_id(), 206, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/explode_spells.png" )
	GuiTooltip( gui, "Drop all of the spells in the inventory", "" )
	if sort_inventory == true then
		local a = WAND_HELPER.inventory_remove_all_actions()
		if a then
			WAND_HELPER.sort_actions( a )
			queue_function_call( WAND_HELPER.inventory_add_actions, a )
		end
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif remove_all_actions_from_wands == true then
		-- TODO this doesn't validate correctly
		for _,wand in pairs( WAND_HELPER.player_get_all_wands() ) do
			queue_function_call( WAND_HELPER.wand_move_actions_to_inventory, wand )
		end
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif explode_actions == true then
		queue_function_call( WAND_HELPER.inventory_explode_random_actions, 99999 )
	end
end


local was_last_widget_hovered = function(gui)
	return ({GuiGetPreviousWidgetInfo(gui)})[3]
end

local do_wand_buttons = function( slot )
	local wands = WAND_HELPER.player_get_all_wands()
	local wand = wands[slot]
	local x, y = 1, 47 + 4 -- The +4 is for a little bit of padding

	for i=1,slot-1 do
		y = y + WAND_HELPER.wand_get_inventory_slot_height( gui, wands[i] )
	end
	-- For centering, though I don't think I prefer it
	--y = y + WAND_HELPER.wand_get_inventory_slot_height( gui, wand ) * 0.5 - 16

	gokiui.z_set( gui, -50 )
	local move_to_inventory = GuiImageButton( gui, next_id(), x, y, "", "mods/gkbrkn_noita/files/gkbrkn/gui/wand_to_inventory.png" )
	GuiTooltip( gui, "Move spells on this wand to the inventory", "" )
	local move_full_to_here = GuiImageButton( gui, next_id(), x + 8, y, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_to_wand.png" )
	GuiTooltip( gui, "Move spells in the inventory to this wand", "" )
	local move_selected_here = GuiImageButton( gui, next_id(), x, y + 8, "", "mods/gkbrkn_noita/files/gkbrkn/gui/active_to_wand.png" )
	GuiTooltip( gui, "Move spells on the active wand to this wand", "" )
	local swap = GuiImageButton( gui, next_id(), x + 8, y + 8, "", "mods/gkbrkn_noita/files/gkbrkn/gui/wand_to_wand.png" )
	GuiTooltip( gui, "Swap spells between the active wand and this wand", "" )
	local push_left = GuiImageButton( gui, next_id(), x, y + 16, "", "mods/gkbrkn_noita/files/gkbrkn/gui/push_spells_left.png" )
	GuiTooltip( gui, "Push spells on this wand to the left", "" )
	local push_right = GuiImageButton( gui, next_id(), x + 8, y + 16, "", "mods/gkbrkn_noita/files/gkbrkn/gui/push_spells_right.png" )
	GuiTooltip( gui, "Push spells on this wand to the right", "" )
	local sort = GuiImageButton( gui, next_id(), x, y + 24, "", "mods/gkbrkn_noita/files/gkbrkn/gui/wand_sort.png" )
	GuiTooltip( gui, "Sort spells on this wand by name", "" )
	local explode_spells = GuiImageButton( gui, next_id(), x + 8, y + 24, "", "mods/gkbrkn_noita/files/gkbrkn/gui/explode_spells.png" )
	GuiTooltip( gui, "Drop all of the spells on this wand into the world", "" )

	if move_to_inventory == true then
		queue_function_call( WAND_HELPER.wand_move_actions_to_inventory, wand )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif move_full_to_here == true then
		-- NOTE this is the one action that queueing messes up...can't just be consistent can it
		WAND_HELPER.wand_move_inventory_to_wand( wand )
		force_inventory_refresh()
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif move_selected_here == true then
		queue_function_call( WAND_HELPER.wand_move_actions_to_wand, WAND_HELPER.player_get_active_wand(), wand )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif swap == true then
		queue_function_call( WAND_HELPER.wand_swap_actions, wand, WAND_HELPER.player_get_active_wand() )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif push_right == true then
		queue_function_call( WAND_HELPER.wand_push_actions, wand, 1 )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif push_left == true then
		queue_function_call( WAND_HELPER.wand_push_actions, wand, -1 )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif sort == true then
		queue_function_call( WAND_HELPER.wand_sort_actions, wand )
		GamePlaySound( "data/audio/Desktop/ui.bank", "ui/item_switch_places", GameGetCameraPos() )
	elseif explode_spells == true then
		queue_function_call( WAND_HELPER.wand_explode_random_actions, wand, 99999 )
	end
end

local filter_content = function( content_list, content_type, content_table )
	if content_table == nil then content_table = CONTENT end
	local filtered = {}
	for _,content in pairs( content_list ) do
		if content.type == content_type then
			table.insert( filtered, content.id )
		end
	end
	return filtered
end

local get_screen_position = function( x, y )
	local screen_width, screen_height = GuiGetScreenDimensions( gui )
	local camera_x, camera_y = GameGetCameraPos()
	local res_width = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_X" )
	local res_height = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_Y" )
	local ax = (x - camera_x) / res_width * screen_width
	local ay = (y - camera_y) / res_height * screen_height
	return ax + screen_width * 0.5, ay + screen_height * 0.5
end

local do_special_button = function( button_text, description_text )
	GuiLayoutBeginHorizontal( gui, 0, 0 )
		GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
		local left_click, right_click = GuiButton( gui, 0, 0, button_text, next_id() )
		GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
		GuiText( gui, 0, 0, description_text )
	GuiLayoutEnd( gui )
	return left_click, right_click
end

local basic_content_callback = function( setting )
	local setting_data = setting.type_data
	local deprecated = setting_data.content.deprecated
	if not deprecated or show_deprecated_content then
		local left_click, right_click = GuiImageButton( gui, next_id(), 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (setting.current == true and "_fill" or "") .. ".png" )
		gokiui.color_toggled( setting.current == true )
		local alt_left_click, alt_right_click = GuiButton( gui, next_id(), 0, 0, setting_data.content.name )
		if setting.tooltip then
			do_custom_tooltip( function() GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ) ) ) end )
		end
		if left_click == true or alt_left_click == true then
			setting.current = not setting.current
			setting_set( setting.key, setting.current )
		end
		if right_click == true or alt_right_click == true then
			if setting_data.content ~= nil then
				if setting_data.content.options and setting_data.content.options.preview_callback ~= nil then
					setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] )
				end
			end
		end
	end
end

local setting_callbacks = {}
setting_callbacks.pack = basic_content_callback
setting_callbacks.item = basic_content_callback
setting_callbacks.game_modifier = basic_content_callback
setting_callbacks.cheat = basic_content_callback
setting_callbacks.legendary_wand = basic_content_callback
setting_callbacks.tweak = basic_content_callback
setting_callbacks.loadout = basic_content_callback
setting_callbacks.champion_type = function( setting )
	local setting_data = setting.type_data
	local deprecated = setting_data.content.deprecated == true
	if setting_data ~= nil and (not deprecated or show_deprecated_content) then
		local champion_type_data = setting_data.content
		local stackable = champion_type_data.data.stackable
		local toggle = false
		gokiui.color_toggled( setting.current == true )
		if setting_data.content.loaded ~= true then
			GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 )
		end
		local hover_data = nil
		if champion_type_data then
			local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", champion_type_data.sprite )
			if left_click then
				toggle = true
			end
		elseif setting_data.content.sprite then
			local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", setting_data.content.sprite )
			if left_click then
				toggle = true
			end
		else
			local left_click, right_click = GuiButton( gui, next_id(), 0, 0, (setting.current == true and "[x] " or "[ ] ")..GameTextGetTranslatedOrNot( setting_data.content.name ) )
			if left_click then
				toggle = true
			end
		end
		do_custom_tooltip( function()
			GuiLayoutBeginVertical( gui, 0, 0 )
				GuiLayoutBeginHorizontal( gui, 0, 0 )
					GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) )
					gokiui.color_disabled()
					GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  )
				GuiLayoutEnd( gui )
				gokiui.color_disabled()
				GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ) ) )
				if stackable == true then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					-- TODO localize
					GuiText( gui, 0, 0, word_wrap( "This modifier is stackable" ) )
				end
				deprecation_tooltip( gui, setting )
			GuiLayoutEnd( gui )
		end, z_index - 12 )
		gokiui.z_set( gui, z_index )
		if hover_data then
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting )
			-- TODO use constants for specific layers
			gokiui.z_set_next( gui, z_index - 1 )
			GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/locked.png", 1.0, 1.0, 0 )
		end
		if toggle then
			setting.current = not setting.current
			setting_set( setting.key, setting.current )
		end
	end
end
setting_callbacks.action = function( setting, show_borders, show_progress )
	local setting_data = setting.type_data
	local deprecated = setting_data.content.deprecated == true
	if action_data ~= nil and ( deprecated == false or show_deprecated_content ) then
		local this_action_data = action_data[setting_data.content.key]
		local toggle = false
		local managed = setting_data.content.local_content == true or manage_external_content
		local semi_transparent = false
		local has_progress = HasFlagPersistent( "action_"..this_action_data.id:lower() )
		if is_action_unlocked( this_action_data ) == false then
			semi_transparent = true
		end
		if setting.current ~= true and managed == true then
			semi_transparent = true
			gokiui.color_disabled()
		end
		if deprecated == true and show_deprecated_content == false and managed == true then
			semi_transparent = true
			GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 )
		end
		local hover_data = nil
		if this_action_data then
			gokiui.z_set_next( gui, z_index + 2 )
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.Disabled )
			local left_click, right_click
			local spell_icon_x = 0
			local spell_icon_y = 0
			if show_borders then
				if semi_transparent then gokiui.color_disabled() end
				GuiImage( gui, next_id(), 0, 0, action_type_to_border_sprite[ this_action_data.type ], 1.0, 1.0, 0 )
				spell_icon_x = -20
				spell_icon_y = 2
			else
				spell_icon_x = 0
				spell_icon_y = 0
			end
			if show_progress and not has_progress then
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWaveAnimateOpacity )
				GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.0, 1.0 )
			end
			if semi_transparent then gokiui.color_disabled() end
			left_click, right_click = GuiImageButton( gui, next_id(), spell_icon_x, spell_icon_y, "", this_action_data.sprite )
			if left_click then
				toggle = true
			elseif right_click then
				if setting_data.content.options.preview_callback ~= nil and this_action_data.enabled then
					setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] )
				end
			end
			if is_action_unlocked( this_action_data ) == false then
				hover_data = { GuiGetPreviousWidgetInfo( gui ) }
			end
		end
		do_custom_tooltip( function()
			GuiLayoutBeginVertical( gui, 0, 0 )
				GuiLayoutBeginHorizontal( gui, 0, 0 )
					GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) )
					GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 )
					GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  )
				GuiLayoutEnd( gui )

				GuiLayoutAddVerticalSpacing( gui, -2 )
				GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
				GuiText( gui, 0, 0, this_action_data.id )

				GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
				GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ) ) )
				if setting_get( FLAGS.DebugMode, false ) then
					GuiColorSetForNextWidget( gui, 0.4, 0.6, 0.4, 1.0 )
					GuiText( gui, 0, 0, "Spawn Levels: "..this_action_data.spawn_level )
					GuiColorSetForNextWidget( gui, 0.4, 0.6, 0.4, 1.0 )
					GuiText( gui, 0, 0, "Spawn Chance: "..this_action_data.spawn_probability )
				end
				if is_action_unlocked( this_action_data ) == false then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					-- TODO localize
					GuiText( gui, 0, 0, word_wrap( "This content is not unlocked and will not appear in-game\nSpawning this content will unlock it permanently" ) )
				end
				if not has_progress then
					GuiColorSetForNextWidget( gui, 0.50, 0.75, 0.50, 1.0 )
					-- TODO localize
					GuiText( gui, 0, 0, word_wrap( "This content is not yet in the progress menu" ) )
				end
				if not managed then
					GuiColorSetForNextWidget( gui, 1.0, 0.0, 1.0, 1.0 )
					-- TODO localize
					GuiText( gui, 0, 0, word_wrap( "This content is external and not managed by Goki's Things" ) )
				end
				deprecation_tooltip( gui, setting )
			GuiLayoutEnd( gui )
		end, z_index - 12 )
		gokiui.z_set( gui, z_index )
		if hover_data then
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting )
			-- TODO use constants for specific layers
			gokiui.z_set_next( gui, z_index - 1 )
			GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/locked.png", 1.0, 1.0, 0 )
		end
		if toggle then
			setting.current = not setting.current
			setting_set( setting.key, setting.current )
		end
	end
end
setting_callbacks.perk = function( setting )
	local setting_data = setting.type_data
	local deprecated = setting_data.content.deprecated == true
	if perk_data ~= nil then
		local this_perk_data = perk_data[setting_data.content.key]
		local toggle = false
		local starting_perk = setting_get( "sp_"..setting.key, false )
		local managed = setting_data.content.local_content == true or manage_external_content
		if starting_perk == true then
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWobble )
		end
		if setting.current ~= true and managed == true then
			gokiui.color_disabled()
		end
		if deprecated == true and show_deprecated_content == false and managed == true then
			GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 )
		end
		if this_perk_data.enabled == true and this_perk_data.missing == true then
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWaveAnimateOpacity )
		end
		local hover_data = nil
		if this_perk_data then
			local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", this_perk_data.perk_icon )
			if left_click then
				toggle = true
			elseif right_click then
				if setting_data.content.options.preview_callback ~= nil then
					setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] )
				end
			end
			if this_perk_data.missing == true or this_perk_data.stackable == true then
				hover_data = { GuiGetPreviousWidgetInfo( gui ) }
			end
		end
		do_custom_tooltip( function()
			GuiLayoutBeginVertical( gui, 0, 0 )
				GuiLayoutBeginHorizontal( gui, 0, 0 )
					GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) )
					GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 )
					GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  )
				GuiLayoutEnd( gui )
				
				GuiLayoutAddVerticalSpacing( gui, -2 )
				GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
				GuiText( gui, 0, 0, this_perk_data.id )

				GuiLayoutAddVerticalSpacing( gui, 2 )
				GuiColorSetForNextWidget( gui, 0.811, 0.811, 0.811, 1.0 )
				GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ) ) )
				if this_perk_data.stackable then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					-- TODO localize
					GuiText( gui, 0, 0, word_wrap( "This perk is stackable" ) )
				end
				if this_perk_data.not_in_pool then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					GuiText( gui, 0, 0, word_wrap( "This perk is not in the perk pool" ) ) -- LOCALIZE
				elseif this_perk_data.missing then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					if not setting_get( MISC.PerkRewrite.NewLogicFlag, false ) then
						GuiText( gui, 0, 0, word_wrap( "This perk is not in the perk pool for this run" ) ) -- LOCALIZE
					else
						GuiText( gui, 0, 0, word_wrap( "This perk will take a long time to roll into" ) ) -- LOCALIZE
					end
				end
				if starting_perk == true and not deprecated then
					GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
					GuiText( gui, 0, 0, word_wrap( "You will start with this perk on your next run" ) ) -- LOCALIZE
				end
				if not managed then
					GuiColorSetForNextWidget( gui, 1.0, 0., 1.0, 1.0 )
					GuiText( gui, 0, 0, word_wrap( "This content is external and not managed by Goki's Things" ) ) -- LOCALIZE
				end
				deprecation_tooltip( gui, setting )
			GuiLayoutEnd( gui )
		end, z_index - 12 )
		gokiui.z_set( gui, z_index )
		if hover_data then
			if this_perk_data.enabled == true then
				if this_perk_data.not_in_pool == true then
					GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting )
					gokiui.z_set_next( gui, z_index - 1 )
					GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/perk_not_in_pool.png", 1.0, 1.0, 0 )
				elseif this_perk_data.missing == true then
					GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting )
					gokiui.z_set_next( gui, z_index - 1 )
					if setting_get( MISC.PerkRewrite.NewLogicFlag, false ) then
						GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/perk_deep_in_pool.png", 1.0, 1.0, 0 )
					else
						GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/missing_perk.png", 1.0, 1.0, 0 )
					end
				end
			end
			if this_perk_data.stackable == true then
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting )
				gokiui.z_set_next( gui, z_index - 1 )
				GuiImage( gui, next_id(), hover_data[8] + 12, hover_data[9] - 1, "mods/gkbrkn_noita/files/gkbrkn/gui/stackable_perk.png", 1.0, 1.0, 0 )
			end
		end
		if toggle then
			if setting.current == false then
				setting_set( setting.key, true )
				setting.current = true
				if not managed then
					setting_set( "sp_"..setting.key, true )
				end
			elseif setting.current == true and setting_get( "sp_"..setting.key, false ) == false then
				setting_set( "sp_"..setting.key, true )
				setting.current = true
			else
				setting_remove( "sp_"..setting.key )
				if managed then
					setting_set( setting.key, false )
					setting.current = false
				else
					setting_set( setting.key, true )
					setting.current = true
				end
			end
		end
	end
end

local basic_group_callback = function( settings )
	do_group_header( gui, settings )
	for _,setting in pairs( settings.settings or {} ) do
		GuiLayoutBeginHorizontal( gui, 1, 0 )
			setting_callbacks[settings.group_label]( setting )
		GuiLayoutEnd( gui )
	end
end
local group_callbacks = {}
group_callbacks.pack = basic_group_callback
group_callbacks.item = basic_group_callback
group_callbacks.game_modifier = basic_group_callback
group_callbacks.cheat = basic_group_callback
group_callbacks.legendary_wand = basic_group_callback
group_callbacks.tweak = basic_group_callback
group_callbacks.loadout = basic_group_callback
group_callbacks.champion_type = function( group_setting )
	do_group_header( gui, group_setting )
	local setting_index = 1
	local setting = group_setting.settings[setting_index]
	local adjusted_columns = math.max( 6, math.min( (#group_setting.settings) ^ 0.75, 16 ) )
	while setting ~= nil do
		GuiLayoutBeginHorizontal( gui, 1, 0 )
			local x = 1
			while x < adjusted_columns do
				setting = group_setting.settings[setting_index]
				setting_index = setting_index + 1
				if setting then
					if setting.type_data.content.deprecated ~= true or show_deprecated_content == true then
						setting_callbacks.champion_type( setting )
						x = x + 1
					end
				else
					break
				end
			end
		GuiLayoutEnd( gui )
	end
end
group_callbacks.action = function( group_setting, sort_method, show_borders, show_progress )
	do_group_header( gui, group_setting )
	local sort_cache_key = "action."..group_setting.settings[1].type_data.content.author.."."..sort_method
	local sorted_settings = sort_cache[sort_cache_key]
	if sorted_settings == nil then
		sorted_settings = {}
		for k,v in ipairs( group_setting.settings or {} ) do
			table.insert( sorted_settings, v )
		end
		table.sort( sorted_settings, function( a, b )
			if a.type_data.content and b.type_data.content then
				if sort_method == 0 then
					if a.type_data.content.author:lower() == b.type_data.content.author:lower() then
						return GameTextGetTranslatedOrNot(a.type_data.content.name):lower() < GameTextGetTranslatedOrNot(b.type_data.content.name):lower()
					else
						return a.type_data.content.author:lower() < b.type_data.content.author:lower()
					end
				elseif sort_method == 1 then
					if a.type_data.content.author:lower() == b.type_data.content.author:lower() then
						return a.type_data.content.key:lower() < b.type_data.content.key:lower()
					else
						return a.type_data.content.author:lower() < b.type_data.content.author:lower()
					end
				elseif sort_method == 2 then
					return a.type_data.content.options.index < b.type_data.content.options.index
				end
			end
		end )
		sort_cache[sort_cache_key] = sorted_settings
	end
	local setting_index = 1
	local adjusted_columns = math.max( 6, math.min( (#sorted_settings) ^ 0.75, 16 ) )
	local setting = sorted_settings[setting_index]

	while setting ~= nil do
		GuiLayoutBeginHorizontal( gui, 1, 0 )
			local x = 1
			while x < adjusted_columns do
				setting = sorted_settings[setting_index]
				setting_index = setting_index + 1
				if setting then
					if setting.type_data.content.deprecated ~= true or show_deprecated_content == true then
						setting_callbacks.action( setting, show_borders, show_progress )
						x = x + 1
					end
				else
					break
				end
			end
		GuiLayoutEnd( gui )
		GuiLayoutAddVerticalSpacing( gui, -2 )
	end
end
group_callbacks.perk = function( group_setting )
	do_group_header( gui, group_setting )
	local setting_index = 1
	local setting = group_setting.settings[setting_index]
	local adjusted_columns = math.max( 6, math.min( (#group_setting.settings) ^ 0.75, 16 ) )
	while setting ~= nil do
		GuiLayoutBeginHorizontal( gui, 1, 0 )
			local x = 1
			while x < adjusted_columns do
				setting = group_setting.settings[setting_index]
				setting_index = setting_index + 1
				if setting then
					if setting.type_data.content.deprecated ~= true or show_deprecated_content == true then
						setting_callbacks.perk( setting )
						x = x + 1
					end
				else
					break
				end
			end
		GuiLayoutEnd( gui )
	end
end

local basic_tab_callback = function( settings )
	mass_toggle( gui, settings )
	for _,group in pairs( settings.settings ) do
		group_callbacks[settings.group_label]( group )
	end
end
local tab_callbacks = {}
tab_callbacks.start = function( group_setting )
	GuiLayoutBeginHorizontal( gui, 0, 0 )
		GuiText( gui, 0, 0, "Welcome to")
		GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
		GuiText( gui, 0, 0, "Goki's Things")
		GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
		GuiText( gui, 0, 0, SETTINGS.Version)
	GuiLayoutEnd( gui )

	GuiText( gui, 0, 0, " ")
	GuiText( gui, 0, 0, "Select a tab above to change settings or choose one of the presets below!")

	GuiLayoutBeginHorizontal( gui, 0, 0 )
		GuiText( gui, 0, 0, "Click one of the buttons below to apply a preset.")
		GuiColorSetForNextWidget( gui, 1.0, 0.25, 0.25, 1.0 )
		GuiText( gui, 0, 0, "Be careful! This will change multiple settings at once!")
	GuiLayoutEnd( gui )
	GuiText( gui, 0, 0, " ")
	
	if do_special_button( "[Default]", "Reset Goki's Things to default settings" ) then
		toggle_default()
		GamePrint("Reset Goki's Things to its default settings")
	end

	if do_special_button( "[Developer]", "Quickly enable good developer settings" ) then
		set_content_by_tag("loadout", false)
		toggle_content_by_tag("developer")
		GamePrint("Enabled developer options")
	end

	if do_special_button( "[Vanilla]", "Turn off all custom Goki's Things content" ) then
		toggle_vanilla()
		GamePrint("Disabled all custom content")
	end

	GuiText( gui, 0, 0, " " )

	if do_special_button( "[Champions Mode]", "Enemies have special modifiers that change up the combat" ) then
		toggle_content_by_tag("champions_mode")
		GamePrint("Enabled Champions Mode options")
	end

	if do_special_button( "[Hero Mode]", "Enemies are tougher and the final boss has a higher minimum health" ) then
		toggle_content_by_tag("hero_mode")
		GamePrint("Enabled Hero Mode options")
	end

	if do_special_button( "[Ultimate Challenge Mode]", "Enable the Ultimate Hero + Ultimate Champion game modes" ) then
		toggle_content_by_tag("ultimate_challenge")
		GamePrint("Enabled Ultimate Challenge Mode options")
	end

	if do_special_button( "[Rakshasa Mode]", "An intense, unfair difficulty mode" ) then
		toggle_content_by_tag("carnage")
		GamePrint("Enabled Rakshasa Mode options")
	end

	GuiText( gui, 0, 0, " ")

	if do_special_button( "[Random Starts]", "Start runs with random equipment" ) then
		toggle_content_by_tag("random_starts")
		setting_set( MISC.RandomStart.RandomPerksFlag, 1 )
		refresh_settings()
		GamePrint("Enabled Random Starts options")
	end

	if do_special_button( "[Loadouts]", "Allow Goki's Things to manage loadouts and start runs with a random loadout" ) then
		toggle_content_by_tag("loadouts")
		for _,content in pairs( CONTENT ) do
			if content.type == "loadout" or content.type == "action" or content.type == "perk" then
				content.toggle( true )
			end
		end
		GamePrint("Enabled loadout management and all loadouts")
	end

	GuiText( gui, 0, 0, " ")

	GuiLayoutBeginHorizontal( gui, 0, 0 )
		GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
		GuiText( gui, 0, 0, "Goki Says: " )
		GuiText( gui, 0, 0, tip )
	GuiLayoutEnd( gui )
end
tab_callbacks.stats = function( group_setting )
	do_stats( gui )
end
tab_callbacks.pack = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click packs to turn them on or off - Right Click packs to acquire them" )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Packs are an incomplete system and there aren't enough packs for fulfilling gameplay (WIP)" )
	basic_tab_callback( group_setting )
end
tab_callbacks.item = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click items to turn them on or off - Right Click items to acquire them" )
	basic_tab_callback( group_setting )
end
tab_callbacks.game_modifier = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click game modifiers to turn them on or off" )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Changes to game modifiers require a new game and persist throughout the run" )
	basic_tab_callback( group_setting )
end
tab_callbacks.cheat = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click cheats to turn them on or off" )
	basic_tab_callback( group_setting )
end
tab_callbacks.legendary_wand = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click unique wands to turn them on or off - Right Click Unique Wands to acquire them" )
	basic_tab_callback( group_setting )
end
tab_callbacks.champion_type = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click champions to turn them on or off" )
	basic_tab_callback( group_setting )
end
tab_callbacks.tweak = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click tweaks to turn them on or off" )
	basic_tab_callback( group_setting )
end
tab_callbacks.loadout = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click loadouts to turn them on or off - Right Click loadouts to acquire them" )
	basic_tab_callback( group_setting )
end
tab_callbacks.action = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click spells to turn them on or off - Right Click spells to spawn them" )
	gokiui.do_boolean( gui, next_id(), FLAGS.ShowSpellProgress, 0, 0, "$option_name_gkbrkn_show_spell_progress", setting_get( FLAGS.ShowSpellProgress, false ), "$option_desc_gkbrkn_show_spell_progress" )
	gokiui.do_boolean( gui, next_id(), FLAGS.ShowSpellBorders, 0, 0, "$option_name_gkbrkn_show_spell_borders", setting_get( FLAGS.ShowSpellBorders, false ), "$option_desc_gkbrkn_show_spell_borders" )
	gokiui.do_range( gui, next_id(), FLAGS.SpellSortMethod, 0, 0, "$option_name_gkbrkn_spell_sort_method", setting_get( FLAGS.SpellSortMethod, 0 ), 0, 0, 2,
		function( value ) return math.floor( value + 0.5 ) end,
		function( value ) return ({"Localized Alphabetical","ID Alphabetical","Internal Order"})[value+1] end,
	"$option_desc_gkbrkn_spell_sort_method" )
	mass_toggle( gui, group_setting )
	local show_borders = setting_get( FLAGS.ShowSpellBorders, false )
	local show_progress = setting_get( FLAGS.ShowSpellProgress, false )
	local sort_order = setting_get( FLAGS.SpellSortMethod, 0 )

	for _,group in pairs( group_setting.settings ) do
		group_callbacks.action( group, sort_order, show_borders, show_progress )
	end
end
tab_callbacks.perk = function( group_setting )
	GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 )
	GuiText( gui, 0, 0, "Left Click perks to cycle through their states (Off, On, Starting Perk) - Right Click perks to acquire them" )
	basic_tab_callback( group_setting )
end

local sorted_content = {}
local content_counts = {}
for index,content in pairs( CONTENT ) do
	if content.visible() then
		table.insert( sorted_content, {
			id=index,
			type=content.type,
			name=GameTextGetTranslatedOrNot( content.name ) or ( "missing content name: "..index ),
			key=GameTextGetTranslatedOrNot( content.id ) or ( "missing content id: "..index ),
			author=GameTextGetTranslatedOrNot( content.options.author or "Unknown" )
		} )
		content_counts[content.type] = ( content_counts[content.type] or 0 ) + 1
	end
end

table.sort( sorted_content, function( a, b )
	if a.author:lower() == b.author:lower() then
		return a.name:lower() < b.name:lower()
	else
		return a.author:lower() < b.author:lower()
	end
end )

-- This is where content tabs are dynamically generated
for _,content_type in pairs( content_types ) do
	local name = GameTextGetTranslatedOrNot( content_type.display_name )
	name = ( content_counts[content_type.id] or 0 ).." "..name

	local filtered_content = filter_content( sorted_content, content_type.id )
	local content_table = {}
	for k,content in pairs( filtered_content ) do
		content = CONTENT[content]
		table.insert( content_table, GKBRKN_CONFIG.register_option_localized( content.settings_key, content.default, false, content_type.id, { content = content }, 2, nil, tags ) )
	end
	
	-- Group content by the author variable
	local grouped_content = {}
	for k,content in pairs( content_table ) do
		grouped_content[content.type_data.content.author] = grouped_content[content.type_data.content.author] or {}
		table.insert( grouped_content[content.type_data.content.author], content )
	end

	local groups = {}
	for k,group_tables in pairs(grouped_content) do
		table.insert( groups, GKBRKN_CONFIG.register_option_group( content_type.id, group_callbacks[content_type.id], unpack( group_tables ) ) )
	end

	-- This line inserts tabs for each content type based on its ID
	-- As such, any content types are required to have a callback function defined in tab_callbacks
	table.insert( OPTIONS, GKBRKN_CONFIG.register_option_tab_localized( content_type.id, 1, GKBRKN_CONFIG.register_option_group( content_type.id, tab_callbacks[content_type.id], unpack( groups ) ) ) )
end

table.insert( OPTIONS, 1, GKBRKN_CONFIG.register_option_tab_localized( "gkbrkn_start", 1, GKBRKN_CONFIG.register_option_group( "start", tab_callbacks.start ) ) )
if setting_get( FLAGS.DebugMode ) then
	table.insert( OPTIONS, GKBRKN_CONFIG.register_option_tab_localized( "gkbrkn_stats", 1, GKBRKN_CONFIG.register_option_group( "stats", tab_callbacks.stats ) ) )
end

-- First time Goki's Things launch
if setting_get( "version" ) == nil then
	refresh_settings()
	setting_set( "version", SETTINGS.Version )
end

local do_gui = function()
	--##DEV local t = GameGetRealWorldTimeSinceStarted()
	-- Caching these every frame because it's called per action / perk per frame
	show_deprecated_content = setting_get( FLAGS.ShowDeprecatedContent, false )
	manage_external_content = setting_get( MISC.ManageExternalContent.EnabledFlag, false )
	local is_inventory_open = GameIsInventoryOpen()
	if is_panel_open then
		if is_inventory_open and setting_get( FLAGS.ShowWhileInInventory, false ) ~= true then
			is_panel_open = false
		end
	end
	if is_panel_open then
		GlobalsSetValue( FLAGS.ConfigMenuOpen, "1" )
	else
		GlobalsSetValue( FLAGS.ConfigMenuOpen, "0" )
	end
	reset_id()
	GuiStartFrame( gui )
	GuiIdPushString( gui, "gkbrkn_noita" )

	-- Just make everything fast clickable since I don't rely on double clicking for anything
	GuiOptionsAdd( gui, GUI_OPTION.HandleDoubleClickAsClick )
	GuiOptionsAdd( gui, GUI_OPTION.ClickCancelsDoubleClick )
	GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

	-- Disables gamepad support entirely
	--GuiOptionsAdd( gui, GUI_OPTION.NonInteractive )
	--GuiOptionsAdd( gui, GUI_OPTION.AlwaysClickable )

	local ti = tonumber(GlobalsGetValue( "gkbrkn_toggle_inventory" )) or 0
	if ti > 0 then
		ti = ti - 1
		GlobalsSetValue( "gkbrkn_toggle_inventory", tostring(ti) )
		local player = EntityGetWithTag("player_unit")[1]
		local controls = EntityGetFirstComponent( player,"ControlsComponent" )
		if controls then
			ComponentSetValue2( controls, "mButtonDownInventory", true )
			ComponentSetValue2( controls, "mButtonFrameInventory", GameGetFrameNum() + 1 )
		end
	end

	if setting_get( MISC.AutoHide.EnabledFlag, false ) == false or hidden == false then
		gokiui.z_set( gui, z_index )
		local screen_width, screen_height = GuiGetScreenDimensions( gui )

		if is_panel_open then
			GuiLayoutBeginVertical( gui, 5, 16 )
			if GlobalsGetValue( "gkbrkn_parse_mod_settings" ) ~= "1" then
				gokiui.parse_mod_settings( setting_get( FLAGS.DisableNewContent, false ) )
				GlobalsSetValue( "gkbrkn_parse_mod_settings", "1" )
				GlobalsSetValue( "gkbrkn_enable_controls", "1" )
				GlobalsSetValue( "gkbrkn_force_settings_refresh", "1" )
			end
			
			if GlobalsGetValue("gkbrkn_force_settings_refresh") == "1" then
				gokiui.refresh_settings()
				GlobalsSetValue("gkbrkn_force_settings_refresh","0")
			end

			-- Actual tabbed UI
			gokiui.do_gui()
			hide_menu_frame = GameGetFrameNum() + 300
			hidden = false
			GuiLayoutEnd( gui )
		else
			if setting_get( MISC.AutoHide.EnabledFlag, false ) and hide_menu_frame - GameGetFrameNum() < 0 and not hidden then
				hidden = true
				GamePrint("Goki's Things icon was hidden. Pause to bring it back!")
			end
		end

		local current_button_reservation = tonumber( GlobalsGetValue( "mod_button_tr_current", "0" ) )
		gokiui.z_set_next( gui, z_index )

		-- Goki's Things button
		if GameGetIsGamepadConnected() then
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.NonInteractive )
			GuiOptionsAddForNextWidget( gui, GUI_OPTION.AlwaysClickable )
		end
		if GuiImageButton( gui, next_id(), screen_width - 14 - current_button_reservation, 2, "", "mods/gkbrkn_noita/files/gkbrkn/gui/icon.png" ) then
			GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos() )
			local player = EntityGetWithTag("player_unit")[1]
			if not is_panel_open and not setting_get( FLAGS.ShowWhileInInventory, false ) and player then
				local controls = EntityGetFirstComponent( player,"ControlsComponent" )
				if controls and is_inventory_open then
					ComponentSetValue2( controls, "mButtonDownInventory", true )
					ComponentSetValue2( controls, "mButtonFrameInventory", GameGetFrameNum() + 1 )
				end
			end
			is_panel_open = not is_panel_open
		end
		do_custom_tooltip( function()
			GuiText( gui, 0, 0, "Configure Goki's Things" )
			GuiColorSetForNextWidget( gui, 0.6, 0.6, 0.6, 1.0 )
			GuiText( gui, 0, 0, SETTINGS.Version )
			end, z_index - 10, -GuiGetTextDimensions( gui, "Configure Goki's Things" ) - 24, 10 )

		-- Quick Target Dummy Button
		if not is_game_paused and setting_get( FLAGS.QuickTargetDummyButton, false ) then
			current_button_reservation = current_button_reservation + 15
			gokiui.z_set_next( gui, z_index )

			if GameGetIsGamepadConnected() then
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.NonInteractive )
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.AlwaysClickable )
			end
			if GuiImageButton( gui, next_id(), screen_width - 14 - current_button_reservation, 2, "", "mods/gkbrkn_noita/files/gkbrkn/gui/target_dummy_icon.png" ) then
				--target_dummy_mode = not target_dummy_mode
				GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos() )
				local dummies = EntityGetWithTag("gkbrkn_target_dummy")
				if #dummies > 0 then
					for _,e in ipairs(dummies) do
						EntityKill(e)
					end
					GamePrint("Removed nearby target dummies")
				else
					local player = EntityGetWithTag( "player_unit")[1]
					if player then
						local x,y = EntityGetTransform( player )
						EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", x, y - 10 )
					end
					GamePrint("Spawned a target dummy")
				end
			end
			do_custom_tooltip( function()
				GuiText( gui, 0, 0, "Spawn or remove nearby target dummies" )
			end, z_index - 10, -GuiGetTextDimensions( gui, "Spawn or remove nearby target dummies" ) - 24, 10 )
		end

		-- Development Mode Only Draw Cast Toggle Button
		if not is_game_paused and setting_get( FLAGS.DebugMode, false ) then
			current_button_reservation = current_button_reservation + 15
			gokiui.z_set_next( gui, z_index )

			if GameGetIsGamepadConnected() then
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.NonInteractive )
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.AlwaysClickable )
			end
			if GuiImageButton( gui, next_id(), screen_width - 14 - current_button_reservation, 2, "", "mods/gkbrkn_noita/files/gkbrkn/gui/draw_cast_icon.png" ) then
				setting_set( FLAGS.ShowDrawActions, not setting_get( FLAGS.ShowDrawActions, false ) )
			end
			do_custom_tooltip( function()
				GuiText( gui, 0, 0, "Toggle Show Casts" )
			end, z_index - 10, -GuiGetTextDimensions( gui, "Toggle Show Draw Actions" ) - 24, 10 )
		end

		--[[
		if target_dummy_mode then
			local mx, my = DEBUG_GetMouseWorld()
			local mmx, mmy = get_screen_position( mx, my )
			local t = "LMB - Place | RMB - Remove"
			local tw, th = GuiGetTextDimensions( gui, t )
			GuiText( gui, mmx - tw * 0.5, mmy - th - 8, t )
			local left_click, right_click = GuiButton( gui, next_id(), mmx - 2, mmy - 5, "           " )
			if left_click then
				EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/misc/dummy_target.xml", mx, my )
			elseif right_click then
				for _,e in pairs(EntityGetInRadiusWithTag( mx, my, 8, "gkbrkn_target_dummy" )) do
					EntityKill(e)
				end
			end
		end]]

		GlobalsSetValue( "mod_button_tr_current", tostring( current_button_reservation + 15 ) )
	end

	if not is_game_paused then
		if setting_get( FLAGS.ShowWandScores, false ) then
			local wand_scores = ModSettingGet( "gkbrkn_wand_scores" )
			if wand_scores and #wand_scores > 0 then
				for word in string.gmatch( wand_scores,"%d+=[%d.-]+" ) do
					local e = tonumber(string.match(word,"%d+"))
					local score = tonumber(string.match(word,"=[%d.-]+"):sub(2))
					local ex, ey = EntityGetTransform( e )
					if ex ~= nil and ey ~= nil then
						local sx, sy = get_screen_position( ex, ey )
						local tw, th = GuiGetTextDimensions( gui, score )
						GuiText( gui, sx - tw * 0.5, sy - th * 0.5 - 10, score )
					end
				end
			end
		end

		if setting_get( FLAGS.ShowDrawActions ) and action_data then
			--local ttttt = GameGetRealWorldTimeSinceStarted()
			gokiui.z_set( gui, 100 )
			local columns = 20
			local icon_width = 16
			local icon_height = 16
			for _,player in pairs(EntityGetWithTag("player_unit")) do
				local last_draw = EntityGetVariableString( player, "gkbrkn_last_draw", "" )
				if #last_draw > 0 then
					local draws = {}
					for id in EntityGetVariableString( player, "gkbrkn_last_draw", "" ):gmatch('([^,]+)') do
						table.insert( draws, id )
					end
					local x = 0
					local y = 0
					GuiOptionsAdd( gui, GUI_OPTION.NonInteractive )
					GuiOptionsAdd( gui, GUI_OPTION.Layout_NoLayouting )
					GuiLayoutBeginHorizontal( gui, 0, 0 )
					local px, py = EntityGetTransform( player )
					local ox, oy = get_screen_position( px, py )
					ox = ox
					oy = oy + 16
					for _,id in pairs(draws) do
						local sx = math.min( columns, #draws - y * columns ) * 0.5 * icon_width
						GuiImage( gui, next_id(), ox + x * icon_width - sx, oy + y * icon_height, action_data[id].sprite, 1, 1, 0 )
						x = x + 1
						if x >= columns then
							x = 0
							y = y + 1
						end
					end
					GuiLayoutEnd( gui )
					GuiOptionsRemove( gui, GUI_OPTION.Layout_NoLayouting )
					GuiOptionsRemove( gui, GUI_OPTION.NonInteractive )
				end
			end
			--GamePrint((GameGetRealWorldTimeSinceStarted() - ttttt) * 1000)
		end

		if is_inventory_open and setting_get( FLAGS.WandOrganizationButtons, false ) then
			if WAND_HELPER.can_player_edit_wands() then
				handle_function_call_queue()
				do_inventory_buttons()
				local j = 1
				for _,i in pairs(WAND_HELPER.player_get_filled_wand_slots()) do
					do_wand_buttons( j )
					j = j + 1
				end
			end
		end

		if setting_get( MISC.ShowFPS.EnabledFlag, false ) then
			local mod_button_reservation_max_width = tonumber( GlobalsGetValue( "mod_button_tr_current", "0" ) )
			GlobalsSetValue( "mod_button_tr_current", tostring(mod_button_reservation_max_width + 15) )
			local fps = tonumber( GlobalsGetValue( "gkbrkn_fps","0" ) )
			local width = GuiGetTextDimensions( gui, GlobalsGetValue( "gkbrkn_fps" ) )
			GuiColorSetForNextWidget( gui, 0.0, 0.0, 0.0, 0.5 )
			gokiui.z_set_next( gui, 1 )
			GuiText( gui, screen_width - width - mod_button_reservation_max_width, 4, GlobalsGetValue( "gkbrkn_fps" ) )
			if fps > 45 then
				GuiColorSetForNextWidget( gui, 0.75, 0.75, 0.75, 1.0 )
			elseif fps > 30 then
				GuiColorSetForNextWidget( gui, 0.85, 0.85, 0.6, 1.0 )
			else
				GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 )
			end
			gokiui.z_set_next( gui, 0 )
			GuiText( gui, screen_width - width - mod_button_reservation_max_width, 3, GlobalsGetValue( "gkbrkn_fps" ) )
		end

		if not is_panel_open and not is_inventory_open and setting_get( FLAGS.DebugMode, false ) then
			GuiLayoutBeginVertical( gui, 1, 14 )
			do_stats( gui )
			GuiLayoutEnd( gui )
		end

		if is_inventory_open then
			local player = EntityGetWithTag( "player_unit" )[1]
			if player then
				if setting_get( FLAGS.InfiniteItemInventory, false ) then
					if GuiImageButton( gui, next_id(), 0, 17+0, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_left_up.png" ) then
						next_item_inventory( player, -1 )
					end
					if GuiImageButton( gui, next_id(), 0, 17+13, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_left_down.png" ) then
						next_item_inventory( player, 1 )
					end
				end
				if setting_get( FLAGS.InfiniteSpellInventory, false ) then
					if GuiImageButton( gui, next_id(), 494+17, 17+0, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_right_up.png" ) then
						next_spell_inventory( player, -1 )
					end
					if GuiImageButton( gui, next_id(), 494+17, 17+13, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_right_down.png" ) then
						next_spell_inventory( player, 1 )
					end
				end
			end
		end
	end

	GuiIdPop( gui )

	settings_broadcast_changes()
	--##DEV STATS.add_and_count("do_gui",(GameGetRealWorldTimeSinceStarted() - t))
end

function OnPausedChanged( is_paused, is_inventory_pause )
	is_panel_open = false
	is_game_paused = is_paused
	hide_menu_frame = GameGetFrameNum() + 300
	hidden = false
end

print("[goki's things] done setting up GUI")

return do_gui