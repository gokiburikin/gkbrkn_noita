--##DEV local STATS = dofile_once("mods/gkbrkn_noita/files/gkbrkn/lib/stats.lua")

-- To really cache things contexts would need to subscribe to changes and clear their own
-- ModSettings variables and that's definitely not worth it

-- Instead we just clear the whole cache if things have changed when we check and we
-- only check once every 60 frames

-- This works for all contexts since they can keep track of their own last change frame

-- Either way, we want to reduce reliance on mod_settings dofile to reduce the performance hit

cache = cache or {}
last_parse = last_parse or -1
last_change = last_change or -1
changes = changes or {}
change_count = change_count or 0

local mod_key_prefix = "gkbrkn_noita."

-- Uncached
function setting_get_( key, default )
    --##DEV local t = GameGetRealWorldTimeSinceStarted()
    local result = ModSettingGet( mod_key_prefix..key )
    if result == nil then
        --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
        return default
    end
    -- Attempt to reduce issues with saved settings of the wrong type
    if default ~= nil and type(default) ~= type(result) then
        print("[goki's things] Warn: Saved value for "..key.." was not a "..type(default).."! Falling back to "..tostring(default))
        --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
        return default
    end
    --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
    return result
end

function setting_get( key, default )
    local t = GameGetRealWorldTimeSinceStarted()
    if GameGetFrameNum() - last_parse >= 60 then
        last_parse = GameGetFrameNum()
        parse_setting_changes()
    end
    if cache[key] ~= nil then
        --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
        return cache[key]
    end
    local result = ModSettingGet( mod_key_prefix..key )
    if result == nil then
        cache[key] = default
        --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
        return default
    end
    -- Attempt to reduce issues with saved settings of the wrong type
    if default ~= nil and type(default) ~= type(result) then
        print("[goki's things] Warn: Saved value for "..key.." was not a "..type(default).."! Falling back to "..tostring(default))
        --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
        cache[key] = default
        return default
    end
    --##DEV STATS.add_and_count("settings_get",(GameGetRealWorldTimeSinceStarted() - t))
    cache[key] = result
    return result
end

function setting_set( key, value )
    if value ~= nil and value ~= cache[key] then
        changes[key] = true
        change_count = change_count + 1
        cache[key] = nil
        return ModSettingSet( mod_key_prefix..key, value )
    end
end

function settings_broadcast_changes()
    if change_count > 0 then
        --local s = ""
        --for k,_ in pairs(changes) do
        --    s = s .. k..","
        --end
        --changes = {}
        change_count = 0
        ModSettingSet("gkbrkn_last_mod_setting_change",GameGetFrameNum())
        --ModSettingSet("gkbrkn_uncache_settings",s)
    end
end

function setting_has( key )
    return ModSettingGet( mod_key_prefix..key ) ~= nil
end

function setting_remove( key )
    cache[key] = nil
    return ModSettingRemove( mod_key_prefix..key )
end

function setting_is_ours( key )
    return string.sub(key,0,13) == mod_key_prefix
end

function parse_setting_changes()
    local last_settings_change = ModSettingGet("gkbrkn_last_mod_setting_change")
    if last_settings_change and last_settings_change > last_change then
        last_change = last_settings_change
        cache = {}
    end
end