dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return; end
    SetRandomSeed( GameGetFrameNum(), x + y + entity );
    if Random() <= 0.15 then
        GetGameEffectLoadTo( entity, "TELEPORTATION", true );
    end
end
