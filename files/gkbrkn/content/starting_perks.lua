local memoize_starting_perks = {};
function find_starting_perk( id )
    local starting_perk = nil;
    if memoize_starting_perks[id] then
        starting_perk = memoize_starting_perks[id];
    else
        for _,entry in pairs(starting_perks) do
            if entry.id == id then
                starting_perk = entry;
                memoize_starting_perks[id] = entry;
            end
        end
    end
    return starting_perk;
end

starting_perks = {};