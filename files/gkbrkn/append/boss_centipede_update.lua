dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua")
local _GameGetOrbCountThisRun = GameGetOrbCountThisRun
function GameGetOrbCountThisRun()
    _GameGetOrbCountThisRun()
    return setting_get( FLAGS.UberBossCount, -1 )
end