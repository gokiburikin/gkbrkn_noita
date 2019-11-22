if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end
if _GKBRKN_HELPER == nil then dofile( "files/gkbrkn/helper.lua"); end

if not async then
    -- guard against multiple inclusion to prevent
    -- loss of async coroutines
    dofile( "data/scripts/lib/coroutines.lua" )
end

local SCREEN = {
    Options = 1,
    ContentSelection = 2
}
local options = {}
local gui = gui or GuiCreate();
local gui_id = 1707;
local gui_require_restart = false;
local wrap_threshold = 15;
local wrap_size = 25;
local last_time = 0;
local fps_easing = 20;
local current_fps = 0;
local screen = 0;
local page = 0;
local id_offset = 0;
local sorted_content = {};
for index,content in pairs( CONTENT ) do
    if content.visible() then
        table.insert( sorted_content, { id=index, name=content.name } );
    end
end
table.sort( sorted_content, function( a, b ) return a.name < b.name end );

local pagination_list = nil;

function RegisterFlagOption( name, flag, require_restart, sub_option, required_flags, toggle_callback )
    table.insert( options, {
        name = name,
        flag = flag,
        require_restart = require_restart,
        sub_option = sub_option,
        required_flags = required_flags,
        toggle_callback = toggle_callback,
    } );
end

for _,option in pairs( OPTIONS ) do
    RegisterFlagOption( option.Name, option.PersistentFlag, option.RequiresRestart, option.SubOption, option.ToggleCallback );
end

function next_id()
    id_offset = id_offset + 1;
    return gui_id + id_offset;
end

function do_gui()
    id_offset = 0;
    GuiStartFrame(gui);
    GuiLayoutBeginVertical( gui, 87, 0 );
    local main_text = "[GKBRKN "..SETTINGS.Version.."]";
    if gui_require_restart == true then
        main_text = main_text.."*"
    end
    if GuiButton( gui, 0, 0, main_text, gui_id ) then
        if screen == SCREEN.Options then
            change_screen( 0 );
        else
            change_screen( SCREEN.Options );
        end
    end
    GuiLayoutEnd( gui );
    GuiLayoutBeginVertical( gui, 1, 12 );
    if screen == SCREEN.Options then
        local wrap_index = 0;
        for index,option in pairs( options ) do
            if option.sub_option == nil and index > ( wrap_index + 1 ) * wrap_threshold then
                wrap_index = wrap_index + 1;
                GuiLayoutEnd( gui );
                GuiLayoutBeginVertical( gui, wrap_size * wrap_index, 12 );
            end
            do_option( option, index );
        end
        GuiText( gui, 0, 0, " ");
        if GuiButton( gui, 0, 0, "[Content Selection]", next_id() ) then
            change_screen( SCREEN.ContentSelection );
        end
        GuiText( gui, 0, 0, " ");
        if GuiButton( gui, 0, 0, "[Close]", next_id() ) then
            change_screen( 0 );
        end
        if gui_require_restart == true then
            GuiText( gui, 0, 0, " ");
            GuiText( gui, 0, 0, "restart required *");
        end
    elseif screen == SCREEN.ContentSelection then
        --for index,action_id in pairs( sorted_actions ) do
        do_pagination( sorted_content, wrap_threshold );

        GuiLayoutBeginHorizontal( gui, 0, 0 );
        if GuiButton( gui, 0, 0, "[Back]", next_id() ) then
            change_screen( SCREEN.Options );
        end
        if GuiButton( gui, 0, 0, "[Enable All]", next_id() ) then
            for index,content_mapping in pairs( sorted_content ) do
                CONTENT[ content_mapping.id ].toggle( true );
            end
            gui_require_restart = true;
        end
        if GuiButton( gui, 0, 0, "[Disable All]", next_id() ) then
            for index,content_mapping in pairs( sorted_content ) do
                CONTENT[ content_mapping.id ].toggle( false );
            end
            gui_require_restart = true;
        end
        if GuiButton( gui, 0, 0, "[Toggle All]", next_id() ) then
            for index,content_mapping in pairs( sorted_content ) do
                CONTENT[ content_mapping.id ].toggle();
            end
            gui_require_restart = true;
        end
        GuiLayoutEnd( gui );

        GuiText( gui, 0, 0, " " );

        local start_index = 1+page * wrap_threshold;
        for i=start_index,math.min(start_index + wrap_threshold - 1, #sorted_content ),1 do
            local content = CONTENT[ sorted_content[i].id ];
            local text = "";
            local flag = get_content_flag( content.id );
            if flag ~= nil then
                if HasFlagPersistent( flag ) == true then
                    text = text .. "[ ]";
                else
                    text = text .. "[x]";
                end
                text = text .. " "..content.name;
            end
            if GuiButton( gui, 0, 0, text, next_id() ) then
                gui_require_restart = true;
                content.toggle();
            end
        end
        if gui_require_restart == true then
            GuiText( gui, 0, 0, " ");
            GuiText( gui, 0, 0, "restart required *");
        end
    end
    GuiLayoutEnd( gui );
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
            text = text .. "[x]";
        else
            text = text .. "[ ]";
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
    GuiText( gui, 0, 0, "Page " );
    for i=1,math.ceil(#list/per_page) do
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

if gui then async_loop(function() if gui then do_gui() end wait(0); end); end
