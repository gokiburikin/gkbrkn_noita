dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
local entity = GetUpdatedEntityID()
local p = EntityGetFirstComponent( entity, "ProjectileComponent" )
if p then
    local shooter = ComponentGetValue2( p, "mWhoShot" ) or 0
    if shooter ~= 0 then
        local damage_type = EntityGetVariableString( shooter, "gkbrkn_green_magic_damage_type", "" )
        if damage_type ~= "" then
            convert_all_projectile_damage( p, damage_type )
        end
    end
end