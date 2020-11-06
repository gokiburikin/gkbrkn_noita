dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua");
GameAddFlagRun( FLAGS.UberBoss );
if GameHasFlagRun( FLAGS.UberBoss ) then
    local _GameGetOrbCountThisRun = GameGetOrbCountThisRun;
    function GameGetOrbCountThisRun()
        _GameGetOrbCountThisRun();
        return 36;
    end
end