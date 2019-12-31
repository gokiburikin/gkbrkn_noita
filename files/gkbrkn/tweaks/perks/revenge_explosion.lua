dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
	
	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return; end
    local now = GameGetFrameNum();
	if now - EntityGetVariableNumber( entity, "gkbrkn_rexplosion_last_proc", 0 ) < 5 then return; end
    EntitySetVariableNumber( entity, "gkbrkn_rexplosion_last_proc", now );
	shoot_projectile( entity, "data/entities/misc/perks/revenge_explosion.xml", x, y, 0, 0 );
end
