local MISC = dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/options.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local take_damage_triggers = EntityGetWithTag("gkbrkn_trigger_take_damage_projectile") or {}
    if damage > 0 then
        for _,trigger in pairs( take_damage_triggers ) do
            if not EntityHasVarTag( trigger, "gkbrkn_clear_tag") then
                EntityAddVarTag( trigger, "gkbrkn_trigger" )
            end
        end
    end
end