dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );
dofile_once( "data/scripts/lib/utilities.lua" );

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity    = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );
	
	SetRandomSeed( GameGetFrameNum(), x + y + entity );
	
	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return; end
    local now = GameGetFrameNum();
	if now - EntityGetVariableNumber( entity, "gkbrkn_rtentacle_last_proc", 0 ) < 2 then return; end
    EntitySetVariableNumber( entity, "gkbrkn_rtentacle_last_proc", now );
	
	local angle = math.rad( Random( 1, 360 ) );
	local angle_random = math.rad( Random( -5, 5 ) );
	local vx = 0;
	local vy = 0;
	local length = 600;
	
    local ex, ey = EntityGetTransform( entity_who_caused );
    if EntityGetIsAlive( entity_who_caused ) then
        angle = 0 - math.atan2( ey - y, ex - x );
    end
	
	vx = math.cos( angle + angle_random ) * length;
	vy = 0- math.sin( angle + angle_random ) * length;
	shoot_projectile( entity, "data/entities/misc/perks/revenge_tentacle_tentacle.xml", x, y, vx, vy );
end
