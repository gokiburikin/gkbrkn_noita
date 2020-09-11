local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" );

if g_items ~= nil then
    table.insert( g_items, {
        prob = MISC.LegendaryWands.SpawnWeighting,
        min_count = 1,
        max_count = 1,
        entity = "mods/gkbrkn_noita/files/gkbrkn/misc/legendary_wands/legendary_wand.xml"
    });
end