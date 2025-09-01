dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/enums.lua" )

local log_range = function( p, minv, maxv )
    local minp = 0
    local maxp = 100

    minv = math.log(minv)
    maxv = math.log(maxv)

    local scale = ( maxv - minv ) / ( maxp - minp )
    return math.exp( minv + scale * ( p - minp ) )
end

return function( gui, gui_id, z_index )
    local full_screen_width, full_screen_height = GuiGetScreenDimensions( gui )
    GuiStartFrame( gui )
    local screen_width, screen_height = GuiGetScreenDimensions( gui )
    local id_offset = 0
    local current_tab = nil
    local z_index = z_index or 0
    local last_z = z_index or 0
    local settings = {}

    local function color_enabled() GuiColorSetForNextWidget( gui, 1.0, 1.0, 1.0, 1.0 ) end
    local function color_disabled() GuiColorSetForNextWidget( gui, 0.4, 0.4, 0.4, 1.0 ) end
    local function color_toggled( which ) if which then color_enabled() else color_disabled() end end

    local z_set = function( gui, value )
        last_z = value
        GuiZSet( gui, value )
    end

    local z_set_next = function( gui, value )
        last_z = value
        GuiZSetForNextWidget( gui, value )
    end

    local function word_wrap( str, wrap_size )
        if not str then return "" end
        if wrap_size == nil then wrap_size = 50 end
        local last_wrap = 0
        local i = 0
        while true do
            local next_newline = str:find("\n",i+1)
            if next_newline and next_newline - last_wrap < wrap_size then
                i = next_newline
                last_wrap = next_newline
            else
                i = math.min( str:find(" ",i+1) or #str )
                if i >= #str then break end
                if i - last_wrap > wrap_size then
                    str = str:sub(1,i - 1) .. "\n" .. str:sub(i+1)
                    last_wrap = i
                end
            end
        end
        return str
    end

    local function basic_tooltip( setting )
        if setting.tooltip and should_do_custom_tooltip() then
            local text = GameTextGetTranslatedOrNot( setting.tooltip )
            if setting.activation_type == CONTENT_ACTIVATION_TYPE.Restart then
                text = text .. " (requires restart)"
            elseif setting.activation_type == CONTENT_ACTIVATION_TYPE.NewGame then
                text = text .. " (requires new run)"
            end
            do_custom_tooltip( function() GuiText( gui, 0, 0, word_wrap( text, 40 ) ) end )
        end
    end

    local function reset_id()
        id_offset = 1
    end

    local function next_id( amount )
        if amount == nil then amount = 1 end
        local current_id = id_offset + 1
        id_offset = id_offset + amount
        return gui_id + current_id
    end

    local function register_settings( mod_settings )
        settings = mod_settings
    end

    local function iterate_settings( callback, to_iterate )
        if to_iterate == nil then to_iterate = settings end
        for _,setting in pairs( to_iterate ) do
            if setting then
                if setting.settings ~= nil then
                    iterate_settings( callback, setting.settings )
                else
                    callback( setting )
                end
            end
        end
    end

    local function refresh_settings()
        iterate_settings( function( setting )
            setting.current = setting_get( setting.key )
        end )
    end

    local is_panel_open = false
    local function parse_mod_settings( disable_new_settings )
        local function parse_setting( setting )
            if setting.group_label ~= nil or setting.tab_label ~= nil then
                for k,v in pairs( setting.settings ) do
                    parse_setting( v )
                end
            else
                if setting.default ~= nil then
                    if setting_get(setting.key) == nil then
                        if disable_new_settings == true then
                            setting_set( setting.key, setting.disable )
                        else
                            setting_set( setting.key, setting.default )
                        end
                    end
                    setting.current = setting_get( setting.key )
                end
            end
        end
        for _,setting in ipairs( settings ) do
            parse_setting( setting )
        end
    end

    local function do_boolean( gui, id, setting_key, x, y, label, value, tooltip )
        GuiLayoutBeginHorizontal( gui, x, y )
            local left_click, right_click = GuiImageButton( gui, id, 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (value == true and "_fill" or "") .. ".png" )
            color_toggled( value == true )
            local left_click, right_click = GuiButton( gui, next_id(), 0, 0,  GameTextGetTranslatedOrNot( label ) )
            if left_click then
                if value then
                    setting_set( setting_key, false )
                else
                    setting_set( setting_key, true )
                end
            end
            if tooltip then
                do_custom_tooltip( function() GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( tooltip ) ) ) end )
            end
        GuiLayoutEnd( gui )
    end

    local function do_range( gui, id, setting_key, x, y, label, value, default, min, max, value_callback, text_callback, tooltip )
        GuiLayoutBeginHorizontal( gui, x, y )
            color_toggled( value ~= default )
            GuiText( gui, 0, 0, label )
            if tooltip then
                do_custom_tooltip( function() GuiText( gui, 0, 0, word_wrap( GameTextGetTranslatedOrNot( tooltip ) ) ) end )
            end
            local new_value = GuiSlider( gui, id, -2, 1, "", value, min, max, default, 1.0, " ", 100 )
            if value_callback ~= nil then
                new_value = value_callback( new_value )
            end
            if value ~= new_value then
                value = new_value
                setting_set( setting_key, value )
            end
            color_toggled( value ~= default )
            if text_callback then
                GuiText( gui, 2, 0, text_callback( value ) )
            else
                GuiText( gui, 2, 0, tostring( value ) )
            end
        GuiLayoutEnd( gui )
    end

    local gui_functions = {
        button = function( setting )
            if setting.type_data.click_callback then
                GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
                local left_click, right_click = GuiButton( gui, next_id(), 0, 0, setting.label )
                if left_click or right_click then
                    setting.type_data.click_callback( left_click, right_click )
                end
                basic_tooltip(setting)
            end
        end,
        boolean = function( setting )
            local toggle = false
            if GuiImageButton( gui, next_id(), 0, 1, "", "mods/gkbrkn_noita/files/gkbrkn/gui/checkbox" .. (setting.current == true and "_fill" or "") .. ".png" ) then toggle = true end
            color_toggled( setting.current == true )
            if GuiButton( gui, next_id(), 0, 0, setting.label ) then toggle = true end
            basic_tooltip(setting)
            if toggle == true then
                setting.current = not setting.current
                setting_set( setting.key, setting.current )
                if setting.toggle_callback then
                    setting.toggle_callback( setting.current )
                end
            end
        end,
        range = function( setting )
            color_toggled( setting.current ~= setting.default )
            GuiText( gui, 0, 0, setting.label )
            basic_tooltip(setting)
            if setting.current == nil then
                setting.current = 0
            end
            local new_value = setting.current
            if setting.type_data.log then
                new_value = math.exp( GuiSlider( gui, next_id(), -2, 1, "", math.log(setting.current), math.log(setting.type_data.min), math.log(setting.type_data.max), math.log(setting.default), 1.0, " ", 100 ) )
            else
                new_value = GuiSlider( gui, next_id(), -2, 1, "", setting.current, setting.type_data.min, setting.type_data.max, setting.default, 1.0, " ", 100 )
            end
            if setting.type_data.value_callback ~= nil then
                new_value = setting.type_data.value_callback( new_value )
            end
            if setting.current ~= new_value then
                setting.current = new_value
                setting_set( setting.key, setting.current )
            end
            color_toggled( setting.current ~= setting.default )
            if setting.type_data.text_callback then
                GuiText( gui, 2, 0, setting.type_data.text_callback( setting.current ) )
            else
                GuiText( gui, 2, 0, tostring( setting.current ) )
            end
        end,
        input = function( setting )
            color_toggled( setting.current ~= setting.default )
            GuiText( gui, 0, 0, setting.label )
            basic_tooltip(setting)
            local new_value = GuiTextInput( gui, next_id(), 0, 0, tostring(setting.current) or "", setting.type_data.width or 150, 100 )
            if setting.current ~= new_value then
                setting.current = new_value
                if setting.current ~= nil then
                    setting_set( setting.key, setting.current )
                end
            end
        end
    }

    function should_do_custom_tooltip()
        local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = GuiGetPreviousWidgetInfo( gui )
        return hover
    end

    function do_custom_tooltip( callback, z, x_offset, y_offset )
        local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = GuiGetPreviousWidgetInfo( gui )
        if not hover then return end

        if z == nil then z = last_z - 12 end
        local screen_width,screen_height = GuiGetScreenDimensions( gui )
        local fx = x + width + (x_offset or 0) + 10
        local fy = y + (y_offset or 0)
        --if fx > screen_width * 0.5 then fx = fx - width end
        --if fy > screen_height * 0.5 then fy = fy - height end
        if hover then
            local previous_z = last_z
            GuiLayoutBeginLayer( gui )
                GuiLayoutBeginVertical( gui, fx, fy, true )
                    GuiBeginAutoBox( gui )
                        z_set( gui, z )
                        if callback ~= nil then callback() end
                        z_set_next( gui, z + 1 )
                    GuiEndAutoBoxNinePiece( gui )
                GuiLayoutEnd( gui )
            GuiLayoutEndLayer( gui )
            z_set( gui, previous_z )
        end
    end

    local function do_setting( setting )
        if setting.hidden ~= true then
            local w, h = GuiGetScreenDimensions( gui )
            if setting.tab_key ~= nil then
                -- Individual Tabs
                GuiLayoutBeginHorizontal( gui, 0, 0 )
                    GuiLayoutBeginVertical( gui, 0, 0 )
                        local settings_sum = 0
                        for g,v in ipairs( setting.settings ) do
                            settings_sum = settings_sum + #v.settings
                        end
                        local setting_index = 0
                        for g,v in ipairs( setting.settings ) do
                            do_setting( v )
                            setting_index = setting_index + #v.settings
                            if setting_index > settings_sum / setting.columns then
                                setting_index = setting_index - settings_sum / setting.columns
                                GuiLayoutEnd( gui )
                                GuiLayoutBeginVertical( gui, 33, 0 )
                            end
                        end
                        GuiLayoutAddVerticalSpacing( gui, h * 0.64 )
                        GuiText( gui, 0, 0, "" )
                    GuiLayoutEnd( gui )
                GuiLayoutEnd( gui )
            elseif setting.group_label ~= nil then
                -- Individual Groups
                if setting.custom_callback ~= nil then
                    setting:custom_callback()
                else
                    GuiColorSetForNextWidget( gui, 1.0, 0.75, 0.5, 1.0 )
                    GuiText( gui, 0, 0, setting.group_label )
                    GuiLayoutAddVerticalSpacing( gui, 2 )
                    for k,v in pairs( setting.settings ) do
                        do_setting( v )
                    end
                    GuiLayoutAddVerticalSpacing( gui, 5 )
                end
            else
                -- Individual Settings
                GuiLayoutBeginHorizontal( gui, 1, 0 )
                    if gui_functions[setting.type] then
                        gui_functions[setting.type]( setting )
                        if setting.validation_callback then
                            if result ~= true then
                                do_custom_tooltip( function() GuiText( gui, 0, 0, word_wrap( result ) ) end )
                            end
                        end
                    else
                        print("[gokiui] missing gui function "..setting.type)
                    end
                GuiLayoutEnd( gui )
            end
        end
    end

    local function do_gui()
        local current_tab_index = 0
        local scroll_container_ids = next_id( #settings )
        GuiLayoutBeginVertical( gui, 0, 0 )
            GuiLayoutBeginHorizontal( gui, 0, 0 )
                for i,setting in ipairs( settings ) do
                    if current_tab == nil and setting.tab_key then
                        current_tab = current_tab or setting.tab_key
                    end
                    GuiLayoutAddHorizontalSpacing( gui, 10 )
                    GuiBeginAutoBox( gui )
                        local was_selected = false
                        if current_tab == setting.tab_key then
                            z_set_next( gui, z_index - 2 )
                            current_tab_index = i
                            was_selected = true
                        else
                            z_set_next( gui, z_index )
                            color_disabled()
                        end
                        if GuiButton( gui, next_id(), 0, was_selected and -2 or 0, " "..GameTextGetTranslatedOrNot( setting.tab_label ).." " ) then
                            current_tab = setting.tab_key
                            current_tab_index = i
                        end
                        local _,_,_,_,_,_,tab_height = GuiGetPreviousWidgetInfo( gui )
                        local margin = was_selected and 2 or 0
                        if was_selected then
                            z_set_next( gui, z_index - 1 )
                        else
                            z_set_next( gui, z_index + 10 )
                        end
                    GuiEndAutoBoxNinePiece( gui, margin, nil, 0, nil, nil, "mods/gkbrkn_noita/files/gkbrkn/gui/9piece_tab.png", "mods/gkbrkn_noita/files/gkbrkn/gui/9piece_tab.png" )
                    GuiLayoutAddHorizontalSpacing( gui, 10 )
                end
                GuiLayoutAddHorizontalSpacing( gui, 10 )
            GuiLayoutEnd( gui )

            z_set_next( gui, z_index + 2 )
            GuiBeginScrollContainer( gui, scroll_container_ids + (current_tab_index - 1), 0, 0, screen_width - screen_width * 0.12, screen_height - screen_height * 0.30, true )
                do_setting( settings[current_tab_index] )
            GuiEndScrollContainer( gui )
        GuiLayoutEnd( gui )
    end

    return {
        do_boolean = do_boolean,
        do_range = do_range,
        do_setting = do_setting,
        do_custom_tooltip = do_custom_tooltip,
        reset_id = reset_id,
        next_id = next_id,
        parse_mod_settings = parse_mod_settings,
        do_gui = do_gui,
        gui_functions = gui_functions,
        register_settings = register_settings,
        iterate_settings = iterate_settings,
        refresh_settings = refresh_settings,
        color_disabled = color_disabled,
        color_enabled = color_enabled,
        color_toggled = color_toggled,
        z_set = z_set,
        z_set_next = z_set_next,
        word_wrap = word_wrap,
    }
end