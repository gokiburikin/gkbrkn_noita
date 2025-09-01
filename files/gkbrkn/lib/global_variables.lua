function GlobalsSetNumber( key, value )
    if not type(value) == "number" then return end
    if value ~= value then return end -- NaN
    GlobalsSetValue( key, value )
end

function GlobalsGetNumber( key, default )
    local result = tonumber(GlobalsGetValue(key))
    if result == nil then return default end
    return result
end

function MSGlobalsSetNumber( key, value )
    if not type(value) == "number" then return end
    if value ~= value then return end -- NaN
    ModSettingSet( key, value )
end

function MSGlobalsGetNumber( key, default )
    local result = ModSettingGet( key, value )
    if result == nil then return default end
    return result
end