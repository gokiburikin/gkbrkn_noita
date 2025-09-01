dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")

local entity = GetUpdatedEntityID()
for _,p in pairs(EntityGetComponent( entity, "ProjectileComponent" )) do
    local total_damage = get_projectile_total_damage( p )
    remove_all_projectile_damage( p )
    ComponentObjectSetValue2( p, "damage_by_type", "drill", total_damage )
end
