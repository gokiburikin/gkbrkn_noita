local memoize_cheats = {}
function find_cheat( id )
    local tweak = nil
    if memoize_cheats[id] then
        tweak = memoize_cheats[id]
    else
        for _,entry in pairs(cheats) do
            if entry.id == id then
                tweak = entry
                memoize_cheats[id] = entry
            end
        end
    end
    return tweak
end

cheats = {
    {
        id = "infinite_mana",
        name = "$cheat_name_gkbrkn_infinite_mana",
        description = "$cheat_desc_gkbrkn_infinite_mana",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_spells",
        name = "$cheat_name_gkbrkn_infinite_spells",
        description = "$cheat_desc_gkbrkn_infinite_spells",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "one_hit_kills",
        name = "$cheat_name_gkbrkn_one_hit_kills",
        description = "$cheat_desc_gkbrkn_one_hit_kills",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "recover_health",
        name = "$cheat_name_gkbrkn_recover_health",
        description = "$cheat_desc_gkbrkn_recover_health",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "invincibility",
        name = "$cheat_name_gkbrkn_invincibility",
        description = "$cheat_desc_gkbrkn_invincibility",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "no_polymorph",
        name = "$cheat_name_gkbrkn_no_polymorph",
        description = "$cheat_desc_gkbrkn_no_polymorph",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_money",
        name = "$cheat_name_gkbrkn_infinite_money",
        description = "$cheat_desc_gkbrkn_infinite_money",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "cheap_rerolls",
        name = "$cheat_name_gkbrkn_cheap_rerolls",
        description = "$cheat_desc_gkbrkn_cheap_rerolls",
        author = "goki_dev",
        local_content = true,
    },
    {
        id = "infinite_flight",
        name = "$cheat_name_gkbrkn_infinite_flight",
        description = "$cheat_desc_gkbrkn_infinite_flight",
        author = "goki_dev",
        local_content = true,
    }
}