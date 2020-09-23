local memoize_tweaks = {};
function find_tweak( id )
    local tweak = nil;
    if memoize_tweaks[id] then
        tweak = memoize_tweaks[id];
    else
        for _,entry in pairs(tweaks) do
            if entry.id == id then
                tweak = entry;
                memoize_tweaks[id] = entry;
            end
        end
    end
    return tweak;
end

tweaks = {
    {
        id = "chainsaw",
        name = "$tweak_name_gkbrkn_chainsaw",
        description = "$tweak_desc_gkbrkn_chainsaw",
        author = "$ui_author_name_goki_dev",
        options = { action_id="CHAINSAW" },
    },
    {
        id = "heavy_shot",
        name = "$tweak_name_gkbrkn_heavy_shot",
        description = "$tweak_desc_gkbrkn_heavy_shot",
        author = "$ui_author_name_goki_dev",
        options = { action_id="HEAVY_SHOT" },
    },
    {
        id = "damage",
        name = "$tweak_name_gkbrkn_damage",
        description = "$tweak_desc_gkbrkn_damage",
        author = "$ui_author_name_goki_dev",
        options = { action_id="DAMAGE" },
    },
    {
        id = "freeze",
        name = "$tweak_name_gkbrkn_freeze",
        description = "$tweak_desc_gkbrkn_freeze",
        author = "$ui_author_name_goki_dev",
        options = { action_id="FREEZE" }
    },
    {
        id = "blindness",
        name = "$tweak_name_gkbrkn_blindness",
        description = "$tweak_desc_gkbrkn_blindness",
        author = "$ui_author_name_goki_dev",
        deprecated = true
    },
    {
        id = "revenge_explosion",
        name = "$tweak_name_gkbrkn_revenge_explosion",
        description = "$tweak_desc_gkbrkn_revenge_explosion",
        author = "$ui_author_name_goki_dev",
        options = { perk_id="REVENGE_EXPLOSION" },
        tags = {goki_thing = true}
    },
    {
        id = "revenge_tentacle",
        name = "$tweak_name_gkbrkn_revenge_tentacle",
        description = "$tweak_desc_gkbrkn_revenge_tentacle",
        author = "$ui_author_name_goki_dev",
        options = { perk_id="REVENGE_TENTACLE" },
        tags = {goki_thing = true}
    },
    {
        id = "glass_cannon",
        name = "$tweak_name_gkbrkn_glass_cannon",
        description = "$tweak_desc_gkbrkn_glass_cannon",
        author = "$ui_author_name_goki_dev",
        options = { perk_id="GLASS_CANNON" }
    },
    {
        id = "area_damage",
        name = "$tweak_name_gkbrkn_area_damage",
        description = "$tweak_desc_gkbrkn_area_damage",
        author = "$ui_author_name_goki_dev",
        options = { action_id="AREA_DAMAGE" }
    },
    {
        id = "chain_bolt",
        name = "$tweak_name_gkbrkn_chain_bolt",
        description = "$tweak_desc_gkbrkn_chain_bolt",
        author = "$ui_author_name_goki_dev",
        options = { action_id="CHAIN_BOLT" },
        tags = {goki_thing = true}
    },
    {
        id = "stun_lock",
        name = "$tweak_name_gkbrkn_stun_lock",
        description = "$tweak_desc_gkbrkn_stun_lock",
        author = "$ui_author_name_goki_dev",
    },
    {
        id = "projectile_repulsion",
        name = "$tweak_name_gkbrkn_projectile_repulsion",
        description = "$tweak_desc_gkbrkn_projectile_repulsion",
        author = "$ui_author_name_goki_dev",
        options = { perk_id="PROJECTILE_REPULSION" }
    },
    {
        id = "explosion_of_thunder",
        name = "$tweak_name_gkbrkn_explosion_of_thunder",
        description = "$tweak_desc_gkbrkn_explosion_of_thunder",
        author = "$ui_author_name_goki_dev",
        options = { action_id="THUNDER_BLAST" },
        tags = {goki_thing = true}
    },
    {
        id = "all_seeing_eye",
        name = "$tweak_name_gkbrkn_all_seeing_eye",
        description = "$tweak_desc_gkbrkn_all_seeing_eye",
        author = "$ui_author_name_goki_dev",
        options = { action_id="X_RAY" },
        deprecated = true,
    },
    {
        id = "spiral_shot",
        name = "$tweak_name_gkbrkn_spiral_shot",
        description = "$tweak_desc_gkbrkn_spiral_shot",
        author = "$ui_author_name_goki_dev",
        options = { action_id="SPIRAL_SHOT" },
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "piercing_shot",
        name = "$tweak_name_gkbrkn_piercing_shot",
        description = "$tweak_desc_gkbrkn_piercing_shot",
        author = "$ui_author_name_goki_dev",
        options = { action_id="PIERCING_SHOT" },
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "clipping_shot",
        name = "$tweak_name_gkbrkn_clipping_shot",
        description = "$tweak_desc_gkbrkn_clipping_shot",
        author = "$ui_author_name_goki_dev",
        options = { action_id="CLIPPING_SHOT" },
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "teleport_cast",
        name = "$tweak_name_gkbrkn_teleport_cast",
        description = "$tweak_desc_gkbrkn_teleport_cast",
        author = "$ui_author_name_goki_dev",
        options = { action_id="TELEPORT_CAST" },
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "blood_amount",
        name = "$tweak_name_gkbrkn_blood_amount",
        description = "$tweak_desc_gkbrkn_blood_amount",
        author = "$ui_author_name_goki_dev",
        options = { Multiplier = 0.98 }
    },
    {
        id = "allow_negative_mana_always_cast",
        name = "$tweak_name_gkbrkn_allow_negative_mana_always_cast",
        description = "$tweak_desc_gkbrkn_allow_negative_mana_always_cast",
        author = "$ui_author_name_goki_dev",
        enabled_by_default = true,
        tags = {goki_thing = true}
    },
    {
        id = "reduced_electrocution",
        name = "$tweak_name_gkbrkn_reduced_electrocution",
        description = "$tweak_desc_gkbrkn_reduced_electrocution",
        author = "$ui_author_name_goki_dev"
    },
    {
        id = "trigger_block_expansion",
        name = "$tweak_name_gkbrkn_trigger_block_expansion",
        description = "$tweak_desc_gkbrkn_trigger_block_expansion",
        author = "$ui_author_name_goki_dev",
        enabled_by_default = true,
        tags = {goki_thing = true}
    }
}