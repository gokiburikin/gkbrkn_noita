dofile_once("data/scripts/lib/utilities.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );

local _collision_trigger = collision_trigger;
function collision_trigger()
    if GameHasFlagRun( FLAGS.CalmGods ) then
        StatsBiomeReset();
        GameTriggerMusicFadeOutAndDequeueAll( 2.0 );
    else
        _collision_trigger();
    end
end