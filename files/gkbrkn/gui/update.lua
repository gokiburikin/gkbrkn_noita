if _GKBRKN_CONFIG == nil then dofile( "files/gkbrkn/config.lua"); end

if not async then
    -- guard against multiple inclusion to prevent
    -- loss of async coroutines
    dofile( "data/scripts/lib/coroutines.lua" )
end

options = {}
gui = gui or GuiCreate();
gui_id = 1707;
gui_open = false;
gui_require_restart = false;

function RegisterFlagOption( name, flag, require_restart, sub_option, required_flags )
    table.insert( options, {
        name = name,
        flag = flag,
        require_restart = require_restart,
        sub_option = sub_option,
        required_flags = required_flags,
    } );
end

for _,option in pairs( OPTIONS ) do
    RegisterFlagOption( option.Name, option.PersistentFlag, option.RequiresRestart, option.SubOption );
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
        for index,option in pairs( options ) do
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
        if HasFlagPersistent( option.flag ) then
            text = text .. "[x]";
        else
            text = text .. "[ ]";
        end
        text = text .. " ".. option.name;
        if GuiButton( gui, 0, 0, text, gui_id + index ) then
            if option.require_restart == true then
                gui_require_restart = true;
            end
            if HasFlagPersistent( option.flag ) then
                RemoveFlagPersistent( option.flag );
            else
                AddFlagPersistent( option.flag );
            end
        end
    else
        GuiText( gui, 0, 0, option.name );
    end
    GuiLayoutEnd( gui );
end

if gui then async_loop(function() if gui then do_gui() end wait(0); end); end
