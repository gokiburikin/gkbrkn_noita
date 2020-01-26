dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_COPY_SPELL", "copy_spell", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 300, 20, -1,
    nil,
    function()
        local drawn = false;
        for index,action in pairs( deck ) do
            if action.uses_remaining == nil or action.uses_remaining < 0 then
                action.action();
                drawn = true;
                break;
            end
        end
        if drawn == false then
            draw_actions( 1, true );
        end
    end
) );