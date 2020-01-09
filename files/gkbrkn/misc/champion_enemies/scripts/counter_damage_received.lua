dofile_once( "data/scripts/lib/utilities.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );

	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return; end
    limit_to_every_n_frames( entity, "gkbrkn_counter_damage", 10, function()
        local angle_inc = 0;
        local angle_inc_set = false;
        
        local length = 100;
        
        if EntityGetIsAlive( entity_who_caused ) then
            local ex, ey = EntityGetTransform( entity_who_caused );
            angle_inc = 0 - math.atan2( ey - y, ex - x );
            angle_inc_set = true;
        end
        
        local angle = 0;
        if angle_inc_set then
            angle = angle_inc + Random( -5, 5 ) * 0.01;
        else
            angle = math.rad( Random( 1, 360 ) );
        end
        
        local vx = math.cos( angle ) * length;
        local vy = 0 - math.sin( angle ) * length;
        shoot_projectile( entity, "mods/gkbrkn_noita/files/gkbrkn/misc/champion_enemies/entities/counter_laser.xml", x, y, vx, vy );
    end );
end
