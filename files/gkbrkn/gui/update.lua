if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

if not async then
    -- guard against multiple inclusion to prevent
    -- loss of async coroutines
    dofile( "data/scripts/lib/coroutines.lua" )
end

local options = {}
local gui = gui or GuiCreate();
local gui_id = 1707;
local gui_open = false;
local gui_require_restart = false;
local wrap_threshold = 15;
local wrap_size = 25;

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

function do_gui()
    GuiStartFrame(gui);
    GuiLayoutBeginVertical( gui, 88, 0 );
    local main_text = "[GKBRKN Config]";
    if gui_require_restart == true then
        main_text = main_text.." *"
    end
    if GuiButton( gui, 0, 0, main_text, gui_id ) then
        gui_open = not gui_open;
    end
    GuiLayoutEnd( gui );
    GuiLayoutBeginVertical( gui, 1, 12 );
    if gui_open then
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
        if GuiButton( gui, 0, 0, "[Close]", gui_id + #options+ 1 ) then
            gui_open = false;
        end
        if gui_require_restart == true then
            GuiText( gui, 0, 0, "restart required *");
        end
    end
    GuiLayoutEnd( gui );
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
        if GuiButton( gui, 0, 0, text, gui_id + index ) then
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

if gui then async_loop(function() if gui then do_gui() end wait(0); end); end
