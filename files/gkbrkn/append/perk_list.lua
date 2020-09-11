local memoize_perks = {};
function find_perk( id )
    local perk = nil;
    if memoize_perks[id] then
        perk = memoize_perks[id];
    else
        for _,entry in pairs(perk_list) do
            if entry.id == id then
                perk = entry;
                memoize_perks[id] = entry;
            end
        end
    end
    return perk;
end