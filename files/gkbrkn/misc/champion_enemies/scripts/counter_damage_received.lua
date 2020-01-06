dofile_once("data/scripts/lib/utilities.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity_id );

	if entity_who_caused == entity_id or entity_who_caused == 0 then return; end
	if script_wait_frames_fixed( entity_id, 10 ) then return; end
	
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
    
    local vx = math.cos( angle ) * length;
    local vy = 0 - math.sin( angle ) * length;
    shoot_projectile( entity_id, "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/counter_laser.xml", x, y, vx, vy );
end
