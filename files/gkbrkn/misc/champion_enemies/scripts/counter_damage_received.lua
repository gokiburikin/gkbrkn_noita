dofile_once("data/scripts/lib/utilities.lua");

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity_id );

	if entity_who_caused == entity_id then return end

	-- check that we're only shooting every 10 frames
	if script_wait_frames( entity_id, 2 ) then  return  end
	
	local angle_inc = 0;
	local angle_inc_set = false;
	
	local length = 100;
	
	if entity_who_caused ~= nil and entity_who_caused ~= NULL_ENTITY then
		local ex, ey = EntityGetTransform( entity_who_caused );
		
		if ( ex ~= nil ) and ( ey ~= nil ) then
			angle_inc = 0 - math.atan2( ( ey - y ), ( ex - x ) );
			angle_inc_set = true;
		end
	end
	
    local angle = 0;
    if angle_inc_set then
        angle = angle_inc + Random( -5, 5 ) * 0.01;
    else
        angle = math.rad( Random( 1, 360 ) );
    end
    
    local vel_x = math.cos( angle ) * length;
    local vel_y = 0- math.sin( angle ) * length;
    shoot_projectile( entity_id, "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/counter_laser.xml", x, y, vel_x, vel_y );
end
