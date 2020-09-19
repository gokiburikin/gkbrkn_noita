-- NOTE: Using GameTextGetXX may be wastey. Consider caching some of the ui elements like [?] and [X] and only update them when the menu is clicked
print("[goki's things] setting up GUI");
local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "data/scripts/lib/coroutines.lua" );
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
local options = {};
local gui = gui or GuiCreate();
local gui_id = 1707;
local gui_required_activation = CONTENT_ACTIVATION_TYPE.Immediate;
local wrap_threshold = 17;
local wrap_limit = 3;
local content_wrap_limit = 2;
local wrap_size = 33;
local last_time = 0;
local fps_easing = 4;
local current_fps = 0;
local screen = SCREEN.Closed;
local page = 1;
local id_offset = 0;
local sorted_content = {};
local content_counts = {};
local content_type_selection = {};
local content_type = nil;
local tab_index = 1;
local hide_menu_frame = GameGetFrameNum() + 300;
local tip = "";

local truncate_long_string = function( str )
    if #str > 31 then
        str = str:sub( 0, 14 ).."..."..str:sub( -14 );
    end
    return str;
end

local tabs = {
    {
        name = GameTextGetTranslatedOrNot("$ui_tab_name_gkbrkn_options"),
        screen = SCREEN.Options,
        development_only = false
    }
}

for index,content in pairs( CONTENT ) do
    if content.options == nil  then
    print("missing options "..content.name)
    end
    if content.visible() then
        table.insert( sorted_content, {
            id=index,
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

for _,content_type in pairs( content_types ) do
    local name = GameTextGetTranslatedOrNot( content_type.display_name );
    name = ( content_counts[content_type.id] or 0 ).." "..name;
    table.insert( content_type_selection, { name = name, type = content_type.id } );
    table.insert( tabs, { name = name, screen = SCREEN.ContentSelection, content_type = content_type.id, development_only = tonumber(v) == "dev_option" } );
end
table.sort( content_type_selection, function( a, b ) return a.name < b.name end );

function filter_content( content_list, content_type, content_table )
    if content_table == nil then content_table = CONTENT; end
    local filtered = {};
    for _,content in pairs( content_list ) do
        if CONTENT[content.id].type == content_type then
            table.insert( filtered, content );
        end
    end
    return filtered;
end

local pagination_list = nil;

function RegisterFlagOption( name, flag, activation_type, sub_option, activation_type, toggle_callback, require_new_game, description, height )
    table.insert( options, {
        name = name,
        flag = flag,
        activation_type = activation_type,
        sub_option = sub_option,
        activation_type = activation_type,
        toggle_callback = toggle_callback,
        require_new_game = require_new_game,
        description = description,
        height = height
    } );
end

for _,option in pairs( OPTIONS ) do
    if option.GroupName then
        RegisterFlagOption( option.GroupName, nil, nil, nil, nil, nil, nil, nil, #option.SubOptions + 1 );
        for _,subOption in pairs(option.SubOptions) do
            RegisterFlagOption( subOption.Name, subOption.PersistentFlag, subOption.RequiresRestart, true, subOption.ActivationType, subOption.ToggleCallback, subOption.RequiresNewGame, subOption.Description, 0 );
        end
    else
        RegisterFlagOption( option.Name, option.PersistentFlag, option.RequiresRestart, false, option.ActivationType, option.ToggleCallback, option.RequiresNewGame, option.Description, 1 );
    end
end

function next_id()
    id_offset = id_offset + 1;
    return gui_id + id_offset;
end

function get_tab_name()
    for _,tab_data in pairs( tabs ) do
        if screen == tab_data.screen and ( tab_data.content_type == nil or content_type == tab_data.content_type ) then
            return tab_data.name;
        end
    end
end

function toggle_vanilla()
    for _,option in pairs( GKBRKN_CONFIG.OPTIONS ) do
        if option.SubOptions ~= nil then
            for _,sub_option in pairs(option.SubOptions) do
                RemoveFlagPersistent( sub_option.PersistentFlag );
            end
        else
            RemoveFlagPersistent( option.PersistentFlag );
        end
    end
    for _,content in pairs( CONTENT ) do
        content.toggle( false );
    end
end

function toggle_default()
    toggle_vanilla();
    for _,option in pairs( GKBRKN_CONFIG.OPTIONS ) do
        if option.SubOptions ~= nil then
            for _,sub_option in pairs(option.SubOptions) do
                if sub_option.EnabledByDefault then
                    AddFlagPersistent( sub_option.PersistentFlag );
                end
            end
        else
            if option.EnabledByDefault then
                AddFlagPersistent( option.PersistentFlag );
            end
        end
    end
    for _,content in pairs( CONTENT ) do
        if content.enabled_by_default or content.type == "action" or content.type == "perk" or content.type == "pack" or content.type == "champion_type" or content.type == "legendary_wand" then
            content.toggle( true );
        end
    end
end

function toggle_content_by_tag( tag, skip_default )
    for _,option in pairs( GKBRKN_CONFIG.OPTIONS ) do
        if option.SubOptions ~= nil then
            for _,sub_option in pairs(option.SubOptions) do
                if skip_default == false then
                    if sub_option.EnabledByDefault then
                        AddFlagPersistent( sub_option.PersistentFlag );
                    end
                end
                if sub_option.Tags[tag] then
                    AddFlagPersistent( sub_option.PersistentFlag );
                elseif sub_option.Tags[tag] == false then
                    RemoveFlagPersistent( sub_option.PersistentFlag );
                end
            end
        else
            if skip_default == false then
                if option.EnabledByDefault then
                    AddFlagPersistent( option.PersistentFlag );
                end
            end
            if option.Tags[tag] then
                AddFlagPersistent( option.PersistentFlag );
            elseif option.Tags[tag] == false then
                RemoveFlagPersistent( sub_option.PersistentFlag );
            end
        end
    end
    for _,content in pairs( CONTENT ) do
        if skip_default == false then
            if content.enabled_by_default then
                content.toggle( true );
            end
        end
        if content.tags[tag] then
            content.toggle( true );
        elseif content.tags[tag] == false then
            content.toggle( false );
        end
    end
end

function do_gui()
    id_offset = 0;
    GuiStartFrame( gui );

    -- Config Menu Button
    GuiLayoutBeginVertical( gui, 90, 0 ); -- fold vertical
        local main_text = "["..GameTextGetTranslatedOrNot("$ui_mod_name_gkbrkn").."]";
        if gui_required_activation ~= CONTENT_ACTIVATION_TYPE.Immediate then
            main_text = main_text.."*"
        end
        if GuiButton( gui, 0, 0, main_text, gui_id ) then
            if screen ~= 0 then
                change_screen( 0 );
            else
                change_screen( SCREEN.Info );
            end
        end
        if screen ~= 0 then
            GuiText( gui, 0, 0, SETTINGS.Version );
        end
    GuiLayoutEnd( gui ); -- fold vertical

    if HasFlagPersistent( FLAGS.DebugMode ) then
        GuiLayoutBeginVertical( gui, 89, 91 );
        GuiText( gui, 0, 0, "Development Mode" );
        GuiLayoutEnd( gui );
        GuiLayoutBeginVertical( gui, 92, 93 );
        local update_time = get_update_time();
        reset_update_time();
        local frame_time = get_frame_time();
        reset_frame_time();
        GuiText( gui, 0, 0, tostring( math.floor( update_time * 100000 ) / 100 ).."ms/pu" );
        GuiText( gui, 0, 0, tostring( math.floor( frame_time * 100000 ) / 100 ).."ms/fr" );
        GuiLayoutEnd( gui );
    end

    GuiLayoutBeginVertical( gui, 1, 12 );  -- main vertical
    if screen ~= SCREEN.Closed then
        local cx, cy = GameGetCameraPos();
        GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/gui/darken.png", cx, cy );
        hide_menu_frame = GameGetFrameNum() + 300;
        GuiLayoutBeginHorizontal( gui, 0, 0 ); -- tabs horizontal
        local tab_index = 1;
        for index,tab_data in pairs( tabs ) do
            if HasFlagPersistent( FLAGS.DebugMode ) or tab_data.development_only ~= true then
                local tab_title = tab_data.name;
                local is_current_tab = false;
                if screen == tab_data.screen and ( tab_data.content_type == nil or content_type == tab_data.content_type ) then
                    is_current_tab = true;
                end
                if is_current_tab then
                    tab_title = ">"..tab_title.."<";
                else
                    tab_title = "["..tab_title.."]";
                end
                if GuiButton( gui, 0, 0, tab_title.." ", next_id() ) then
                    if screen ~= tab_data.screen then
                        change_screen( tab_data.screen );
                    else
                        if tab_data.content_type == nil or content_type == tab_data.content_type then
                            change_screen( SCREEN.Info );
                        end
                    end
                    if tab_data.content_type ~= nil then
                        change_content_type( tab_data.content_type );
                    end
                end
                if tab_index % 7 == 0 then
                    GuiLayoutEnd( gui ); -- tabs horizontal
                    GuiLayoutBeginHorizontal( gui, 0, 0 ); -- tabs horizontal
                end
                tab_index = tab_index + 1;
            end
        end
        GuiLayoutEnd( gui ); -- tabs horizontal
    end

    if screen == SCREEN.Info then
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, "Welcome to Goki's Things!")
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, "Choose a tab up above to customize the mod or choose one of the presets below!")
        GuiText( gui, 0, 0, "Be sure to check out all the different pages of content for that tab, what you're looking for may be on page 2.")
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, "Press one of the buttons below to select a preset. Be careful, you can't undo this!");
        GuiText( gui, 0, 0, " ");
        if GuiButton( gui, 0, 0, "[Default] Reset Goki's Things to default settings", next_id() ) then
            toggle_default();
            GamePrint( "Reset Goki's Things to its default settings" );
        end
        if GuiButton( gui, 0, 0, "[Vanilla] Turn off all custom Goki's Things content", next_id() ) then
            toggle_vanilla();
            GamePrint( "Disabled all custom content" );
        end
        GuiText( gui, 0, 0, " ");
        if GuiButton( gui, 0, 0, "[Champions Mode] Enemies have special modifiers that change up the combat", next_id() ) then
            toggle_content_by_tag("champions_mode");
            GamePrint( "Enabled Champions Mode options" );
        end
        if GuiButton( gui, 0, 0, "[Hero Mode] Enemies are tougher and the final boss has a higher minimum health", next_id() ) then
            toggle_content_by_tag("hero_mode");
            GamePrint( "Enabled Hero Mode options" );
        end
        if GuiButton( gui, 0, 0, "[Ultimate Challenge Mode] Enable the Ultimate Hero + Ultimate Champion game modes", next_id() ) then
            toggle_content_by_tag("ultimate_challenge");
            GamePrint( "Enabled Ultimate Challenge Mode options" );
        end
        if GuiButton( gui, 0, 0, "[Goki Mode] Apply the settings Goki prefers to use (this is a difficult mode)", next_id() ) then
            toggle_default();
            toggle_content_by_tag("goki_thing");
            GamePrint( "Enabled Goki Mode options" );
        end
        GuiText( gui, 0, 0, " ");
        if GuiButton( gui, 0, 0, "[Random Starts] Start runs with random equipment", next_id() ) then
            toggle_content_by_tag("random_starts");
            GamePrint( "Enabled Random Starts options" );
        end
        if GuiButton( gui, 0, 0, "[Loadouts] Allow Goki's Things to manage loadouts and start runs with a random loadout", next_id() ) then
            toggle_content_by_tag("loadouts");
            for _,content in pairs( CONTENT ) do
                if content.type == "loadout" or content.type == "action" or content.type == "perk" then
                    content.toggle( true );
                end
            end
            GamePrint( "Enabled loadout management and all loadouts" );
        end
        if GuiButton( gui, 0, 0, "[Randomize] Randomize all of the options (this is a bad idea)", next_id() ) then
            for _,option in pairs( GKBRKN_CONFIG.OPTIONS ) do
                if option.SubOptions ~= nil then
                    for _,sub_option in pairs(option.SubOptions) do
                        if Random() < 0.5 then
                            AddFlagPersistent( sub_option.PersistentFlag );
                        else
                            RemoveFlagPersistent( sub_option.PersistentFlag );
                        end
                    end
                else
                    if Random() < 0.5 then
                        AddFlagPersistent( option.PersistentFlag );
                    else
                        RemoveFlagPersistent( option.PersistentFlag );
                    end
                end
            end
            for _,content in pairs( CONTENT ) do
                if Random() < 0.5 then
                    content.toggle( true );
                else
                    content.toggle( false );
                end
            end
            RemoveFlagPersistent( MISC.AutoHide.EnabledFlag );
            GamePrint( "All settings have been randomized" );
        end
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, "Goki Says: "..tip);
    elseif screen == SCREEN.Options then
        GuiText( gui, 0, 0, " ");
        do_paginated_content( options, function( option ) do_option(option) end );
    elseif screen == SCREEN.ContentTypeSelection then
        GuiText( gui, 0, 0, " ");
        GuiLayoutBeginHorizontal( gui, 0, 0 );
        GuiLayoutEnd( gui );
        GuiText( gui, 0, 0, " ");
        for k,content_type_data in pairs(content_type_selection) do
            if GuiButton( gui, 0, 0, content_type_data.name, next_id() ) then
                content_type = content_type_data.type;
                change_screen( SCREEN.ContentSelection );
            end 
        end
    elseif screen == SCREEN.ContentSelection then
        local filtered_content = filter_content( sorted_content, content_type );
        --do_paginated_content( filtered_content, function( content ) do_content( contnt ) end );

        --for index,action_id in pairs( sorted_actions ) do
        --[[]]
        GuiText( gui, 0, 0, " ");
        local pages_info = do_pagination( filtered_content, wrap_threshold,  wrap_limit, page );
        local break_index = 1;
        local breaks_hit = 0;
        if pages_info[page].size > 0 then
            do_quick_bar( filtered_content );
            GuiText( gui, 0, 0, " " );
            GuiLayoutBeginVertical( gui, 0, 0 ); -- content wrapping vertical
                local wrap_index = 1;
                local start_index = 1;
                local page_size = pages_info[page].size;
                local page_breaks = pages_info[page].breaks;
                for p=1,#pages_info,1 do
                    if page > p then
                        start_index = start_index + pages_info[p].size;
                    end
                end
                local content_index = 0;
                for index = start_index, start_index + page_size-1,1 do
                    --for index=start_index,math.min(start_index + wrap_threshold * wrap_limit - 1, #filtered_content ),1 do
                    if page_breaks[wrap_index] and break_index > page_breaks[wrap_index] then
                        GuiLayoutEnd( gui );
                        GuiLayoutBeginVertical( gui, wrap_size * wrap_index, 0 );
                        wrap_index = wrap_index + 1;
                        break_index = 1;
                    end
                    do_content( CONTENT[ filtered_content[index].id ] );
                    content_index = content_index + 1;
                    break_index = break_index + 1;
                end
                do_required_activation();
            GuiLayoutEnd( gui ); -- content wrapping vertical
        else
            GuiText( gui, 0, 0, " " );
            GuiText( gui, 0, 0, "No content" );
        end
    end
    GuiLayoutEnd( gui ); -- main vertical
end

function do_paginated_content( content_list, content_callback )
    local pages_info = do_pagination( content_list, wrap_threshold,  wrap_limit, page );
    local break_index = 1;
    local breaks_hit = 0;
    GuiText( gui, 0, 0, " ");
    GuiLayoutBeginVertical( gui, 0, 0 );
        local wrap_index = 1;
        local start_index = 1;
        local page_size = pages_info[page].size;
        local page_breaks = pages_info[page].breaks;
        for p=1,#pages_info,1 do
            if page > p then
                start_index = start_index + pages_info[p].size;
            end
        end
        local content_index = 0;
        for index = start_index, start_index + page_size-1,1 do
            local content = content_list[index];
            if content then
                --if option.sub_option ~= true and content_index + option.height > wrap_index * wrap_threshold then
                if page_breaks[wrap_index] and break_index > page_breaks[wrap_index] then
                    GuiLayoutEnd( gui );
                    GuiLayoutBeginVertical( gui, wrap_size * wrap_index, 0 );
                    wrap_index = wrap_index + 1;
                    break_index = 1;
                end
                content_callback( content );
                content_index = content_index + 1;
            end
            break_index = break_index + 1;
        end
        do_required_activation();
    GuiLayoutEnd( gui );
end

function do_fps()
    if HasFlagPersistent( MISC.ShowFPS.EnabledFlag ) then
        local now = GameGetRealWorldTimeSinceStarted();
        local fps = 1 / (now - last_time);
        current_fps = current_fps + (fps - current_fps ) / fps_easing;
        last_time = now;
        GuiLayoutBeginVertical( gui, 82, 0 );
        GuiText( gui, 0, 0, (math.floor( current_fps * 10) / 10) );
        GuiLayoutEnd( gui );
    end
end

function change_page( new_page )
    page = new_page;
end

function change_content_type( new_content_type )
    content_type = new_content_type;
end

function change_screen( new_screen )
    local new_page = 1;
    if new_screen == 0 then
        GlobalsSetValue( "gkbrkn_gui_screen", tostring( screen ) );
        GlobalsSetValue( "gkbrkn_gui_page", tostring( page ) );
        GlobalsSetValue( "gkbrkn_gui_content_type", tostring( content_type ) );
        GameRemoveFlagRun( FLAGS.ConfigMenuOpen );
        local tip_index = math.ceil( Random() * #MISC.ShowModTips.Tips );
        tip = GameTextGetTranslatedOrNot( MISC.ShowModTips.Tips[tip_index] );
    else
        if screen == 0 then
            local saved_screen = tonumber(GlobalsGetValue( "gkbrkn_gui_screen", tostring(new_screen)));
            if saved_screen ~= 0 then
                new_screen = saved_screen;
            end
            new_page = tonumber(GlobalsGetValue( "gkbrkn_gui_page", tostring(page) ));
            content_type = GlobalsGetValue( "gkbrkn_gui_content_type", content_type or "" );
        end
        GameAddFlagRun( FLAGS.ConfigMenuOpen );
    end
    screen = new_screen;
    change_page( new_page );
end

function do_required_activation()
    if gui_required_activation == CONTENT_ACTIVATION_TYPE.NewGame then
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, GameTextGetTranslatedOrNot("$ui_new_game_required_gkbrkn").." *");
    elseif gui_required_activation == CONTENT_ACTIVATION_TYPE.Restart then
        GuiText( gui, 0, 0, " ");
        GuiText( gui, 0, 0, GameTextGetTranslatedOrNot("$ui_restart_required_gkbrkn").." *");
    end
end

function do_quick_bar( filtered_content )
    GuiLayoutBeginHorizontal( gui, 0, 0 ); -- quick bar horizontal
        if GuiButton( gui, 0, 0, "["..GameTextGetTranslatedOrNot("$ui_enable_all_gkbrkn").."]", next_id() ) then
            for index,content_mapping in pairs( filtered_content ) do
                CONTENT[ content_mapping.id ].toggle( true );
            end
            gui_required_activation = math.max( gui_required_activation, CONTENT_ACTIVATION_TYPE.Restart );
        end
        if GuiButton( gui, 0, 0, "["..GameTextGetTranslatedOrNot("$ui_disable_all_gkbrkn").."]", next_id() ) then
            for index,content_mapping in pairs( filtered_content ) do
                CONTENT[ content_mapping.id ].toggle( false );
            end
            gui_required_activation = math.max( gui_required_activation, CONTENT_ACTIVATION_TYPE.Restart );
        end
        if GuiButton( gui, 0, 0, "["..GameTextGetTranslatedOrNot("$ui_toggle_all_gkbrkn").."]", next_id() ) then
            for index,content_mapping in pairs( filtered_content ) do
                CONTENT[ content_mapping.id ].toggle();
            end
            gui_required_activation = math.max( gui_required_activation, CONTENT_ACTIVATION_TYPE.Restart );
        end
    GuiLayoutEnd( gui ); -- quick bar horizontal
end

function do_content( content )
    local text = "";
    local flag = GKBRKN_CONFIG.get_content_flag( content.id, CONTENT );
    if flag ~= nil then
        if content.enabled() == true then
            text = text .. GameTextGetTranslatedOrNot("$ui_check_mark_gkbrkn");
        else
            text = text .. GameTextGetTranslatedOrNot("$ui_uncheck_mark_gkbrkn");
        end
        text = text .. " "..truncate_long_string( GameTextGetTranslatedOrNot( ( content.options and content.options.display_name ) or content.name ) );
        if content.options.menu_note then
            text = text .. " " .. GameTextGetTranslatedOrNot( content.options.menu_note );
        end
        GuiLayoutBeginHorizontal( gui, 0, 0 );
            if content.description ~= nil then
                if GuiButton( gui, 0, 0, GameTextGetTranslatedOrNot("$ui_info_button_gkbrkn"), next_id() ) then
                    for word in string.gmatch( content.description, '([^\n]+)' ) do
                        GamePrint( word );
                    end
                end
            end
            if HasFlagPersistent( MISC.VerboseMenus.EnabledFlag ) and content.options ~= nil then
                if content.options.preview_callback ~= nil then
                    if GuiButton( gui, 0, 0, GameTextGetTranslatedOrNot("$ui_preview_button_gkbrkn"), next_id() ) then
                        content.options.preview_callback( EntityGetWithTag( "player_unit" )[1] );
                    end
                end
            end
            if GuiButton( gui, 0, 0, text, next_id() ) then
                gui_required_activation = math.max( gui_required_activation, CONTENT_ACTIVATION_TYPE.Restart );
                content.toggle();
            end
        GuiLayoutEnd( gui );
    end
end

function do_option( option )
    GuiLayoutBeginHorizontal( gui, 0, 0 );
    if option.flag ~= nil then
        local text = "";
        if option.sub_option then
            GuiText( gui, 0, 0, "  " );
        end
        local option_enabled = HasFlagPersistent( option.flag );
        if option_enabled then
            text = text .. GameTextGetTranslatedOrNot("$ui_check_mark_gkbrkn");
        else
            text = text .. GameTextGetTranslatedOrNot("$ui_uncheck_mark_gkbrkn");
        end
        text = text .. " ".. GameTextGetTranslatedOrNot(option.name);
        if option ~= nil and option.description ~= nil then
            if GuiButton( gui, 0, 0, GameTextGetTranslatedOrNot("$ui_info_button_gkbrkn"), next_id() ) then
                for word in string.gmatch( GameTextGetTranslatedOrNot(option.description), '([^\n]+)' ) do
                    GamePrint( word );
                end
            end
        end
        if GuiButton( gui, 0, 0, text, next_id() ) then
            gui_required_activation = math.max( gui_required_activation, option.activation_type )
            if option_enabled then
                RemoveFlagPersistent( option.flag );
            else
                AddFlagPersistent( option.flag );
            end
            if option.toggle_callback ~= nil then
                option.toggle_callback( not option_enabled );
            end
        end
    else
        GuiText( gui, 0, 0, option.name );
    end
    GuiLayoutEnd( gui );
end

function do_pagination( list, rows, columns, page )
    local page_info = {};
    local page_sizes = {};
    GuiLayoutBeginHorizontal( gui, 0, 0 );
    GuiText( gui, 0, 0, get_tab_name().." "..GameTextGetTranslatedOrNot("$ui_page_gkbrkn").." " );
    local page_rows = 0;
    local page_columns = 1;
    local page_size = 0;
    local page_breaks = {};
    for i=1,#list,1 do
        -- NOTE this logic is stupid and i'm tired, fix this later
        local entry_height = (list[i].height or 1);
        if page_rows + entry_height >= rows then
            page_columns = page_columns + 1;
            if page_columns > columns then
                table.insert( page_info, { size = page_size, breaks = page_breaks } );
                page_breaks = {};
                page_columns = 1;
                page_size = 0;
            end
            table.insert( page_breaks, page_rows );
            page_rows = entry_height;
        else
            page_rows = page_rows + entry_height;
        end
        page_size = page_size + entry_height;
    end
    table.insert( page_info, { size = page_size, breaks = page_breaks } );
    for i=1,#page_info do
        local text = "";
        if page == i then
            text = "("..i..")";
        else
            text = "  "..i.."  ";
        end
        if GuiButton( gui, 0, 0, text, next_id() ) then
            change_page( i );
        end
    end
    GuiLayoutEnd( gui );
    return page_info;
end

local auto_hide_message_shown = false;

if gui then
    async_loop(function()
        if gui then
            if HasFlagPersistent( MISC.AutoHide.EnabledFlag ) == false or GameGetFrameNum() - hide_menu_frame < 0 then
                do_gui();
            elseif auto_hide_message_shown == false then
                auto_hide_message_shown = true;
                GamePrint( GameTextGetTranslatedOrNot("$ui_auto_hide_message_gkbrkn") );
            end
            do_fps();
        end
        wait( 0 );
    end);
    change_screen(0);
end

print("[goki's things] done setting up GUI");
