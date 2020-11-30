function setting_get( key ) return ModSettingGet( "gkbrkn_noita."..key ); end
function setting_set( key, value ) if value ~= nil then return ModSettingSet( "gkbrkn_noita."..key, value ); end end
function setting_clear( key ) return ModSettingRemove( "gkbrkn_noita."..key ); end