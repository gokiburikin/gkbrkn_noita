local memoize_dev_options = {};
function find_dev_option( id )
    local tweak = nil;
    if memoize_dev_options[id] then
        tweak = memoize_dev_options[id];
    else
        for _,entry in pairs(dev_options) do
            if entry.id == id then
                tweak = entry;
                memoize_dev_options[id] = entry;
            end
        end
    end
    return tweak;
end

dev_options = {
    {
        id = "infinite_mana",
        name = "$dev_option_name_gkbrkn_infinite_mana",
        description = "$dev_option_desc_gkbrkn_infinite_mana",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "infinite_spells",
        name = "$dev_option_name_gkbrkn_infinite_spells",
        description = "$dev_option_desc_gkbrkn_infinite_spells",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "recover_health",
        name = "$dev_option_name_gkbrkn_recover_health",
        description = "$dev_option_desc_gkbrkn_recover_health",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "invincibility",
        name = "$dev_option_name_gkbrkn_invincibility",
        description = "$dev_option_desc_gkbrkn_invincibility",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "infinite_money",
        name = "$dev_option_name_gkbrkn_infinite_money",
        description = "$dev_option_desc_gkbrkn_infinite_money",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "cheap_rerolls",
        name = "$dev_option_name_gkbrkn_cheap_rerolls",
        description = "$dev_option_desc_gkbrkn_cheap_rerolls",
        author = "$ui_author_name_goki_dev",
    }
}