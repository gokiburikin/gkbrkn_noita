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
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_spells",
        name = "$dev_option_name_gkbrkn_infinite_spells",
        description = "$dev_option_desc_gkbrkn_infinite_spells",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "recover_health",
        name = "$dev_option_name_gkbrkn_recover_health",
        description = "$dev_option_desc_gkbrkn_recover_health",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "invincibility",
        name = "$dev_option_name_gkbrkn_invincibility",
        description = "$dev_option_desc_gkbrkn_invincibility",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "no_polymorph",
        name = "$dev_option_name_gkbrkn_no_polymorph",
        description = "$dev_option_desc_gkbrkn_no_polymorph",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_money",
        name = "$dev_option_name_gkbrkn_infinite_money",
        description = "$dev_option_desc_gkbrkn_infinite_money",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "cheap_rerolls",
        name = "$dev_option_name_gkbrkn_cheap_rerolls",
        description = "$dev_option_desc_gkbrkn_cheap_rerolls",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_flight",
        name = "$dev_option_name_gkbrkn_infinite_flight",
        description = "$dev_option_desc_gkbrkn_infinite_flight",
        author = "goki_dev",
        local_content = true,
    }
}