dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "data/scripts/lib/coroutines.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua");

local SCREEN = {
    Options = 1,
    ContentSelection = 2,
    ContentTypeSelection = 3,
}
local options = {}
local gui = gui or GuiCreate();
local gui_id = 1707;
local gui_require_restart = false;
local wrap_threshold = 16;
local wrap_limit = 3;
local wrap_size = 28;
local last_time = 0;
local fps_easing = 20;
local current_fps = 0;
local screen = 0;
local page = 0;
local id_offset = 0;
local sorted_content = {};
local content_counts = {};
local content_type_selection = {};
local content_type = nil;
local tab_index = 1;
local hide_menu_frame = GameGetFrameNum() + 300;
local tabs = {
    {
        name = gkbrkn_localization.ui_tab_name_options,
        screen = SCREEN.Options,
    }
}
for index,content in pairs( CONTENT ) do
    if content.visible() then
        table.insert( sorted_content, { id=index, name=content.name } );
        content_counts[content.type] = ( content_counts[content.type] or 0 ) + 1;
    end
end
table.sort( sorted_content, function( a, b ) return a.name < b.name end );

for k,v in pairs( CONTENT_TYPE ) do
    local name = CONTENT_TYPE_DISPLAY_NAME[v];
    --if SETTINGS.Debug then
    --    name = ( content_counts[v] or 0 ).." "..name;
    --end
    table.insert( content_type_selection, { name = name, type = v } );
    table.insert( tabs, { name = name, screen = SCREEN.ContentSelection, content_type = v } );
end
table.sort( content_type_selection, function( a, b ) return a.name < b.name end );

function filter_content( content_list, content_type )
    local filtered = {};
    for _,content in pairs( content_list ) do
        if CONTENT[content.id].type == content_type then
            table.insert( filtered, content );
        end
    end
    return filtered;
end

local pagination_list = nil;

function RegisterFlagOption( name, flag, require_restart, sub_option, required_flags, toggle_callback, require_new_game )
    table.insert( options, {
        name = name,
        flag = flag,
        require_restart = require_restart,
        sub_option = sub_option,
        required_flags = required_flags,
        toggle_callback = toggle_callback,
        require_new_game = require_new_game,
    } );
end

for _,option in pairs( OPTIONS ) do
    RegisterFlagOption( option.Name, option.PersistentFlag, option.RequiresRestart, option.SubOption, option.RequiredFlags, option.ToggleCallback, option.RequiresNewGame );
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

function do_gui()
    id_offset = 0;
    GuiStartFrame( gui );

    -- Config Menu Bitton
    GuiLayoutBeginVertical( gui, 86, 0 ); -- fold vertical
        local main_text = "["..gkbrkn_localization.ui_mod_name.." "..SETTINGS.Version.."]";
        if gui_require_restart == true then
            main_text = main_text.."*"
        end
        if GuiButton( gui, 0, 0, main_text, gui_id ) then
            if screen ~= 0 then
                change_screen( 0 );
            else
                change_screen( SCREEN.Options );
            end
        end
    GuiLayoutEnd( gui ); -- fold vertical

    if SETTINGS ~= nil and SETTINGS.Debug then
        GuiLayoutBeginVertical( gui, 92, 93 );
        local update_time = get_update_time();
        reset_update_time();
        GuiText( gui, 0, 0, tostring( math.floor( update_time * 100000 ) / 100 ).."ms/pu" );
        GuiLayoutEnd( gui );
    end

    GuiLayoutBeginVertical( gui, 1, 12 );  -- main vertical
    if screen ~= 0 then
        -- TODO needed until stable gets this
        if GameCreateSpriteForXFrames ~= nil then
            local cx, cy = GameGetCameraPos();
            GameCreateSpriteForXFrames( "mods/gkbrkn_noita/files/gkbrkn/gui/darken.png", cx, cy );
        end
        hide_menu_frame = GameGetFrameNum() + 300;
        GuiLayoutBeginHorizontal( gui, 0, 0 ); -- tabs horizontal
        local tab_index = 1;
        for index,tab_data in pairs( tabs ) do
            local tab_title = tab_data.name;
            local is_current_tab = false;
            if screen == tab_data.screen and ( tab_data.content_type == nil or content_type == tab_data.content_type ) then
                is_current_tab = true;
            end
            if DEBUG then
                tab_title = ( content_counts[index] or 0 ).." "..tab_title
            end
            if is_current_tab then
                tab_title = ">"..tab_title.."<";
            else
                tab_title = "["..tab_title.."]";
            end
            if GuiButton( gui, 0, 0, tab_title.." ", next_id() ) then
                change_screen( tab_data.screen );
                if tab_data.content_type ~= nil then
                    content_type = tab_data.content_type;
                end
            end
            if tab_index % 7 == 0 then
                GuiLayoutEnd( gui ); -- tabs horizontal
                GuiLayoutBeginHorizontal( gui, 0, 0 ); -- tabs horizontal
            end
            tab_index = tab_index + 1;
        end
        GuiLayoutEnd( gui ); -- tabs horizontal
    end

    if screen == SCREEN.Options then
        local wrap_threshold = 12;
        GuiText( gui, 0, 0, " ");
        do_pagination( options, wrap_threshold * wrap_limit );
        GuiText( gui, 0, 0, " ");
        GuiLayoutBeginVertical( gui, 0, 0 );
        local wrap_index = 1;
        local start_index = 1 + page * wrap_threshold * wrap_limit;
        local option_index = 0;
        for index=start_index,math.min( start_index + wrap_threshold * wrap_limit - 1, #options ),1 do
            local option = options[index];
            if option.sub_option == nil and option_index >= wrap_index * wrap_threshold then
                wrap_index = wrap_index + 1;
                GuiLayoutEnd( gui );
                GuiLayoutBeginVertical( gui, wrap_size * math.floor( option_index / wrap_threshold ), 0 );
            end
            do_option( option, index );
            option_index = option_index + 1;
        end
        if gui_require_restart == true then
            GuiText( gui, 0, 0, " ");
            GuiText( gui, 0, 0, gkbrkn_localization.ui_restart_required.." *");
        end
        GuiLayoutEnd( gui );
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
        --for index,action_id in pairs( sorted_actions ) do
        GuiText( gui, 0, 0, " ");
        do_pagination( filtered_content, wrap_threshold * wrap_limit );
        GuiLayoutBeginHorizontal( gui, 0, 0 ); -- quick bar horizontal
            if GuiButton( gui, 0, 0, "["..gkbrkn_localization.ui_enable_all.."]", next_id() ) then
                for index,content_mapping in pairs( filtered_content ) do
                    CONTENT[ content_mapping.id ].toggle( true );
                end
                gui_require_restart = true;
            end
            if GuiButton( gui, 0, 0, "["..gkbrkn_localization.ui_disable_all.."]", next_id() ) then
                for index,content_mapping in pairs( filtered_content ) do
                    CONTENT[ content_mapping.id ].toggle( false );
                end
                gui_require_restart = true;
            end
            if GuiButton( gui, 0, 0, "["..gkbrkn_localization.ui_toggle_all.."]", next_id() ) then
                for index,content_mapping in pairs( filtered_content ) do
                    CONTENT[ content_mapping.id ].toggle();
                end
                gui_require_restart = true;
            end
        GuiLayoutEnd( gui ); -- quick bar horizontal
        GuiText( gui, 0, 0, " " );
        GuiLayoutBeginVertical( gui, 0, 0 ); -- content wrapping vertical
        local wrap_index = 1;
        local start_index = 1 + page * wrap_threshold * wrap_limit;
        local option_index = 0;
        for index=start_index,math.min(start_index + wrap_threshold * wrap_limit - 1, #filtered_content ),1 do
            local content = CONTENT[ filtered_content[index].id ];
            if option_index >= wrap_threshold * wrap_index then
                wrap_index = wrap_index + 1;
                GuiLayoutEnd( gui ); -- content wrapping vertical
                GuiLayoutBeginVertical( gui, wrap_size * math.floor( option_index / wrap_threshold ), 0 ); -- content wrapping vertical
            end
            local text = "";
            local flag = get_content_flag( content.id );
            if flag ~= nil then
                if content.enabled() == true then
                    text = text .. gkbrkn_localization.ui_check_mark;
                else
                    text = text .. gkbrkn_localization.ui_uncheck_mark;
                end
                text = text .. " "..content.name;
            end
            
            GuiLayoutBeginHorizontal( gui, 0, 0 );
            if GuiButton( gui, 0, 0, text, next_id() ) then
                gui_require_restart = true;
                content.toggle();
            end
            GuiLayoutEnd( gui ); -- content wrapping vertical
            option_index = option_index + 1;
        end
        if gui_require_restart == true then
            GuiText( gui, 0, 0, " ");
            GuiText( gui, 0, 0, gkbrkn_localization.ui_restart_required.." *");
        end
        GuiLayoutEnd( gui ); -- content wrapping vertical
    end
    GuiLayoutEnd( gui ); -- main vertical
end

function do_fps()
    if HasFlagPersistent( MISC.ShowFPS.Enabled ) then
        local now = GameGetRealWorldTimeSinceStarted();
        local fps = 1 / (now - last_time);
        current_fps = current_fps + (fps - current_fps ) / fps_easing;
        last_time = now;
        GuiLayoutBeginVertical( gui, 82, 0 );
        GuiText( gui, 0, 0, (math.floor( current_fps * 10) / 10) );
        GuiLayoutEnd( gui );
    end
end

function change_screen( new_screen )
    screen = new_screen;
    page = 0;
end

function do_option( option, index )
    GuiLayoutBeginHorizontal( gui, 0, 0 );
    if option.flag ~= nil then
        local text = "";
        if option.sub_option then
            text = text.. "    ";
        end
        local option_enabled = HasFlagPersistent( option.flag );
        if option_enabled then
            text = text .. gkbrkn_localization.ui_check_mark;
        else
            text = text .. gkbrkn_localization.ui_uncheck_mark;
        end
        text = text .. " ".. option.name;
        if GuiButton( gui, 0, 0, text, next_id() ) then
            if option.require_restart == true then
                gui_require_restart = true;
            end
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

function do_pagination( list, per_page )
    GuiLayoutBeginHorizontal( gui, 0, 0 );
    GuiText( gui, 0, 0, get_tab_name().." "..gkbrkn_localization.ui_page.." " );
    for i=1,math.ceil( #list / per_page ) do
        local text = "";
        if page == i-1 then
            text = "("..i..")";
        else
            text = "  "..i.."  ";
        end
        if GuiButton( gui, 0, 0, text, next_id() ) then
            page = i-1;
        end
    end
    GuiLayoutEnd( gui );
end

local auto_hide_message_shown = false;

if gui then
    async_loop(function()
        if gui then
            if HasFlagPersistent( MISC.AutoHide.Enabled ) == false or GameGetFrameNum() - hide_menu_frame < 0 then
                do_gui();
            elseif auto_hide_message_shown == false then
                auto_hide_message_shown = true;
                GamePrint( gkbrkn_localization.ui_auto_hide_message );
            end
            do_fps();
        end
        wait( 0 );
    end);
end