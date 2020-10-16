local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );

if g_items ~= nil then
    local prob_sum = 0;
    for k,v in ipairs(g_items or {}) do
        prob_sum = prob_sum + (v.prob or 0);
    end
    table.insert( g_items, {
        prob = prob_sum * MISC.LegendaryWands.SpawnWeighting,
        min_count = 1,
        max_count = 1,
        entity = "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml"
    });
end