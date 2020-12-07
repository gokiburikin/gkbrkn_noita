dofile_once( "data/scripts/perks/perk.lua" );
dofile_once( "data/scripts/perks/perk_list.lua" );
local available_perks = {};
for k,v in pairs( perk_get_spawn_order() or {} ) do
    available_perks[v] = true;
end

return function()
    local perk_data = {};
    for k,perk in pairs( perk_list ) do
        perk_data[perk.id] = perk;
        perk_data[perk.id].missing = available_perks[perk.id] == nil;
        perk_data[perk.id].not_in_pool = perk.not_in_default_perk_pool;
        perk_data[perk.id].stackable = perk_is_stackable( perk );
        perk_data[perk.id].enabled = true;
    end
    for k,perk in pairs( perk_list_cache ) do
        if perk_data[perk.id] == nil then
            perk_data[perk.id] = perk;
            perk_data[perk.id].missing = available_perks[perk.id] == nil;
            perk_data[perk.id].not_in_pool = perk.not_in_default_perk_pool;
            perk_data[perk.id].stackable = perk_is_stackable( perk );
            perk_data[perk.id].enabled = false;
        end
    end
    return perk_data;
end