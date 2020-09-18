dofile_once("data/scripts/lib/utilities.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" )

local _collision_trigger = collision_trigger;
function collision_trigger()
    if GameHasFlagRun( FLAGS.CalmGods ) then
        local entity_id    = GetUpdatedEntityID();
        local pos_x, pos_y = EntityGetTransform( entity_id );
        StatsBiomeReset();
        GameTriggerMusicFadeOutAndDequeueAll( 2.0 );
        EntityKill( entity_id );
    else
        _collision_trigger();
    end
end