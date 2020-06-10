dofile_once( "data/scripts/perks/perk_list.lua" );
dofile_once("data/scripts/gun/gun_actions.lua");

local register_removal = GKBRKN_CONFIG.register_removal;

for i=#perk_list,1,-1 do
    local perk = perk_list[i];
    register_removal( "remove_perk_"..perk.id, nil, { perk_id = perk.id } );
end

for i=#actions,1,-1 do
    local action = actions[i];
    register_removal( "remove_action_"..action.id, nil, { action_id = action.id } );
end