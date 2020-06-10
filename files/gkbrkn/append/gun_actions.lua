dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );

for i=#actions,1,-1 do
    local action = actions[i];
    local content = CONTENT[REMOVALS["remove_action_"..action.id]];
    if content and content.enabled() then
        table.remove( actions, i );
    end
end