dofile_once( "data/scripts/lib/coroutines.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )

function circleshot()
	--print("circleshot")

	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local angle  = 0
	local amount = 8 + orbcount
	local space  = math.floor(360 / amount)
	local speed  = 130
	
	for i=1,amount do
		local vel_x = math.cos( math.rad(angle) ) * speed
		local vel_y = math.sin( math.rad(angle) ) * speed
		angle = angle + space

		local orb = shoot_projectile( this, "data/entities/animals/boss_centipede/orb_circleshot.xml", pos_x, pos_y, vel_x, vel_y )
	end
end

function homingshot()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local vel_x = 0
	local vel_y = -30

	shoot_projectile( this, "mods/gkbrkn_noita/files/gkbrkn/append/boss_centipede/orb_homing.xml", pos_x, pos_y, vel_x, vel_y )
end

function orb_mat()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )
	
	local dir = math.random(0,1) * 2 - 1
	local vel_x = dir * math.random(50,100)
	local vel_y = math.random(-50,50)

	local names = {"lava","radioactive","blood"}
	
	if (orbcount > 2) then
		names = {"lava","radioactive","blood"}
	end
	
	if (orbcount > 6) then
		names = {"lava","radioactive","blood","oil"}
	end

	local rnd = math.random(#names)
	local pillar = shoot_projectile( this, "data/entities/animals/boss_centipede/orb_mat_" .. names[rnd] .. ".xml", pos_x, pos_y, vel_x, vel_y )
end

function clear_materials()
	local this         = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( this )

	local pillar = shoot_projectile( this, "data/entities/animals/boss_centipede/clear_materials.xml", pos_x, pos_y, 0, 0 )
end

function minion_check_maxcount()
	local result = false
	
	local existing_minion_count = 0
	local existing_minions = EntityGetWithTag( "boss_centipede_minion" )
	if ( #existing_minions > 0 ) then
		existing_minion_count = #existing_minions
	end
	
	local minion_max = 3 + math.floor(orbcount / 3)

	if existing_minion_count >= minion_max then
		result = true
	end
	
	return result
end

function prepare_chase()
	boss_wait(1)
end

function chase_start()
	local physics_ai = EntityGetFirstComponent( GetUpdatedEntityID(), "PhysicsAIComponent" )
	
	if (physics_ai ~= nil) then
		ComponentSetValue( physics_ai, "force_coeff", tostring( force_coeff_orig * 5.0 ) )
	end
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	
	if (celleater ~= nil) then
		ComponentSetValue( celleater, "eat_probability", tostring(20.0) )
	end
end

function chase_stop()
	local physics_ai = EntityGetFirstComponent( GetUpdatedEntityID(), "PhysicsAIComponent" )
	
	if (physics_ai ~= nil) then
		ComponentSetValue( physics_ai, "force_coeff", tostring( force_coeff_orig ) )
	end
	
	local celleater = EntityGetFirstComponent( GetUpdatedEntityID(), "CellEaterComponent" )
	
	if (celleater ~= nil) then
		ComponentSetValue( celleater, "eat_probability", tostring(0.0) )
	end
end
