if initialized == nil then initialized = false; end

if initialized == false then
    initialized = true;
    -- Force cache refresh to ensure we have the latest files
    __loaded = {};
    print("[goki's things] setting up GUI");
    MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/inventories.lua");
    dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua");
    dofile_once( "data/scripts/lib/coroutines.lua" );
    dofile_once( "data/scripts/lib/utilities.lua" );

    SetRandomSeed( 137, 931 );

    -- TODO: this is a temporary solution, fix this later
    local CONTENT = {};
    GKBRKN_CONFIG.parse_content( false, true, CONTENT );
    local SETTINGS                      = GKBRKN_CONFIG.SETTINGS;
    local OPTIONS                       = GKBRKN_CONFIG.OPTIONS;
    local CONTENT_ACTIVATION_TYPE       = GKBRKN_CONFIG.CONTENT_ACTIVATION_TYPE;
    local SCREEN = {
        Closed = 0,
        Info = 1,
        Options = 2,
        ContentSelection = 3,
        ContentTypeSelection = 4,
    }

    local sorted_content = {};
    local content_counts = {};
    local content_type_selection = {};
    local content_type = nil;
    local tip_index = math.ceil( Random() * #MISC.ShowModTips.Tips );
    local tip = GameTextGetTranslatedOrNot( MISC.ShowModTips.Tips[tip_index] );
    local z_index = -9000;

    local function previous_data( gui )
        local left_click,right_click,hover,x,y,width,height,draw_x,draw_y = GuiGetPreviousWidgetInfo( gui );
        if left_click == 1 then left_click = true; elseif left_click == 0 then left_click = false; end
        if right_click == 1 then right_click = true; elseif right_click == 0 then right_click = false; end
        if hover == 1 then hover = true; elseif hover == 0 then hover = false; end
        return left_click,right_click,hover,x,y,width,height,draw_x,draw_y;
    end

    local word_wrap = function( str, wrap_size )
        if wrap_size == nil then wrap_size = 60; end
        local last_space_index = 1;
        local last_wrap_index = 0;
        for i=1,#str do
            if str:sub(i,i) == " " then
                last_space_index = i;
            end
            if str:sub(i,i) == "\n" then
                last_space_index = i;
                last_wrap_index = i;
            end
            if i - last_wrap_index > wrap_size then
                str = str:sub(1,last_space_index-1) .. "\n" .. str:sub(last_space_index + 1);
                last_wrap_index = i;
            end
        end
        return str;
    end

    function is_action_unlocked( action )
        local valid = false;
        if action then
            if action.spawn_requires_flag ~= nil then
                local flag_name = action.spawn_requires_flag;
                local flag_status = HasFlagPersistent( flag_name );
                if flag_status then valid = true; end
                -- Music Notes
                --if action.spawn_probability == "0" then  valid = false; end
            else
                valid = true;
            end
            return valid;
        end
    end

    local function truncate_long_string( str )
        if #str > 31 then
            str = str:sub( 0, 14 ).."..."..str:sub( -14 );
        end
        return str;
    end

    local function pattern_validation( value )
        local status,result = pcall( function() local s = string.format( value, 0,0,0,0,0,0,0,0 ); end );
        if status == false then
            return result;
        end 
        return true;
    end

    local function safe_string_format( format, ... )
        local s = "";
        local status,result = pcall( function(...)
            s = string.format( format, ... );
        end, ... );
        if status == false then return "err"; end 
        return s;
    end

    local gui = gui or GuiCreate();
    local full_screen_width, full_screen_height = GuiGetScreenDimensions( gui );
    GuiStartFrame( gui );
    local screen_width, screen_height = GuiGetScreenDimensions( gui );

    local action_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/action_data.lua" )( true );
    local perk_data = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/perk_data.lua" )();

    local mod_settings_id = "gkbrkn_noita";
    local gokiui = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/gokiui.lua" )( gui, 0, mod_settings_id, z_index );
    local next_id = gokiui.next_id;
    local reset_id = gokiui.reset_id;
    local iterate_settings = gokiui.iterate_settings;
    local refresh_settings = gokiui.refresh_settings;
    local do_custom_tooltip = gokiui.do_custom_tooltip;
    local set_setting = function( setting, value )
        if value ~= nil then
            ModSettingSet( mod_settings_id.."."..setting.key, value );
            setting.current = value;
        end
    end

    function disable_starting_perks()
        for k,v in pairs( perk_data ) do
            setting_clear( "sp_perk_"..v.id );
        end
    end

    function toggle_vanilla()
        iterate_settings( function( setting )
            if setting.type_data ~= nil and setting.type_data.content ~= nil then
                set_setting( setting, false );
            else
                set_setting( setting, setting.disable );
            end
        end );
        setting_set( FLAGS.DisableNewContent, true );
        disable_starting_perks();
        refresh_settings();
    end

    function toggle_default()
        iterate_settings( function( setting )
            if setting.type_data ~= nil and setting.type_data.content ~= nil then
                set_setting( setting, setting.default );
            else
                set_setting( setting, setting.default );
            end
        end );
        disable_starting_perks();
        refresh_settings();
    end

    function toggle_content_by_tag( tag, skip_default )
        iterate_settings( function( setting )
            if setting.type_data ~= nil and setting.type_data.content ~= nil then
                if setting.type_data.content.tags[tag] then
                    set_setting( setting, true );
                elseif skip_default ~= true then
                    set_setting( setting, setting.default );
                end
            else
                if setting.tags[tag] then
                    set_setting( setting, true );
                elseif skip_default ~= true then
                    set_setting( setting, setting.default );
                end
            end
        end );
    end

    for index,content in pairs( CONTENT ) do
        if content.visible() then
            table.insert( sorted_content, {
                id=index,
                type=content.type,
                name=GameTextGetTranslatedOrNot( content.name ) or ( "missing content name: "..index ),
                author=GameTextGetTranslatedOrNot( content.options.author or "Unknown" )
            } );
            content_counts[content.type] = ( content_counts[content.type] or 0 ) + 1;
        end
    end

    table.sort( sorted_content, function( a, b )
        if a.author:lower() == b.author:lower() then
            return a.name:lower() < b.name:lower();
        else
            return a.author:lower() < b.author:lower();
        end
    end );

    function filter_content( content_list, content_type, content_table )
        if content_table == nil then content_table = CONTENT; end
        local filtered = {};
        for _,content in pairs( content_list ) do
            if content.type == content_type then
                table.insert( filtered, content.id );
            end
        end
        return filtered;
    end

    local basic_content_callback = function( setting )
        local setting_data = setting.type_data;
        local toggle = false;
        local deprecated = setting_data.content.deprecated;
        if not deprecated or setting_get( FLAGS.ShowDeprecatedContent ) then
            local left_click, right_click = GuiImageButton( gui, next_id(), 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (setting.current == true and "_fill" or "") .. ".png" );
            if setting.current == false then GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 ); end
            local alt_left_click, alt_right_click = GuiButton( gui, next_id(), 0, 0, setting_data.content.name );
            if setting.tooltip then GuiTooltip( gui, setting_data.content.description, ""); end
            if left_click == true or alt_left_click == true then
                setting.current = not setting.current;
                setting_set( setting.key, setting.current );
            end
            if right_click == true or alt_right_click == true then
                if setting_data.content ~= nil then
                    if setting_data.content.options and setting_data.content.options.preview_callback ~= nil then
                        setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] );
                    end
                end
            end
        end
    end

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

    local setting_callbacks = {
        pack = basic_content_callback,
        item = basic_content_callback,
        game_modifier = basic_content_callback,
        dev_option = basic_content_callback,
        legendary_wand = basic_content_callback,
        champion_type = function( setting )
            local setting_data = setting.type_data;
            if setting_data then
                local champion_type_data = setting_data.content;
                local toggle = false;
                local deprecated = setting_data.content.deprecated == true;
                if setting.current ~= true then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent );
                    GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                end
                if deprecated == true and setting_get( FLAGS.ShowDeprecatedContent ) == false then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent );
                    GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 );
                end
                GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
                local hover_data = nil;
                if champion_type_data then
                    local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", champion_type_data.sprite );
                    if left_click then
                        toggle = true;
                    end
                elseif setting_data.content.sprite then
                    local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", setting_data.content.sprite );
                    if left_click then
                        toggle = true;
                    end
                else
                    local left_click, right_click = GuiButton( gui, next_id(), 0, 0, (setting.current == true and "[x] " or "[ ] ")..GameTextGetTranslatedOrNot( setting_data.content.name ) );
                    if left_click then
                        toggle = true;
                    end
                end
                --GuiTooltip( gui, GameTextGetTranslatedOrNot( setting_data.content.description ), "" );
                do_custom_tooltip( function()
                    GuiLayoutBeginVertical( gui, 0, 0 );
                        GuiLayoutBeginHorizontal( gui, 0, 0 );
                            GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) );
                            GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                            GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  );
                        GuiLayoutEnd( gui );
                        GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                        GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ), 50 ) );
                        if deprecated then
                            if setting_get( FLAGS.ShowDeprecatedContent ) == false then
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated and will not appear in-game" ) );
                            else
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 1.0, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated, but your settings allow it to appear in-game" )  );
                            end
                        end
                        if champion_type_data == nil then
                            GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is not currently loaded and can not be spawned" ) );
                        end
                    GuiLayoutEnd( gui );
                end, z_index - 12 );
                GuiZSet( gui, z_index );
                if hover_data then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                    -- TODO use constants for specific layers
                    GuiZSetForNextWidget( gui, z_index - 1 );
                    GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/locked.png", 1.0, 1.0, 0 );
                end
                if toggle then
                    setting.current = not setting.current;
                    set_setting( setting, setting.current );
                end
            end
        end,
        tweak = basic_content_callback,
        loadout = basic_content_callback,
        action = function( setting )
            local setting_data = setting.type_data;
            local deprecated = setting_data.content.deprecated == true;
            if action_data ~= nil and ( deprecated == false or setting_get( FLAGS.ShowDeprecatedContent ) ) then
                local this_action_data = action_data[setting_data.content.key];
                local toggle = false;
                local managed = setting_get( MISC.ManageExternalContent.EnabledFlag ) == true or setting_data.content.local_content == true;
                local semi_transparent = false;
                local has_progress = HasFlagPersistent( "action_"..this_action_data.id:lower() );
                if is_action_unlocked( this_action_data ) == false then
                    semi_transparent = true;
                end
                if setting.current ~= true and managed == true then
                    semi_transparent = true;
                    GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                end
                if deprecated == true and setting_get( FLAGS.ShowDeprecatedContent ) == false and managed == true then
                    semi_transparent = true;
                    GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 );
                end
                GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
                local hover_data = nil;
                if this_action_data then
                    GuiZSetForNextWidget( gui, z_index + 2 );
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Disabled );
                    local left_click, right_click;
                    local spell_icon_x = 0;
                    local spell_icon_y = 0;
                    if setting_get( FLAGS.ShowSpellBorders ) then
                        if semi_transparent then GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent ); end
                        GuiImage( gui, next_id(), 0, 0, action_type_to_border_sprite[ this_action_data.type ], 1.0, 1.0, 0 );
                        spell_icon_x = -20;
                        spell_icon_y = 2;
                    else
                        spell_icon_x = 0;
                        spell_icon_y = 0;
                    end
                    if setting_get( FLAGS.ShowSpellProgress ) and not has_progress then
                        GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWaveAnimateOpacity );
                        GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.0, 1.0 );
                    end
                    if semi_transparent then GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent ); end
                    left_click, right_click = GuiImageButton( gui, next_id(), spell_icon_x, spell_icon_y, "", this_action_data.sprite );
                    if left_click then
                        toggle = true;
                    elseif right_click then
                        if setting_data.content.options.preview_callback ~= nil and this_action_data.enabled then
                            setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] );
                        end
                    end
                    if is_action_unlocked( this_action_data ) == false then
                        hover_data = { previous_data( gui ) };
                    end
                elseif setting_data.content.sprite then
                    local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", setting_data.content.sprite );
                    if left_click then
                        toggle = true;
                    end
                else
                    local left_click, right_click = GuiButton( gui, next_id(), 0, 0, (setting.current == true and "[x] " or "[ ] ")..GameTextGetTranslatedOrNot( setting_data.content.name ) );
                    if left_click then
                        toggle = true;
                    end
                end
                --GuiTooltip( gui, GameTextGetTranslatedOrNot( setting_data.content.description ), "" );
                do_custom_tooltip( function()
                    GuiLayoutBeginVertical( gui, 0, 0 );
                        GuiLayoutBeginHorizontal( gui, 0, 0 );
                            GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) );
                            GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                            GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  );
                        GuiLayoutEnd( gui );
                        GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                        GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ), 50 ) );
                        if is_action_unlocked( this_action_data ) == false then
                            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is not unlocked and will not appear in-game\nSpawning this content will unlock it permanently" ) );
                        end
                        if not has_progress then
                            GuiColorSetForNextWidget( gui, 0.50, 0.75, 0.50, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is not yet in the progress menu" ) );
                        end
                        if not managed then
                            GuiColorSetForNextWidget( gui, 1.0, 0.0, 1.0, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is external and not managed by Goki's Things" ) );
                        end
                        if deprecated then
                            if setting_get( FLAGS.ShowDeprecatedContent ) == false then
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated and will not appear in-game" ) );
                            else
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 1.0, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated, but your settings allow it to appear in-game" )  );
                            end
                        end
                        if this_action_data.enabled == false then
                            GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is not currently loaded and can not be spawned" ) );
                        end
                    GuiLayoutEnd( gui );
                end, z_index - 12 );
                GuiZSet( gui, z_index );
                if hover_data then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                    -- TODO use constants for specific layers
                    GuiZSetForNextWidget( gui, z_index - 1 );
                    GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/locked.png", 1.0, 1.0, 0 );
                end
                if toggle then
                    setting.current = not setting.current;
                    set_setting( setting, setting.current );
                end
            end
        end,
        perk = function( setting )
            local setting_data = setting.type_data;
            local deprecated = setting_data.content.deprecated == true;
            if perk_data ~= nil then
                local this_perk_data = perk_data[setting_data.content.key];
                local toggle = false;
                local starting_perk = setting_get( "sp_"..setting.key );
                local managed = setting_get( MISC.ManageExternalContent.EnabledFlag ) == true or setting_data.content.local_content == true;
                if starting_perk == true then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWobble );
                end
                if setting.current ~= true and managed == true then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent );
                    GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                end
                if deprecated == true and setting_get( FLAGS.ShowDeprecatedContent ) == false and managed == true then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent );
                    GuiColorSetForNextWidget( gui, 0.25, 0.25, 0.25, 1.0 );
                end
                if this_perk_data.enabled == true and this_perk_data.missing == true then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawWaveAnimateOpacity );
                end
                GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
                local hover_data = nil;
                if this_perk_data then
                    local left_click, right_click = GuiImageButton( gui, next_id(), 0, 0, "", this_perk_data.perk_icon );
                    if left_click then
                        toggle = true;
                    elseif right_click then
                        if setting_data.content.options.preview_callback ~= nil then
                            setting_data.content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] );
                        end
                    end
                    if this_perk_data.missing == true or this_perk_data.stackable == true then
                        hover_data = { previous_data( gui ) };
                    end
                end
                do_custom_tooltip( function()
                    GuiLayoutBeginVertical( gui, 0, 0 );
                        GuiLayoutBeginHorizontal( gui, 0, 0 );
                            GuiText( gui, 0, 0, GameTextGetTranslatedOrNot( setting_data.content.name ) );
                            GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                            GuiText( gui, 2, 0, "by "..(GameTextGetTranslatedOrNot(setting_data.content.author) or "Unknown")  );
                        GuiLayoutEnd( gui );
                        
                        GuiLayoutAddVerticalSpacing( gui, -2 );
                        GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                        GuiText( gui, 0, 0, this_perk_data.id );

                        GuiLayoutAddVerticalSpacing( gui, 2 );
                        GuiColorSetForNextWidget( gui, 0.811, 0.811, 0.811, 1.0 );
                        GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( setting_data.content.description ), 50 ) );
                        if this_perk_data.stackable then
                            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This perk is stackable" ) );
                        end
                        if this_perk_data.not_in_pool then
                            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This perk is not in the perk pool" ) );
                        elseif this_perk_data.missing then
                            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                            -- TODO localize
                            if not setting_get( MISC.PerkRewrite.NewLogicFlag ) then
                                GuiText( gui, 0, 0, word_wrap( "This perk is not in the perk pool for this run" ) );
                            else
                                GuiText( gui, 0, 0, word_wrap( "This perk will take a long time to roll into" ) );
                            end
                        end
                        if starting_perk == true and not deprecated then
                            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "You will start with this perk on your next run" ) );
                        end
                        if not managed then
                            GuiColorSetForNextWidget( gui, 1.0, 0., 1.0, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is external and not managed by Goki's Things" ) );
                        end
                        if deprecated then
                            if setting_get( FLAGS.ShowDeprecatedContent ) == false then
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated and will not appear in-game" ) );
                            else
                                GuiColorSetForNextWidget( gui, 1.0, 0.5, 1.0, 1.0 );
                                -- TODO localize
                                GuiText( gui, 0, 0, word_wrap( "This content is deprecated, but your settings allow it to appear in-game" )  );
                            end
                        end
                        if this_perk_data == nil then
                            GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
                            -- TODO localize
                            GuiText( gui, 0, 0, word_wrap( "This content is not currently loaded and can not be spawned" ) );
                        end
                    GuiLayoutEnd( gui );
                end, z_index - 12 );
                GuiZSet( gui, z_index );
                if hover_data then
                    if this_perk_data.enabled == true then
                        if this_perk_data.not_in_pool == true then
                            GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                            GuiZSetForNextWidget( gui, z_index - 1 );
                            GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/perk_not_in_pool.png", 1.0, 1.0, 0 );
                        elseif this_perk_data.missing == true then
                            GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                            GuiZSetForNextWidget( gui, z_index - 1 );
                            if setting_get( MISC.PerkRewrite.NewLogicFlag ) then
                                GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/perk_deep_in_pool.png", 1.0, 1.0, 0 );
                            else
                                GuiImage( gui, next_id(), hover_data[8] - 2, hover_data[9] - 2, "mods/gkbrkn_noita/files/gkbrkn/gui/missing_perk.png", 1.0, 1.0, 0 );
                            end
                        end
                    end
                    if this_perk_data.stackable == true then
                        GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                        GuiZSetForNextWidget( gui, z_index - 1 );
                        GuiImage( gui, next_id(), hover_data[8] + 12, hover_data[9] - 1, "mods/gkbrkn_noita/files/gkbrkn/gui/stackable_perk.png", 1.0, 1.0, 0 );
                    end
                end
                if toggle then
                    if setting.current == false then
                        set_setting( setting, true );
                        if not managed then
                            setting_set( "sp_"..setting.key, true );
                        end
                    elseif setting.current == true and setting_get( "sp_"..setting.key ) == nil then
                        setting_set( "sp_"..setting.key, true );
                    else
                        setting_clear( "sp_"..setting.key );
                        if managed then
                            set_setting( setting, false );
                        else
                            set_setting( setting, true );
                        end
                    end
                end
            end
        end
    }

    function get_screen_position( x, y )
        local screen_width, screen_height = GuiGetScreenDimensions( gui );
        local camera_x, camera_y = GameGetCameraPos();
        local res_width = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_X" );
        local res_height = MagicNumbersGetValue( "VIRTUAL_RESOLUTION_Y" );
        local ax = (x - camera_x) / res_width * screen_width;
        local ay = (y - camera_y) / res_height * screen_height;
        return ax + screen_width * 0.5, ay + screen_height * 0.5;
    end

    function do_special_button( button_text, description_text )
        GuiLayoutBeginHorizontal( gui, 0, 0 );
            GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
            local left_click, right_click = GuiButton( gui, 0, 0, button_text, next_id() );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            GuiText( gui, 0, 0, description_text );
        GuiLayoutEnd( gui );
        return left_click, right_click;
    end

    local group_callbacks;
    group_callbacks = {
        start_page = function( group_setting )
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiText( gui, 0, 0, "Welcome to")
                GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                GuiText( gui, 0, 0, "Goki's Things")
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                GuiText( gui, 0, 0, SETTINGS.Version)
            GuiLayoutEnd( gui );

            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                GuiText( gui, 0, 0, "Love Goki's Things? Donate at" );
                GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                GuiText( gui, 0, 0, "ko-fi.com/goki_dev" );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                GuiText( gui, 0, 0, "to support what I do!" );
            GuiLayoutEnd( gui );
            

            GuiText( gui, 0, 0, " ");
            GuiText( gui, 0, 0, "Choose a tab up above to customize the mod or choose one of the presets below!")
            GuiText( gui, 0, 0, "Press one of the buttons below to select a preset. Be careful, you can't undo this!");
            GuiText( gui, 0, 0, " ");
            
            
            if do_special_button( "[Default]", "Reset Goki's Things to default settings" ) then
                toggle_default();
                GamePrint( "Reset Goki's Things to its default settings" );
            end

            if do_special_button( "[Vanilla]", "Turn off all custom Goki's Things content" ) then
                toggle_vanilla();
                GamePrint( "Disabled all custom content" );
            end

            GuiText( gui, 0, 0, " " );

            if do_special_button( "[Champions Mode]", "Enemies have special modifiers that change up the combat" ) then
                toggle_content_by_tag("champions_mode");
                GamePrint( "Enabled Champions Mode options" );
            end

            if do_special_button( "[Hero Mode]", "Enemies are tougher and the final boss has a higher minimum health" ) then
                toggle_content_by_tag("hero_mode");
                GamePrint( "Enabled Hero Mode options" );
            end

            if do_special_button( "[Ultimate Challenge Mode]", "Enable the Ultimate Hero + Ultimate Champion game modes" ) then
                toggle_content_by_tag("ultimate_challenge");
                GamePrint( "Enabled Ultimate Challenge Mode options" );
            end

            if do_special_button( "[Goki Mode]", "Apply the settings Goki prefers to use (this is a difficult mode)" ) then
                toggle_default();
                toggle_content_by_tag("goki_thing");
                GamePrint( "Enabled Goki Mode options" );
            end

            if do_special_button( "[???? Mode]", "An intense untested difficulty mode (taking name suggestions)" ) then
                toggle_default();
                toggle_content_by_tag("carnage");
                GamePrint( "Enabled ???? Mode options" );
            end

            GuiText( gui, 0, 0, " ");

            if do_special_button( "[Random Starts]", "Start runs with random equipment" ) then
                toggle_content_by_tag("random_starts");
                setting_set( MISC.RandomStart.RandomPerksFlag, 1 );
                refresh_settings();
                GamePrint( "Enabled Random Starts options" );
            end

            if do_special_button( "[Loadouts]", "Allow Goki's Things to manage loadouts and start runs with a random loadout" ) then
                toggle_content_by_tag("loadouts");
                for _,content in pairs( CONTENT ) do
                    if content.type == "loadout" or content.type == "action" or content.type == "perk" then
                        content.toggle( true );
                    end
                end
                GamePrint( "Enabled loadout management and all loadouts" );
            end

            GuiText( gui, 0, 0, " ");

            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                GuiText( gui, 0, 0, "Goki Says: " );
                GuiText( gui, 0, 0, tip );
            GuiLayoutEnd( gui );
        end,
        pack = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Packs by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            for _,setting in pairs( group_setting.settings or {} ) do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    setting_callbacks.pack( setting );
                GuiLayoutEnd( gui );
            end
        end,
        pack_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click packs to turn them on or off - Right Click packs to acquire them" );
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Packs are an incomplete system and there aren't enough packs for fulfilling gameplay (WIP)" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse packs you add to mods/gkbrkn_noita/files/gkbrkn/content/packs.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.pack( group );
                end
            GuiLayoutEnd( gui );
        end,
        item = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Items by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
                for _,setting in pairs( group_setting.settings or {} ) do
                    GuiLayoutBeginHorizontal( gui, 1, 0 );
                        setting_callbacks.item( setting );
                    GuiLayoutEnd( gui );
                end
        end,
        item_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click items to turn them on or off - Right Click items to acquire them" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse items you add to mods/gkbrkn_noita/files/gkbrkn/content/items.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.item( group );
                end
            GuiLayoutEnd( gui );
        end,
        game_modifier = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Game Modifiers by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            for _,setting in pairs( group_setting.settings or {} ) do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    setting_callbacks.game_modifier( setting );
                GuiLayoutEnd( gui );
            end
        end,
        game_modifier_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click game modifiers to turn them on or off" );
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Changes to game modifiers require a new game and persist throughout the run" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse game modifiers you add to mods/gkbrkn_noita/files/gkbrkn/content/game_modifiers.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.game_modifier( group );
                end
            GuiLayoutEnd( gui );
        end,
        dev_option = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Cheats by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            for _,setting in pairs( group_setting.settings or {} ) do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    setting_callbacks.dev_option( setting );
                GuiLayoutEnd( gui );
            end
        end,
        dev_option_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click cheats to turn them on or off" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse cheats you add to mods/gkbrkn_noita/files/gkbrkn/content/dev_options.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.dev_option( group );
                end
            GuiLayoutEnd( gui );
        end,
        legendary_wand = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Unique Wands by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
                for _,setting in pairs( group_setting.settings or {} ) do
                    GuiLayoutBeginHorizontal( gui, 1, 0 );
                        setting_callbacks.legendary_wand( setting );
                    GuiLayoutEnd( gui );
                end
        end,
        legendary_wand_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click unique wands to turn them on or off - Right Click Unique Wands to acquire them" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse an unique wands you add to mods/gkbrkn_noita/files/gkbrkn/content/legendary_wands.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.legendary_wand( group );
                end
            GuiLayoutEnd( gui );
        end,
        champion_type = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Champions by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            local setting_index = 1;
            local setting = group_setting.settings[setting_index];
            local adjusted_columns = math.max( 6, math.min( (#group_setting.settings) ^ 0.75, 16 ) );
            while setting ~= nil do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    for x=1,adjusted_columns do
                        setting = group_setting.settings[setting_index];
                        if setting then
                            setting_callbacks.champion_type( setting );
                        else
                            break;
                        end
                        setting_index = setting_index + 1;
                    end
                GuiLayoutEnd( gui );
            end
        end,
        champion_type_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click champions to turn them on or off" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse champions you add to mods/gkbrkn_noita/files/gkbrkn/content/champion_types.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings) do
                    group_callbacks.champion_type( group );
                end
            GuiLayoutEnd( gui );
        end,
        tweak = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Tweaks by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
                for _,setting in pairs( group_setting.settings or {} ) do
                    GuiLayoutBeginHorizontal( gui, 1, 0 );
                        setting_callbacks.tweak( setting );
                    GuiLayoutEnd( gui );
                end
        end,
        tweak_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click tweaks to turn them on or off" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse Tweaks you add to mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.tweak( group );
                end
            GuiLayoutEnd( gui );
        end,
        loadout = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Loadouts by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
                for _,setting in pairs( group_setting.settings or {} ) do
                    GuiLayoutBeginHorizontal( gui, 1, 0 );
                        setting_callbacks.loadout( setting );
                    GuiLayoutEnd( gui );
                end
        end,
        loadout_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click loadouts to turn them on or off - Right Click loadouts to acquire them" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse loadouts you add to mods/gkbrkn_noita/files/gkbrkn/content/loadouts.lua!" ), "" );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.loadout( group );
                end
            GuiLayoutEnd( gui );
        end,
        action = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Spells by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            local setting_index = 1;
            local setting = group_setting.settings[setting_index];
            local adjusted_columns = math.max( 6, math.min( (#group_setting.settings) ^ 0.75, 16 ) );
            while setting ~= nil do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    local x = 1;
                    while x < adjusted_columns do
                        setting = group_setting.settings[setting_index];
                        setting_index = setting_index + 1;
                        if setting then
                            if setting.type_data.content.deprecated ~= true or setting_get( FLAGS.ShowDeprecatedContent ) == true then
                                setting_callbacks.action( setting );
                                x = x + 1;
                            end
                        else
                            break;
                        end
                    end
                GuiLayoutEnd( gui );
                GuiLayoutAddVerticalSpacing( gui, -2 );
            end
        end,
        action_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click spells to turn them on or off - Right Click spells to spawn them" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse an author variable on the spells you add to gun_actions.lua and separate by author here!" ), "" );
            end
            if gokiui.do_boolean( gui, next_id(), 0, 0, "$option_name_gkbrkn_show_spell_progress", setting_get( FLAGS.ShowSpellProgress ), "$option_desc_gkbrkn_show_spell_progress" ) then
                setting_set( FLAGS.ShowSpellProgress, not setting_get( FLAGS.ShowSpellProgress ) );
            end
            if gokiui.do_boolean( gui, next_id(), 0, 0, "$option_name_gkbrkn_show_spell_borders", setting_get( FLAGS.ShowSpellBorders ), "$option_desc_gkbrkn_show_spell_borders" ) then
                setting_set( FLAGS.ShowSpellBorders, not setting_get( FLAGS.ShowSpellBorders ) );
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings) do
                    group_callbacks.action( group );
                end
            GuiLayoutEnd( gui );
        end,
        perk = function( group_setting )
            GuiLayoutAddVerticalSpacing( gui, 10 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                GuiColorSetForNextWidget( gui, 0.5, 0.5, 1.0, 1.0 );
                GuiText( gui, 0, 0, "Perks by "..group_setting.settings[1].type_data.content.author );
                if GuiButton( gui, next_id(), 0, 0, "[Enable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, true );
                    end
                end
                if GuiButton( gui, next_id(), 0, 0, "[Disable All]" ) then  
                    for _,setting in pairs( group_setting.settings ) do
                        set_setting( setting, false );
                    end
                end
            GuiLayoutEnd( gui );
            local setting_index = 1;
            local setting = group_setting.settings[setting_index];
            local adjusted_columns = math.max( 6, math.min( (#group_setting.settings) ^ 0.75, 16 ) );
            while setting ~= nil do
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    local x = 1;
                    while x < adjusted_columns do
                        setting = group_setting.settings[setting_index];
                        setting_index = setting_index + 1;
                        if setting then
                            if setting.type_data.content.deprecated ~= true or setting_get( FLAGS.ShowDeprecatedContent ) == true then
                                setting_callbacks.perk( setting );
                                x = x + 1;
                            end
                        else
                            break;
                        end
                    end
                GuiLayoutEnd( gui );
            end
        end,
        perk_page = function( group_setting )
            GuiColorSetForNextWidget( gui, 1.0, 1.0, 0.5, 1.0 );
            GuiText( gui, 0, 0, "Left Click perks to cycle through their states (Off, On, Starting Perk) - Right Click perks to acquire them" );
            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
            if true --[[setting_get( MISC.ManageExternalContent.EnabledFlag )]] then
                GuiText( gui, 0, 0, "Are you a modder? Hover me for more information!" );
                GuiTooltip( gui, word_wrap( "Goki's Things will parse an author variable on the perks you add to perk_list.lua and separate by author here!" ), "" );
            end
            --[[ Perk Bar Graph
            ]]
            if setting_get( MISC.PerkRewrite.ShowBarGraphFlag ) then
                GuiImage( gui, next_id(), 0, 0, "mods/gkbrkn_noita/files/gkbrkn/gui/bar_graph.xml", 1.0, 1.0, 1.0, 0, GUI_RECT_ANIMATION_PLAYBACK.Loop, "invisible" );
                local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = previous_data( gui );
                local perk_order = perk_get_spawn_order();
                local perk_appearances = {};
                local perk_list_size = 0;
                for k,perk_data in pairs( perk_list ) do
                    perk_appearances[perk_data.id] = 0;
                    perk_list_size = perk_list_size + 1;
                end
                local most_appearances = 0;
                for k,perk_id in pairs( perk_order ) do
                    perk_appearances[perk_id] = perk_appearances[perk_id] + 1;
                    if perk_appearances[perk_id] > most_appearances then
                        most_appearances = perk_appearances[perk_id];
                    end
                end
                for i=1,perk_list_size do
                    local perk_data = perk_list[i];
                    local perk_id = perk_data.id;
                    local ratio = perk_appearances[perk_id] / most_appearances;
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                    GuiImage( gui, next_id(), x + i, y, "mods/gkbrkn_noita/files/gkbrkn/gui/bar_graph.xml", 1.0, 1.0, ( (1 - ratio) ), 0, GUI_RECT_ANIMATION_PLAYBACK.Loop, "empty" );
                    GuiTooltip( gui, perk_id .. " shows up "..perk_appearances[perk_id].. " times", "" );
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                    if ratio > 0 then
                        GuiImage( gui, next_id(), x + i, y + ( 1 - ratio ) * 50, "mods/gkbrkn_noita/files/gkbrkn/gui/bar_graph.xml", 1.0, 1.0, ratio, 0, GUI_RECT_ANIMATION_PLAYBACK.Loop, "fill" );                
                        GuiTooltip( gui, perk_id .. " shows up "..perk_appearances[perk_id].. " times", "" );
                    end
                end
            end
            GuiLayoutBeginVertical( gui, 1, 0 );
                for _,group in pairs( group_setting.settings ) do
                    group_callbacks.perk( group );
                end
            GuiLayoutEnd( gui );
        end
    }

    for _,content_type in pairs( content_types ) do
        local name = GameTextGetTranslatedOrNot( content_type.display_name );
        name = ( content_counts[content_type.id] or 0 ).." "..name;
        table.insert( content_type_selection, { name = name, type = content_type.id } );
        --table.insert( tabs, { name = name, screen = SCREEN.ContentSelection, content_type = content_type.id, development_only = content_type.development_only } );
        local filtered_content = filter_content( sorted_content, content_type.id );
        local content_table = {};
        for k,content in pairs( filtered_content ) do
            content = CONTENT[content];
            table.insert( content_table, GKBRKN_CONFIG.register_option_localized( content.settings_key, content.enabled_by_default or false, false, content_type.id, { content = content }, 2, nil, tags ) );
        end
        local grouped_content = {};
        for k,content in pairs( content_table ) do
            grouped_content[content.type_data.content.author] = grouped_content[content.type_data.content.author] or {};
            table.insert( grouped_content[content.type_data.content.author], content );
        end
        local groups = {};
        for k,group_tables in pairs(grouped_content) do
            table.insert( groups, GKBRKN_CONFIG.register_option_group( content_type.id, group_callbacks[content_type.id], unpack( group_tables ) ) )
        end
        table.insert( OPTIONS, GKBRKN_CONFIG.register_option_tab_localized( content_type.id, 1, GKBRKN_CONFIG.register_option_group( content_type.id, group_callbacks[content_type.id.."_page"], unpack( groups ) ) ) );
    end
    table.sort( content_type_selection, function( a, b ) return a.name < b.name end );

    table.insert( OPTIONS, 1, GKBRKN_CONFIG.register_option_tab_localized( "gkbrkn_start_page", 1, GKBRKN_CONFIG.register_option_group( "start_page", group_callbacks.start_page ) ) );

    if setting_get( "version" ) == nil then
        local iterate_options = {};
        for k,v in pairs( OPTIONS ) do
            table.insert( iterate_options, v );
        end
        local i = 1;
        while i < #iterate_options do
            local v = iterate_options[i];
            if v.settings ~= nil then
                for _,vv in pairs( v.settings ) do table.insert( iterate_options, vv ); end
            else
                if v.key then
                    if HasFlagPersistent( v.key ) then
                        setting_set( v.key, true );
                    else
                        setting_set( v.key, false );
                    end
                    RemoveFlagPersistent( v.key )
                end
            end
            i = i + 1;
        end
        local enabled_by_default = { 
            perk = true, 
            action = true, 
            champion_type = true, 
            legendary_wand = true, 
            loadout = true, 
            pack = true
        };
        for k,v in pairs( CONTENT ) do
            if v.settings_key then
                if HasFlagPersistent( "gkbrkn_"..v.settings_key ) then
                    if v.enabled_by_default and enabled_by_default[v.type] == true then
                        setting_set( v.settings_key, false );
                    else
                        setting_set( v.settings_key, true );
                    end
                else
                    if v.enabled_by_default and enabled_by_default[v.type] == true then
                        setting_set( v.settings_key, true );
                    else
                        setting_set( v.settings_key, false );
                    end
                end
            end
        end
        refresh_settings();
        setting_set( "version", SETTINGS.Version );
    end

    local hidden = false;
    local hide_menu_frame = GameGetFrameNum() + 300;

    function do_gui()
        local can_show = false;
        if setting_get( FLAGS.ShowWhileInInventory ) == true or not GameIsInventoryOpen() then
            can_show = true;
        end
        reset_id();
        GuiStartFrame( gui );
        GuiIdPushString( gui, "gkbrkn_noita" );
        
        if setting_get( MISC.AutoHide.EnabledFlag ) == false or hidden == false then
            GuiZSet( gui, z_index );
            GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween );
            screen_width, screen_height = GuiGetScreenDimensions( gui );
            gokiui.parse_mod_settings( OPTIONS, setting_get( FLAGS.DisableNewContent ) );
            if can_show then
                GuiLayoutBeginVertical( gui, 5, 16 );
                if is_panel_open then
                    gokiui.do_gui();
                    hide_menu_frame = GameGetFrameNum() + 300;
                    hidden = false;
                else
                    if hide_menu_frame - GameGetFrameNum() < 0 then
                        hidden = true;
                    end
                end
                GuiLayoutEnd( gui );
            end

            GuiLayoutBeginVertical( gui, 0, 0 );
                local mod_button_reservation = tonumber( GlobalsGetValue( "gkbrkn_mod_button_reservation", "0" ) );
                local current_button_reservation = tonumber( GlobalsGetValue( "mod_button_tr_current", "0" ) );
                if current_button_reservation > mod_button_reservation then
                    current_button_reservation = mod_button_reservation;
                elseif current_button_reservation < mod_button_reservation then
                    current_button_reservation = math.max( 0, mod_button_reservation + (current_button_reservation - mod_button_reservation ) );
                else
                    current_button_reservation = mod_button_reservation;
                end
                GlobalsSetValue( "mod_button_tr_current", tostring( current_button_reservation + 15 ) );

                local player = EntityGetWithTag( "player_unit" )[1];
                if player then
                    local platform_shooter_player = EntityGetFirstComponent( player, "PlatformShooterPlayerComponent" );
                    if platform_shooter_player then
                        local is_gamepad = ComponentGetValue2( platform_shooter_player, "mHasGamepadControlsPrev" );
                        if is_gamepad == true then
                            GuiOptionsAddForNextWidget( gui, GUI_OPTION.NonInteractive );
                            GuiOptionsAddForNextWidget( gui, GUI_OPTION.AlwaysClickable );
                        end
                    end
                end

                GuiOptionsAddForNextWidget( gui, GUI_OPTION.HandleDoubleClickAsClick );
                if GuiImageButton( gui, next_id(), screen_width - 14 - current_button_reservation, 2, "", "mods/gkbrkn_noita/files/gkbrkn/gui/icon.png" ) then
                    GamePlaySound( "data/audio/Desktop/ui.bank", "ui/button_click", GameGetCameraPos() );
                    is_panel_open = not is_panel_open;
                end
                local width = GuiGetTextDimensions( gui, "Configure Goki's Things" );
                do_custom_tooltip( function()
                    GuiText( gui, 0, 0, "Configure Goki's Things" );
                    GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                    GuiText( gui, 0, 0, SETTINGS.Version );
                end, -100, -width - 24, 10 );
            GuiLayoutEnd( gui );
            GuiOptionsRemove( gui, GUI_OPTION.NoPositionTween );

            if is_panel_open then
                if not GameHasFlagRun( FLAGS.ConfigMenuOpen ) then
                    GameAddFlagRun( FLAGS.ConfigMenuOpen );
                end
            else
                if GameHasFlagRun( FLAGS.ConfigMenuOpen ) then
                    GameRemoveFlagRun( FLAGS.ConfigMenuOpen );
                end
            end
        end

        if setting_get( MISC.ShowFPS.EnabledFlag ) then
            local mod_button_reservation_max_width = tonumber( GlobalsGetValue( "gkbrkn_mod_button_tr_max", "0" ) );
            local fps = tonumber( GlobalsGetValue( "gkbrkn_fps","0" ) );
            local width = GuiGetTextDimensions( gui, GlobalsGetValue( "gkbrkn_fps" ) );
            if fps > 45 then
                GuiColorSetForNextWidget( gui, 0.75, 0.75, 0.75, 1.0 );
            elseif fps > 30 then
                GuiColorSetForNextWidget( gui, 0.85, 0.85, 0.6, 1.0 );
            else
                GuiColorSetForNextWidget( gui, 1.0, 0.5, 0.5, 1.0 );
            end
            GuiZSetForNextWidget( gui, 0 );
            GuiText( gui, screen_width - width - mod_button_reservation_max_width, 3, GlobalsGetValue( "gkbrkn_fps" ) );
        end

        if setting_get( FLAGS.DebugMode ) then
            GuiColorSetForNextWidget( gui, 0.20, 0.60, 1.00, 1.0 );
            local text = decimal_format( get_update_time() * 1000, 2 ) .."ms/pu "..decimal_format( get_frame_time() * 1000, 2 ).."ms/ft";
            reset_update_time();
            reset_frame_time();
            local width,height = GuiGetTextDimensions( gui, text );
            GuiText( gui, screen_width - width, screen_height - height, text );
        end

        if GameIsInventoryOpen() and setting_get( MISC.InfiniteInventory.EnabledFlag ) then
            GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween );
            local player = EntityGetWithTag( "player_unit" )[1];
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.HandleDoubleClickAsClick );
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
            if GuiImageButton( gui, next_id(), 0, 17+0, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_left_up.png" ) then
                next_item_inventory( player, -1 );
            end
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.HandleDoubleClickAsClick );
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
            if GuiImageButton( gui, next_id(), 0, 17+13, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_left_down.png" ) then
                next_item_inventory( player, 1 );
            end
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.HandleDoubleClickAsClick );
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
            if GuiImageButton( gui, next_id(), 494+17, 17+0, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_right_up.png" ) then
                next_spell_inventory( player, -1 );
            end
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.HandleDoubleClickAsClick );
            GuiOptionsAddForNextWidget( gui, GUI_OPTION.ClickCancelsDoubleClick );
            if GuiImageButton( gui, next_id(), 494+17, 17+13, "", "mods/gkbrkn_noita/files/gkbrkn/gui/inventory_button_right_down.png" ) then
                next_spell_inventory( player, 1 );
            end
            GuiOptionsRemove( gui, GUI_OPTION.NoPositionTween );
        end

        GuiIdPop( gui );
    end
    print("[goki's things] done setting up GUI");
end

do_gui();