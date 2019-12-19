dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
table.insert( actions, generate_action_entry(
    "GKBRKN_COPY_SPELL", "copy_spell", ACTION_TYPE_OTHER,
    "0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 350, 30, -1,
    nil,
    function()
        local drawn = false;
        for index,action in pairs(deck) do
            if action.id ~= "GKBRKN_COPY_SPELL" and ( action.uses_remaining == nil or action.uses_remaining < 0 ) then
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