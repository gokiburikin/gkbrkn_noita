dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	if entity_who_caused == EntityGetParent(entity_id) then return end

	-- check that we're only shooting every 10 frames
	if script_wait_frames( entity_id, 5 ) then  return  end
	shoot_projectile( entity_id, "data/entities/misc/perks/revenge_explosion.xml", pos_x, pos_y, 0, 0 )
end
