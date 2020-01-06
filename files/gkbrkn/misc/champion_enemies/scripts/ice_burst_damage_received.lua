dofile_once("data/scripts/lib/utilities.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua");

last_activation_frame = -1;

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity    = GetUpdatedEntityID();
	local x, y = EntityGetTransform( entity );

	if entity_who_caused == entity or entity_who_caused == 0 then return; end

	-- check that we're only shooting every 10 frames
	if GameGetFrameNum() - last_activation_frame < 10 then return; end
    last_activation_frame = GameGetFrameNum();

	local how_many = 6;
	local angle_inc = ( 2 * math.pi ) / how_many;
	local length = 100;
    local distance = 16;

	for i=0,how_many-1 do
		local theta = i * angle_inc + GameGetFrameNum();
        local px = x + math.cos( theta ) * distance;
		local py = y + math.sin( theta ) * distance;
		local vx = math.cos( theta ) * length;
		local vy = math.sin( theta ) * length;

		shoot_projectile( entity, "data/entities/projectiles/ice.xml", px, py, vx, vy );
	end
end
