dofile_once("data/scripts/lib/utilities.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/flags.lua" );

local _collision_trigger = collision_trigger;
function collision_trigger()
    if GameHasFlagRun( FLAGS.CalmGods ) then
        StatsBiomeReset();
        GameTriggerMusicFadeOutAndDequeueAll( 2.0 );
    else
        local entity_id    = GetUpdatedEntityID()
        local pos_x, pos_y = EntityGetTransform( entity_id )

        StatsBiomeReset()

        EntityLoad("data/entities/misc/workshop_collapse.xml", pos_x-112, pos_y+82)
        EntityLoad("data/entities/misc/workshop_areadamage.xml", pos_x-111, pos_y+47)
        EntityLoad("data/entities/misc/workshop_areadamage.xml", pos_x-511, pos_y+47)
        
        local workshop_1 = EntityGetClosestWithTag( pos_x, pos_y, "workshop" )
        EntityKill( workshop_1 );
        
        local workshop_2 = EntityGetClosestWithTag( pos_x, pos_y, "workshop" )
        EntityKill( workshop_2 );
        
        local workshop_2b = EntityGetClosestWithTag( pos_x, pos_y, "workshop" )
        EntityKill( workshop_2b );

        local workshop_3 = EntityGetClosestWithTag( pos_x, pos_y, "workshop_show_hint" )
        EntityKill( workshop_3 );

        GameTriggerMusicFadeOutAndDequeueAll( 2.0 )
        GamePlaySound( "data/audio/Desktop/misc.snd", "misc/temple_collapse", pos_x-112, pos_y + 40 )
    end
end