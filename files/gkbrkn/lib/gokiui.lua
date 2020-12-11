return function( gui, gui_id, mod_settings_id, z_index )
    local full_screen_width, full_screen_height = GuiGetScreenDimensions( gui );
    GuiStartFrame( gui );
    local screen_width, screen_height = GuiGetScreenDimensions( gui );
    local id_offset = 0;
    local current_tab = nil;
    local mod_settings = nil;
    local z_index = z_index or 0;
     
    local function previous_data( gui )
        local left_click,right_click,hover,x,y,width,height,draw_x,draw_y = GuiGetPreviousWidgetInfo( gui );
        if left_click == 1 then left_click = true; elseif left_click == 0 then left_click = false; end
        if right_click == 1 then right_click = true; elseif right_click == 0 then right_click = false; end
        if hover == 1 then hover = true; elseif hover == 0 then hover = false; end
        return left_click,right_click,hover,x,y,width,height,draw_x,draw_y;
    end

    local function word_wrap( str, wrap_size )
        if str then
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
        return "";
    end

    local function reset_id()
        id_offset = 1;
    end

    local function next_id( amount )
        if amount == nil then amount = 1; end
        local current_id = id_offset + 1;
        id_offset = id_offset + amount;
        return gui_id + current_id;
    end

    local function iterate_settings( callback, settings )
        if settings == nil then settings = mod_settings; end
        for _,setting in pairs( settings or {} ) do
            if setting then
                if setting.settings ~= nil then
                    iterate_settings( callback, setting.settings );
                else
                    callback( setting );
                end
            end
        end
    end

    local function refresh_settings()
        iterate_settings( function( setting )
            setting.current = ModSettingGet( mod_settings_id.."."..setting.key );
        end );
    end

    local is_panel_open = false;
    local has_been_parsed = false;
    local function parse_mod_settings( parse_mod_settings, disable_new_settings )
        mod_settings = parse_mod_settings;
        if not has_been_parsed then
            has_been_parsed = true;
            local function parse_setting( setting )
                if setting.group_label ~= nil or setting.tab_label ~= nil then
                    for k,v in pairs( setting.settings ) do
                        parse_setting( v );
                    end
                else
                    if setting.default ~= nil then
                        if ModSettingGet( mod_settings_id.."."..setting.key ) == nil then
                            if disable_new_settings == true then
                                ModSettingSet( mod_settings_id.."."..setting.key, setting.disable );
                            else
                                ModSettingSet( mod_settings_id.."."..setting.key, setting.default );
                            end
                        end
                        setting.current = ModSettingGet( mod_settings_id.."."..setting.key );
                        --for k,v in pairs( setting ) do
                        --    print( "setting "..k.."/"..tostring(v))
                        --end
                    end
                end
            end
            for _,setting in ipairs( mod_settings ) do
                parse_setting( setting );
            end
        end
    end

    local function do_boolean( gui, id, x, y, label, value, tooltip )
        GuiLayoutBeginHorizontal( gui, x, y );
            local left_click, right_click = GuiImageButton( gui, id, 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (value == true and "_fill" or "") .. ".png" );
            if value == false then
                GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 );
            end
            if GuiButton( gui, next_id(), 0, 0,  GameTextGetTranslatedOrNot( label ) ) then
                left_click = true;
            end
            if tooltip then
                GuiTooltip( gui, word_wrap( GameTextGetTranslatedOrNot( tooltip ) ), "");
            end
        GuiLayoutEnd( gui );
        return left_click, right_click;
    end

    local gui_functions = {
        button = function( setting )
            if setting.type_data.click_callback then
                setting.type_data.click_callback( GuiButton( gui, next_id(), 0, 0, setting.label ) );
                if setting.tooltip then GuiTooltip( gui, word_wrap( GameTextGetTranslatedOrNot( setting.tooltip ) ), ""); end
            end
        end,
        boolean = function( setting )
            local toggle = false;
            if GuiImageButton( gui, next_id(), 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (setting.current == true and "_fill" or "") .. ".png" ) then toggle = true; end
            if setting.current == false then GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 ); end
            if GuiButton( gui, next_id(), 0, 0, setting.label ) then toggle = true; end
            if setting.tooltip then GuiTooltip( gui, word_wrap( GameTextGetTranslatedOrNot( setting.tooltip ) ), ""); end
            if toggle == true then
                setting.current = not setting.current;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
            end
        end,
        range = function( setting )
            if setting.current == setting.default then GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 ); end
            GuiText( gui, 0, 0, setting.label );
            if setting.tooltip then GuiTooltip( gui, word_wrap( GameTextGetTranslatedOrNot( setting.tooltip ) ), ""); end
            local new_value = GuiSlider( gui, next_id(), -2, 1, "", setting.current, setting.type_data.min, setting.type_data.max, setting.default, 1.0, " ", 100 );
            if setting.type_data.value_callback ~= nil then
                new_value = setting.type_data.value_callback( new_value );
            end
            if setting.current ~= new_value then
                setting.current = new_value;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
            end
            if setting.current == setting.default then GuiColorSetForNextWidget( gui, 0.60, 0.60, 0.60, 1.0 ); end
            if setting.type_data.text_callback then
                GuiText( gui, 2, 0, setting.type_data.text_callback( setting.current ) );
            else
                GuiText( gui, 2, 0, tostring( setting.current ) );
            end
            GuiLayoutAddVerticalSpacing( gui, 20 );
        end,
        input = function( setting )
            GuiText( gui, 0, 0, setting.label );
            if setting.tooltip then GuiTooltip( gui, word_wrap( GameTextGetTranslatedOrNot( setting.tooltip ) ), ""); end
            local new_value = GuiTextInput( gui, next_id(), 0, 0, setting.current, 200, 100 );
            if setting.current ~= new_value then
                setting.current = new_value;
                ModSettingSet( mod_settings_id.."."..setting.key, setting.current );
            end
        end
    }

    function do_custom_tooltip( callback, z, x_offset, y_offset )
        if z == nil then z = -12; end
        local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = previous_data( gui );
        local screen_width,screen_height = GuiGetScreenDimensions( gui );
        if x_offset == nil then x_offset = 0; end
        if y_offset == nil then y_offset = 0; end
        if draw_y > screen_height * 0.5 then
            y_offset = y_offset - height;
        end
        if hover then
            local screen_width, screen_height = GuiGetScreenDimensions( gui );
            GuiZSet( gui, z );
            GuiLayoutBeginLayer( gui );
                GuiLayoutBeginVertical( gui, ( x + x_offset + width * 2 ) / screen_width * 100, ( y + y_offset ) / screen_height * 100 );
                    GuiBeginAutoBox( gui );
                        if callback ~= nil then callback(); end
                        GuiZSetForNextWidget( gui, z + 1 );
                    GuiEndAutoBoxNinePiece( gui );
                GuiLayoutEnd( gui );
            GuiLayoutEndLayer( gui );
        end
    end

    local function do_setting( setting )
        if setting.hidden ~= true then
            if setting.tab_key ~= nil then
                -- Individual Tabs
                GuiLayoutBeginHorizontal( gui, 0, 0 );
                    GuiLayoutBeginVertical( gui, 0, 0 );
                        local settings_sum = 0;
                        for g,v in ipairs( setting.settings ) do
                            settings_sum = settings_sum + #v.settings;
                        end
                        local setting_index = 0;
                        for g,v in ipairs( setting.settings ) do
                            do_setting( v );
                            setting_index = setting_index + #v.settings;
                            if setting_index > settings_sum / setting.columns then
                                setting_index = setting_index - settings_sum / setting.columns;
                                GuiLayoutEnd( gui );
                                GuiLayoutBeginVertical( gui, 33, 0 );
                            end
                        end
                    GuiLayoutEnd( gui );
                GuiLayoutEnd( gui );
            elseif setting.group_label ~= nil then
                -- Individual Groups
                if setting.custom_callback ~= nil then
                    setting:custom_callback();
                else
                    GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 );
                    GuiText( gui, 0, 0, setting.group_label );
                    GuiLayoutAddVerticalSpacing( gui, 2 );
                    for k,v in pairs( setting.settings ) do
                        do_setting( v );
                    end
                    GuiLayoutAddVerticalSpacing( gui, 5 );
                end
            else
                -- Individual Settings
                GuiLayoutBeginHorizontal( gui, 1, 0 );
                    if gui_functions[setting.type] then
                        gui_functions[setting.type]( setting );
                        if setting.validation_callback then
                            local result = setting.validation_callback( setting.current );
                            if result ~= true then
                                GuiTooltip( gui, word_wrap( result ), "" );
                            end
                        end
                    else
                        print( "[gokiui] missing gui function "..setting.type );
                    end
                GuiLayoutEnd( gui );
                if setting.type == "range" then
                    --GuiLayoutAddVerticalSpacing( gui, -2 );
                elseif setting.type == "input" then
                    GuiLayoutAddVerticalSpacing( gui, -2 );
                end
            end
        end
    end

    local function do_gui()
        if GlobalsGetValue("gkbrkn_force_settings_refresh","0") == "1" then
            refresh_settings();
            GlobalsSetValue("gkbrkn_force_settings_refresh","0");
        end
        local current_tab_index = 0;
        local scroll_container_ids = next_id( #mod_settings );
        GuiLayoutBeginVertical( gui, 0, 0 );
            GuiLayoutBeginHorizontal( gui, 0, 0 );
                for i,setting in ipairs( mod_settings ) do
                    if current_tab == nil and setting.tab_key then
                        current_tab = current_tab or setting.tab_key;
                    end
                    GuiBeginAutoBox( gui );
                        local was_selected = false;
                        if current_tab == setting.tab_key then
                            GuiZSetForNextWidget( gui, z_index - 2 );
                            current_tab_index = i;
                            was_selected = true;
                        else
                            GuiZSetForNextWidget( gui, z_index );
                            GuiColorSetForNextWidget( gui, 0.5, 0.5, 0.5, 1.0 );
                        end
                        if GuiButton( gui, next_id(), 0, 0, " "..GameTextGetTranslatedOrNot( setting.tab_label ).." " ) then
                            current_tab = setting.tab_key;
                            current_tab_index = i;
                        end
                        GuiLayoutAddHorizontalSpacing( gui, 0 );
                        if was_selected then
                            GuiZSetForNextWidget( gui, z_index - 1 );
                        else
                            GuiZSetForNextWidget( gui, z_index + 10 );
                        end
                    GuiEndAutoBoxNinePiece( gui, 0, nil, nil, nil, nil, "mods/gkbrkn_noita/files/gkbrkn/gui/9piece_tab.png", "mods/gkbrkn_noita/files/gkbrkn/gui/9piece_tab.png" );
                end
            GuiLayoutEnd( gui );

            GuiZSetForNextWidget( gui, z_index + 2 );
            GuiBeginScrollContainer( gui, scroll_container_ids + (current_tab_index - 1), 0, 0, screen_width - screen_width * 0.12, screen_height - screen_height * 0.30, false );
                do_setting( mod_settings[current_tab_index] );
            GuiEndScrollContainer( gui );
            -- keep the other scroll containers drawing so their scroll position is maintained (doesn't really look that good anyway)
            --[[
            for i=1,#mod_settings do
                if i ~= current_tab_index then
                    GuiOptionsAddForNextWidget( gui, GUI_OPTION.Layout_NoLayouting );
                    GuiBeginScrollContainer( gui, scroll_container_ids + (i - 1), 0, 0, -1000, -1000, false );
                    GuiEndScrollContainer( gui );
                end
            end
            ]]
        GuiLayoutEnd( gui );
    end

    return {
        do_boolean = do_boolean,
        do_setting = do_setting,
        do_custom_tooltip = do_custom_tooltip,
        reset_id = reset_id,
        next_id = next_id,
        parse_mod_settings = parse_mod_settings,
        do_gui = do_gui,
        gui_functions = gui_functions,
        iterate_settings = iterate_settings,
        refresh_settings = refresh_settings,
    }
end