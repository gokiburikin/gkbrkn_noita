dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/mod_settings.lua");
if setting_get( FLAGS.UberBossCount ) > -1 then
    local _GameGetOrbCountThisRun = GameGetOrbCountThisRun;
    function GameGetOrbCountThisRun()
        _GameGetOrbCountThisRun();
        return setting_get( FLAGS.UberBossCount );
    end
end