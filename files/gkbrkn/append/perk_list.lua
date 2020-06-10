dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );

for i=#perk_list,1,-1 do
    local perk = perk_list[i];
    if perk.not_in_default_perk_pool ~= true then
        local content = CONTENT[REMOVALS["remove_perk_"..perk.id]];
        if content and content.enabled() then
            perk.not_in_default_perk_pool = true;
            print( "moved "..perk.id.."out of perk pool");
            --table.remove( perk_list, i );
        end
    end
end