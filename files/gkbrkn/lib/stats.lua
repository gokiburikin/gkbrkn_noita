dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/global_variables.lua")

local prefix = "gkbrkn_stats_"
return {
add = function( stat, amount )
    MSGlobalsSetNumber( prefix..stat.."_total", MSGlobalsGetNumber( prefix..stat.."_total", 0 ) + amount )
end,
add_and_count = function( stat, amount, count )
    MSGlobalsSetNumber( prefix..stat.."_total", MSGlobalsGetNumber( prefix..stat.."_total", 0 ) + amount )
    MSGlobalsSetNumber( prefix..stat.."_count", MSGlobalsGetNumber( prefix..stat.."_count", 0 ) + (count or 1) )
end,
count = function( stat, amount )
    MSGlobalsSetNumber( prefix..stat.."_count", MSGlobalsGetNumber( prefix..stat.."_count", 0 ) + (amount or 1) )
end,
clear = function( stat, amount )
    MSGlobalsSetNumber( prefix..stat.."_total", 0 )
    MSGlobalsSetNumber( prefix..stat.."_count", 0 )
end,
get = function( stat ) return MSGlobalsGetNumber( prefix..stat.."_total", 0 )end,
get_count = function( stat ) return MSGlobalsGetNumber( prefix..stat.."_count", 0 ) end,
clear_all = function()
    local to_remove = {}
    for i=0,ModSettingGetCount() do
        local name, value, value_next = ModSettingGetAtIndex( i )
        if name ~= nil and string.sub(name,1,13) == prefix then
            table.insert(to_remove, name)
        end
    end
    for _,key in ipairs(to_remove) do
        ModSettingRemove(key)
    end
end
}