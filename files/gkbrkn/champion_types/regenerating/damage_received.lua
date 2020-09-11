dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity = tonumber(GetUpdatedEntityID());
    if tonumber(entity_who_caused) ~= 0 and tonumber(entity_who_caused) ~= entity then
        EntitySetVariableNumber( entity, "gkbrkn_last_damage_frame", GameGetFrameNum() );
    end
end
