dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")

local print_deck = function( custom_deck )
	if custom_deck == nil then custom_deck = deck end
	local d = ""
	for k,v in pairs(custom_deck) do
		d = d .. v.id..", "
	end
	print(d)
end

local add_extra_entity_unique = function( s )
	if not c.extra_entities:find(s) then
		c.extra_entities = c.extra_entities .. s
	end
end

local find_action_by_id = function( action_id )
	for _,a in pairs(actions) do
		if a.id == action_id then return a end
	end
end

local find_action_entity = function( action )
	for _,e in pairs(EntityGetWithTag("card_action")) do
		local item = EntityGetFirstComponentIncludingDisabled( e, "ItemComponent" )
		if item then
			if ComponentGetValue2( item, "mItemUid" ) == action.inventoryitem_id then
				return e
			end
		end
	end
end

--[[ NORMAL ]]
	table.insert( actions, generate_action_entry(
		"GKBRKN_DUMMY_SHOT", "dummy_shot", ACTION_TYPE_MODIFIER, 
		"1,3,5", "0.4,0.4,0.4", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/dummy_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ARCANE_BUCKSHOT", "arcane_buckshot", ACTION_TYPE_PROJECTILE,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 210, 12, -1,
		nil, 
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_buckshot/projectile.xml" )
			c.fire_rate_wait = c.fire_rate_wait + 16
			current_reload_time = current_reload_time + 42
		end, true
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_SEPARATOR", "separator", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 0, -1,
		nil, 
		function()
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			-- Wrapping logic inside an instantly killed death trigger allows us to "commit" a 
			-- cast to the game
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					draw_actions( 1, true )
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_ISOLATOR", "isolator", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 0, -1,
		nil, 
		function()
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			-- Wrapping logic inside an instantly killed death trigger allows us to "commit" a 
			-- cast to the game
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					push_c()
					draw_actions( 1, true )
					register_action( c )
					SetProjectileConfigs()
					pop_c()
				EndTrigger()
			EndProjectile()
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_EVALUATOR", "evaluator", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 0, -1,
		nil, 
		function()
			if reflecting then return false end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_SEGMENTOR", "segmentor", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 0, -1,
		nil, 
		function()
			if reflecting then return false end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_ARCANE_SHOT", "arcane_shot", ACTION_TYPE_PROJECTILE,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 375, 65, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/arcane_shot/projectile.xml" )
			c.fire_rate_wait = c.fire_rate_wait + 30
			current_reload_time = current_reload_time + 90
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_BARRIER_TRAIL", "barrier_trail", ACTION_TYPE_MODIFIER,
		"2,3,4,5", "0.7,0.7,0.7,0.7", 200, 20, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/barrier_trail/wall_builder.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_GLITTERING_TRAIL", "glittering_trail", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7", 120, 10, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/glittering_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FALSE_SPELL", "false_spell", ACTION_TYPE_PROJECTILE,
		"0,1", "0.1,0.1", 90, 1, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.xml" )
		end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/false_spell/projectile.    xml",1}
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MATRA_MAGIC", "matra_magic", ACTION_TYPE_PROJECTILE,
		"3,4,5,6", "1,1,1,1", 180, 26, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/matra_magic/projectile.xml" )
			c.fire_rate_wait = c.fire_rate_wait + 33
			current_reload_time = current_reload_time + 33
		end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/matra_magic/projectile.xml"}
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_CHAOTIC_BURST", "chaotic_burst", ACTION_TYPE_PROJECTILE,
		"3,4,5,6", "1,1,1,1", 260, 42, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" )
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml" )
		end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/chaotic_burst/projectile.xml",5}
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_RED_SPARKBOLT", "red_sparkbolt", ACTION_TYPE_PROJECTILE,
		"0,1,2", "2,1,0.5", 120, 7, -1,
		nil,
		function()
			c.fire_rate_wait = c.fire_rate_wait + 2
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/red_sparkbolt/projectile.xml" )
		end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/red_sparkbolt/projectile.xml",1}
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ZAP", "zap", ACTION_TYPE_PROJECTILE,
		"1,3,4", "1,1,1", 170, 8, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/zap/custom_card.xml",
		function()
			c.fire_rate_wait = c.fire_rate_wait - 5
			current_reload_time = current_reload_time - 5
			
			if reflecting then Reflection_RegisterProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" ) return end

			if GameGetFrameNum() % 3 == 0 then
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
				BeginTriggerDeath()
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
				EndProjectile()
			elseif GameGetFrameNum() % 3 == 1 then
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
				BeginTriggerDeath()
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()

					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					EndProjectile()

					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
				EndProjectile()
			else
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
				BeginTriggerDeath()
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()
				EndTrigger()
				EndProjectile()

				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
				BeginTriggerDeath()
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml" )
						EndProjectile()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
					EndProjectile()
				EndTrigger()
				EndProjectile()
			end
		end, nil, nil, nil,
		{"mods/gkbrkn_noita/files/gkbrkn/actions/zap/projectile.xml",6}
	) )


	table.insert( actions, generate_action_entry(
		"GKBRKN_COPY_SPELL", "copy_spell", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6", "0.8,0.8,0.8,0.8,0.8,0.8,0.8", 300, 20, -1,
		nil,
		function()
			local drawn = false
			for index,action in pairs( deck ) do
				if action.uses_remaining == nil or action.uses_remaining < 0 then
					action.action()
					drawn = true
					break
				end
			end
			if drawn == false then
				draw_actions( 1, true )
			end
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PERFECT_CRITICAL", "perfect_critical", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 300, 20, -1,
		nil,
		function()
			c.damage_critical_multiplier = math.max( 1, c.damage_critical_multiplier ) + 1
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DAMAGE_SMALL", "damage_small", ACTION_TYPE_MODIFIER,
		"0,1,2,3", "1.0,1.0,1.0,1.0", 70, 1, -1,
		nil,
		function()
			local projectile_type_sum = 0
			for k,v in ipairs( deck or {} ) do if v.type == ACTION_TYPE_PROJECTILE or v.type == ACTION_TYPE_STATIC_PROJECTILE or v.type == ACTION_TYPE_MATERIAL then projectile_type_sum = projectile_type_sum + 1 end end
			for k,v in ipairs( hand or {} ) do if v.type == ACTION_TYPE_PROJECTILE or v.type == ACTION_TYPE_STATIC_PROJECTILE or v.type == ACTION_TYPE_MATERIAL then projectile_type_sum = projectile_type_sum + 1 end end
			for k,v in ipairs( discarded or {} ) do if v.type == ACTION_TYPE_PROJECTILE or v.type == ACTION_TYPE_STATIC_PROJECTILE or v.type == ACTION_TYPE_MATERIAL then projectile_type_sum = projectile_type_sum + 1 end end
			c.damage_projectile_add = c.damage_projectile_add + 0.04 + 0.04 * projectile_type_sum
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DAMAGE_BOUNCE", "damage_bounce", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5", "0.6,0.6,0.8,0.6,0.6", 100, 7, -1,
		nil,
		function()
			add_extra_entity_unique( "mods/gkbrkn_noita/files/gkbrkn/actions/damage_bounce/projectile_extra_entity_unique.xml," )
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_bounce/projectile_extra_entity.xml,"
			c.bounces = c.bounces + 3
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DAMAGE_LIFETIME", "damage_lifetime", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5", "0.6,0.6,0.8,0.6,0.6", 130, 9, -1,
		nil,
		function()
			add_extra_entity_unique( "mods/gkbrkn_noita/files/gkbrkn/actions/damage_lifetime/projectile_extra_entity_unique.xml," )
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_lifetime/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DAMAGE_CONVERSION_DRILL", "damage_conversion_drill", ACTION_TYPE_MODIFIER,
		"3,4,5,10", "0.3,0.3,0.6,0.3", 500, 25, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/damage_conversion_drill/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DESTRUCTIVE_SHOT", "destructive_shot", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6", "0.2,0.3,0.4,0.5,0.6", 250, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/destructive_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_PIERCING_SHOT", "piercing_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 9, -1,
		nil,
		function()
			c.damage_projectile_add = c.damage_projectile_add + 0.24
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/piercing_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_POWER_SHOT", "power_shot", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "0.2,0.4,0.6,0.8,1,1,1", 250, 9, -1,
		nil,
		function()
			c.damage_projectile_add = c.damage_projectile_add + 0.24
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/power_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PERFORATING_SHOT", "perforating_shot", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5", "0.7,0.7,0.7,0.7,0.7", 210, 9, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/perforating_shot/projectile_extra_entity.xml,"
			c.gore_particles = c.gore_particles + 20
			c.damage_projectile_add = c.damage_projectile_add + 0.12
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_CHAIN_CAST", "chain_cast", ACTION_TYPE_MODIFIER,
		"0,4,5,6", "0.75,0.6,0.6,0.6", 200, 50, -1,
		nil,
		function()
			c.speed_multiplier = c.speed_multiplier * 0.50
			c.fire_rate_wait = c.fire_rate_wait + 35
			c.spread_degrees = c.spread_degrees + 7
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/projectile_extra_entity.xml,mods/gkbrkn_noita/files/gkbrkn/actions/chain_cast/trail.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DRAW_DECK", "draw_deck", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 280, 30, -1,
		nil,
		function()
			draw_actions( #deck, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_DUPLICAST", "duplicast", ACTION_TYPE_OTHER,
		"4,5,6", "0.8,0.8,0.8", 100, 5, -1,
		nil,
		function()
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 5.00
			current_reload_time = current_reload_time + 30
			c.pattern_degrees = c.pattern_degrees + 180
			gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + 7
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPEED_DOWN", "speed_down", ACTION_TYPE_MODIFIER, 
		"1,2,3,4", "0.8,0.8,0.8,0.8", 50, -3, -1,
		nil,
		function()
			c.speed_multiplier = c.speed_multiplier * 0.40
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FEATHER_SHOT", "feather_shot", ACTION_TYPE_MODIFIER, 
		"1,3,5", "0.3,0.3,0.3", 100, 3, -1,
		nil,
		function()
			c.lifetime_add = c.lifetime_add + 21
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/feather_shot/projectile_extra_entity.xml,"
			current_reload_time = current_reload_time - 6
			draw_actions( 1, true )
		end
	) )

	--table.insert( actions, generate_action_entry(
	--    "GKBRKN_TEST_SHOT", "test_shot", ACTION_TYPE_MODIFIER, 
	--    "0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 100, 1, -1,
	--    nil,
	--    function()
	--        add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/test_shot/projectile.xml" )
	--    end
	--) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FOLLOW_SHOT", "follow_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7,0.7,0.7", 120, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/follow_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_GOLDEN_BLESSING", "golden_blessing", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 1000, 0, 1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/golden_blessing/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	-- This spell ended up being not great, but it is a working example of how to override
	-- the uses_remaining system and run a script one time on kill even if you kill the
	-- enemy in one hit
	-- The limitation being that it only works for things that can apply GameEffect which
	-- may only be projectiles
	-- Alternatively one could attach a script_damage_received to every entity you want
	-- to process which would ensure almost any death
	table.insert( actions, generate_action_entry(
		"GKBRKN_SIPHON", "siphon", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 1000, 0, 10,
		"mods/gkbrkn_noita/files/gkbrkn/actions/siphon/custom_card.xml",
		function()
			if reflecting then return end
			--c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/siphon/projectile_extra_entity.xml,"
			
			local action = hand[1]
			local real_uses = rawget( action, "_uses_remaining" )
			local item = 0
			for _,e in pairs(EntityGetWithTag("gkbrkn_siphon")) do
				local check_item = EntityGetFirstComponentIncludingDisabled(e, "ItemComponent")
				if check_item ~= 0 then
					if ComponentGetValue2(check_item, "mItemUid") == action.inventoryitem_id then
						item = check_item
						real_uses = ComponentGetValue2( item, "uses_remaining" )
					end
				end
			end
			local siphon_charges = tonumber( GlobalsGetValue( "gkbrkn_siphon_charges", "0") )
			local recover = math.min( siphon_charges, 10 - real_uses )
			GlobalsSetValue( "gkbrkn_siphon_charges", tostring(siphon_charges - recover) )
			real_uses = real_uses + recover
			if real_uses > 0 then
				action.uses_remaining = real_uses - 1
				--local reduce_uses = ActionUsesRemainingChanged( action.inventoryitem_id, real_uses - 1 )
				if item ~= 0 then
					ComponentSetValue2( item, "uses_remaining", real_uses - 1 )
				end
			end
			c.game_effect_entities = c.game_effect_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/siphon/projectile_hit_effect.xml,"
			draw_actions( 1, true )
		end, true, nil, nil, nil, true, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ICE_SHOT", "ice_shot", ACTION_TYPE_PROJECTILE,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 175, 25, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/ice_shot/projectile.xml" )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_COAGULATE", "coagulate", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.5,0.4,0.3,0.2,0.1,0.1,0.1", 100, 2, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/coagulate/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRANQUILIZER", "tranquilizer", ACTION_TYPE_MODIFIER,
		"0,1,2", "1.0,0.6,0.5", 100, 2, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/tranquilizer/projectile_extra_entity.xml,"
			-- Works but is not what we want
			--c.game_effect_entities = c.game_effect_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/tranquilizer/game_effect.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MAGIC_HAND", "magic_hand", ACTION_TYPE_PASSIVE,
		"0,1,2", "1.0,0.6,0.5", 100, 2, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/magic_hand/custom_card.xml",
		function()
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_LASER_SIGHT", "laser_sight", ACTION_TYPE_PASSIVE,
		"0,1,2", "1.0,0.6,0.5", 100, 1, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/laser_sight/custom_card.xml",
		function()
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_HIT_MARKER", "hit_marker", ACTION_TYPE_PASSIVE,
		"0,1,2,3,4", "0.5,0.4,0.3,0.2,0.1", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/hit_marker/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MAGIC_LIGHT", "magic_light", ACTION_TYPE_PASSIVE,
		"0,1,2,3,4", "0.5,0.4,0.3,0.2,0.1", 240, 0, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/magic_light/custom_card.xml",
		function()
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ANTI_SHIELD", "anti_shield", ACTION_TYPE_PASSIVE,
		"1,2,3,4,5,6", "0.05,0.6,0.6,0.6,0.6,0.6", 220, 0, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/anti_shield/custom_card.xml",
		function()
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MANA_RECHARGE", "mana_recharge", ACTION_TYPE_PASSIVE,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/mana_recharge/custom_card.xml",
		function()
			draw_actions(1, true)
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MANA_EFFICIENCY", "mana_efficiency", ACTION_TYPE_MODIFIER,
		"3,4,5,6", "0.2,0.2,0.2,0.2", 150, 0, -1,
		nil,
		function()
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 0.50
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FREE_CAST", "free_cast", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5,6", "0.2,0.3,0.4,0.5,0.5,0.5", 480, 0, -1,
		nil,
		function()
			gkbrkn.free_casts = gkbrkn.free_casts + 1
			c.fire_rate_wait = c.fire_rate_wait + 10
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MANA_COPY", "mana_copy", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5,6", "0.2,0.3,0.4,0.5,0.5,0.5", 480, 0, -1,
		nil,
		function()
			gkbrkn.mana_copy = true
			c.fire_rate_wait = c.fire_rate_wait + 20
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MICRO_SHIELD", "micro_shield", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 540, 20, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/micro_shield/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MODIFICATION_FIELD", "modification_field", ACTION_TYPE_STATIC_PROJECTILE,
		"0,1,2,3", "1,1,1,1", 200, 50, 3,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/modification_field/projectile.xml" )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_MULTI_DEATH_TRIGGER", "multi_death_trigger", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 200, 12, -1,
		nil,
		function()
			for i=1,2,1 do
				set_trigger_death( 1 )
			end
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_NGON_SHAPE", "ngon_shape", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.33,0.33,0.33,0.33,0.33,0.33,0.33", 120, 24, -1,
		nil,
		function()
			c.pattern_degrees = 180
			draw_actions( #deck, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_NUGGET_SHOT", "nugget_shot", ACTION_TYPE_PROJECTILE,
		"2,3,4,5", "0.6,0.6,0.6,0.6", 1000, 30, -1,
		nil,
		function()
			local shooter = GetUpdatedEntityID()
			local wallet = EntityGetFirstComponent( shooter, "WalletComponent" )
			if wallet ~= nil then
				local money = ComponentGetValue2( wallet, "money" )
				local cost = 10
				if money >= cost then
					add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/nugget_shot/projectile.xml")
					ComponentSetValue2( wallet, "money", money - cost )
				end
			end
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ORDER_DECK", "order_deck", ACTION_TYPE_PASSIVE,
		"0,1,2,3,4", "1,1,1,1,1", 100, 7, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/order_deck/custom_card.xml",
		function()
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PAPER_SHOT", "paper_shot", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4", "0.5,0.4,0.3,0.2,0.1", 20, -5, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/paper_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FRACTURE", "fracture", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6", "0.7,0.7,0.7,0.7,0.7", 300, 9, -1,
		nil,    
		function()
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			local old_capture = gkbrkn.add_projectile_capture_callback
			local _add_projectile = old_capture or gkbrkn._add_projectile
			gkbrkn.add_projectile_capture_callback = function( filepath )
				BeginProjectile( filepath )
					local action = hand[#hand]
					if mana >= action.mana then
						BeginTriggerDeath()
							for i=1,3 do
								if mana >= action.mana then
									mana = mana - action.mana
									_add_projectile( filepath )
								else
									OnNotEnoughManaForAction()
								end
							end
							push_c(true)
							c.spread_degrees = 45
							c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/fracture/projectile_extra_entity.xml,"
							register_action( c )
							SetProjectileConfigs()
							pop_c()
						EndTrigger()
					end
				EndProjectile()
			end
			draw_actions( 1, true )
			gkbrkn.add_projectile_capture_callback = old_capture
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_BURST_FIRE", "burst_fire", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.9,0.9,0.9,0.9,0.9,0.9,0.9", 300, 25, -1,
		nil,
		function()
			local projectile_path = "mods/gkbrkn_noita/files/gkbrkn/actions/burst_fire/projectile.xml"
			if reflecting then Reflection_RegisterProjectile( projectile_path ) return end
			if gkbrkn.peeking > 0 then draw_actions( 1,true ) return end

			local old_capture = gkbrkn.add_projectile_capture_callback
			local _add_projectile = old_capture or gkbrkn._add_projectile
			gkbrkn.add_projectile_capture_callback = function( filepath )
				local burst_wait = (c.fire_rate_wait + math.ceil( gun.reload_time / 5 )) / 3
				gkbrkn.add_projectile_capture_callback = old_capture
				push_c(true)
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( projectile_path )
							for i=0,2 do
								BeginTriggerTimer( math.max(math.floor((burst_wait * i)+0.5), 1 ) )
									c.spread_degrees = c.spread_degrees + 2
									_add_projectile( filepath )
									register_action( c )
									SetProjectileConfigs()
								EndTrigger()
							end
						EndProjectile()
						
						reset_modifiers( c )
						c.lifetime_add = c.lifetime_add + burst_wait * 3
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
				EndProjectile()
				pop_c()
			end
			draw_actions( 1, true )
			gkbrkn.add_projectile_capture_callback = old_capture
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_EXTRA_PROJECTILE", "extra_projectile", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6", "0.2,0.4,0.6,0.8,1,1,1", 320, 0, -1,
		nil,
		function()
			if reflecting then return false end

			local old_capture = gkbrkn.add_projectile_capture_callback
			local _add_projectile = old_capture or gkbrkn._add_projectile
			if gkbrkn.extra_projectile_depth == 0 then
				gkbrkn.add_projectile_capture_callback = function( filepath )
					_add_projectile( filepath )
					local action = hand[#hand]
					for i=1,gkbrkn.extra_projectile_depth do
						if mana >= action.mana then
							mana = mana - action.mana
							_add_projectile( filepath )
						else
							OnNotEnoughManaForAction()
						end
					end
					c.pattern_degrees = c.pattern_degrees + 2 * gkbrkn.extra_projectile_depth
				end
			end
			gkbrkn.extra_projectile_depth = gkbrkn.extra_projectile_depth + 1
			draw_actions( 1 , true )
			gkbrkn.extra_projectile_depth = 0
			gkbrkn.add_projectile_capture_callback = old_capture
		end
	) )


	table.insert( actions, generate_action_entry(
		"GKBRKN_PROJECTILE_BURST", "projectile_burst", ACTION_TYPE_OTHER,
		"3,4,5,6", "0.2,0.4,0.6,0.8", 480, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_burst/projectile_extra_entity.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 12
			current_reload_time = current_reload_time + 12
			c.spread_degrees = c.spread_degrees + 5
			gkbrkn.extra_projectiles = gkbrkn.extra_projectiles + 4
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PROXIMITY_BURST", "proximity_burst", ACTION_TYPE_MODIFIER,
		"2,3,4,5", "0.2,0.2,0.2,0.2", 300, 70, -1,
		nil,
		function()
			SetRandomSeed( GameGetFrameNum(), 1284 )
			c.explosion_radius = c.explosion_radius + 15.0
			c.damage_explosion_add = c.damage_explosion_add + 0.2
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			
			local old_capture = gkbrkn.add_projectile_capture_callback
			gkbrkn.add_projectile_capture_callback = function( filepath )
				gkbrkn.add_projectile_capture_callback = old_capture
				BeginProjectile( filepath )
					BeginTriggerDeath()
						push_c(true)
						for i=1,Random(3,5) do
							add_projectile( filepath )
						end
						c.spread_degrees = 360
						c.gravity = c.gravity + 1200
						c.bounces = c.bounces + 1
						c.explosion_radius = c.explosion_radius + 10.0
						c.damage_explosion_add = c.damage_explosion_add + 0.1
						c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_burst/projectile_extra_entity.xml,"
						register_action( c )
						SetProjectileConfigs()
						pop_c()
					EndTrigger()
				EndProjectile()
			end
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_RAPID_SHOT", "rapid_shot", ACTION_TYPE_MODIFIER, 
		"1,2,3,4,5,6", "0.7,0.7,0.8,0.9,0.8,0.8", 200, 2, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rapid_shot/projectile_extra_entity.xml,"
			c.spread_degrees = c.spread_degrees + 3
			c.fire_rate_wait = c.fire_rate_wait - 8
			current_reload_time = current_reload_time - 12
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_REDUCE_KNOCKBACK", "reduce_knockback", ACTION_TYPE_MODIFIER, 
		"3,6", "0.6,0.7", 100, 5, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/reduce_knockback/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_REVELATION", "revelation", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/revelation/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SHIMMERING_TREASURE", "shimmering_treasure", ACTION_TYPE_UTILITY,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 2, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/shimmering_treasure/custom_card.xml",
		function()
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SHUFFLE_DECK", "shuffle_deck", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 100, 1, -1,
		nil,
		function()
			local shuffle_deck = {}
			for i=1, #deck do
				local index = Random( 1, #deck )
				local action = deck[ index ]
				table.remove( deck, index )
				table.insert( shuffle_deck, action )
			end
			for index,action in pairs(shuffle_deck) do
				table.insert( deck, action )
			end
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPELL_DUPLICATOR", "spell_duplicator", ACTION_TYPE_STATIC_PROJECTILE,
		"0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 300, 19, -1,
		nil,
		function()
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			
			push_c()
			local copy_deck = peek_draw_actions( 1, true )
			function r( amount )
				if amount <= 0 then return end
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/spell_duplicator/projectile.xml" )
					BeginTriggerDeath()
						push_c()
						c.spread_degrees = c.spread_degrees + 360
						temporary_deck( 
							function( deck, hand, discarded )
								draw_actions( 1, true )
							end,
							deck_from_actions( copy_deck ), {}, {}
						)
						register_action( c )
						SetProjectileConfigs()
						pop_c()
					EndTrigger()

					BeginTriggerDeath()
						r( amount - 1, false )
						peek_c()
						register_action( c )
						SetProjectileConfigs()
					EndTrigger()
				EndProjectile()
			end

			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					r(5)
					peek_c()
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()
			pop_c()
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPELL_EFFICIENCY", "spell_efficiency", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 380, 0, -1,
		nil,
		function()
			--reduce_spell_usage( 0.33 )
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_STICKY_SHOT", "sticky_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 200, 9, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/sticky_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_STORED_SHOT", "stored_shot", ACTION_TYPE_STATIC_PROJECTILE,
		"0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 160, 4, -1,
		nil,
		function()
			add_projectile_trigger_death( "mods/gkbrkn_noita/files/gkbrkn/actions/stored_shot/projectile.xml", 1 )
			current_reload_time = current_reload_time + 3
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SUPER_BOUNCE", "super_bounce", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 90, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/super_bounce/projectile_extra_entity.xml,"
			c.bounces = c.bounces + 2
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TIME_COMPRESSION", "time_compression", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 150, 1, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/time_compression/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TREASURE_SENSE", "treasure_sense", ACTION_TYPE_UTILITY,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 140, 2, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/treasure_sense/custom_card.xml",
		function()
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_DEATH", "trigger_death", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
		nil,
		function()
			set_trigger_death( 1 )
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_HIT", "trigger_hit", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
		nil,
		function()
			set_trigger_hit_world( 1 )
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_TIMER", "trigger_timer", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 250, 10, -1,
		nil,
		function()
			set_trigger_timer( 10, 1 )
			draw_actions( 1, true )
		end, true
	) )

	--[[table.insert( actions, generate_action_entry(
		"GKBRKN_BLUE_PORTAL", "blue_portal", ACTION_TYPE_OTHER,
		"4,5,6,10", "0.1,0.1,0.1,0.1", 400, 0, -1,
		nil,
		function()
			local entity_id = GetUpdatedEntityID()
			local x, y = EntityGetTransform( entity_id )
			local orange_portals = {}
			
			
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_ORANGE_PORTAL", "orange_portal", ACTION_TYPE_OTHER,
		"4,5,6,10", "0.1,0.1,0.1,0.1", 400, 0, -1,
		nil,
		function()
			draw_action( 1, true )
		end
	))]]

	local gkbrkn_stack_action = function()
		if reflecting then return false end

		-- TODO this fails if this action is called directly
		-- TODO this fails if play_action is called on this action
		-- Probably would have to use metatables to ensure we can find specifically this no matter where it's called
		local action = hand[#hand]
		-- TEMP this should mitigate issues with the above until I implement a solution
		if action.id ~= "GKBRKN_STACK" and action.id ~= "GKBRKN_STACK_EMPTY" then return end
		local action_entity = find_action_entity(action)
		if not action_entity then return end

		-- TODO change from children to variables since we only need ID
		local children = EntityGetAllChildren(action_entity) or {}
		local should_update = false

		-- TODO fold this logic into one while loop
		if #children == 0 then
			if #deck <= 0 then return end
			local next_action_entity = find_action_entity(deck[1])
			if next_action_entity then
				local item = EntityGetFirstComponentIncludingDisabled( next_action_entity, "ItemComponent" )
				if item then
					if ComponentGetValue2( item, "uses_remaining" ) < 0 then
						EntityRemoveFromParent(next_action_entity)
						EntityAddChild(action_entity, next_action_entity)
						table.remove( deck, 1 )
						children = EntityGetAllChildren(action_entity) or {}
						should_update = true
					end
				end
			end
		end
		if #children == 0 then return end

		local item_action = EntityGetFirstComponentIncludingDisabled( children[1], "ItemActionComponent" )
		if not item_action then return end

		local set_action_id = ComponentGetValue2( item_action, "action_id" )
		if not set_action_id then return end

		-- TODO don't go through every action to find the data every time
		local action_table = find_action_by_id(set_action_id)
		if not action_table then return end

		while #deck > 0 and deck[1].id == set_action_id do
			local next_action_entity = find_action_entity(deck[1])
			if next_action_entity then
				EntityRemoveFromParent(next_action_entity)
				EntityAddChild(action_entity, next_action_entity)
				table.remove( deck, 1 )
				children = EntityGetAllChildren(action_entity) or {}
				should_update = true
			end
		end
		
		if should_update then
			local batch_item_action = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemActionComponent" )
			if batch_item_action then
				ComponentSetValue2( batch_item_action, "action_id", "GKBRKN_STACK" )
			end
			local item = EntityGetFirstComponentIncludingDisabled( action_entity, "ItemComponent" )
			if item then
				ComponentSetValue2( item, "uses_remaining", #children )
				local s = GameTextGetTranslatedOrNot("$action_name_gkbrkn_stack")
				local as = GameTextGetTranslatedOrNot( action_table.name )
				ComponentSetValue2( item, "item_name", s..as )
				ComponentSetValue2( item, "always_use_item_name_in_ui", true )
				ComponentSetValue2( item, "ui_sprite", action_table.sprite )
			end
		end

		if #set_action_id <= 0 then return end

		local _dont_draw_actions = dont_draw_actions
		dont_draw_actions = true
		children = EntityGetAllChildren(action_entity) or {}
		for i=1,#children-1 do
			if mana >= action_table.mana * 2 then
				action_table.action()
				mana = mana - action_table.mana
			else
				OnNotEnoughManaForAction()
				break
			end
		end
		dont_draw_actions = _dont_draw_actions

		if mana >= action_table.mana then
			action_table.action()
			mana = mana - action_table.mana
		else
			OnNotEnoughManaForAction()
		end
	end
	
	-- NOTE there's no reason apart from balance that this couldn't be extended to support arbitrary
	-- spell batching
	table.insert( actions, generate_action_entry(
		"GKBRKN_STACK_EMPTY", "stack_empty", ACTION_TYPE_UTILITY,
		"1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.5", 500, 0, -1,
		nil, gkbrkn_stack_action, nil, nil, nil, nil, true, true
	))
	-- NOTE using two actions just to change description is pretty crappy...not worth it?
	table.insert( actions, generate_action_entry(
		"GKBRKN_STACK", "stack", ACTION_TYPE_UTILITY,
		"0", "0", 0, 0, -1,
		nil, gkbrkn_stack_action, nil, nil, nil, nil, true, true
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_MIMICRY", "mimicry", ACTION_TYPE_OTHER,
		"4,5,6,10", "0.1,0.1,0.1,0.3", 400, 0, -1,
		nil,
		function()
			if reflecting then return false end
			local mockery = false
			local mock = nil

			-- If we have more of the deck left search for the next non mimicry action
			-- But if we run out of deck and still don't have a mock, check the discard pile instead
			if #hand > 0 then
				local i = #hand
				mock = hand[i]
				while mock and mock.id == "GKBRKN_MIMICRY" do
					i = i - 1
					mock = hand[i]
				end
			end

			if not mock and #discarded > 0 then
				local i = #discarded
				mock = discarded[i]
				while mock and mock.id == "GKBRKN_MIMICRY" do
					i = i - 1
					mock = discarded[i]
				end
			end

			if mock ~= nil then
				local mana_req = mock.mana
				if mock.mana == nil then
					mana_req = ACTION_MANA_DRAIN_DEFAULT
				end
				if mana_req <= mana then
					if mock.uses_remaining ~= 0 then
						mockery = true
						mana = mana - mana_req
						local _deck = deck
						local _hand = hand
						local _discarded = discarded

						local hand_index = #hand
						-- We secret play here to avoid the mimicked spell showing up on the spell board
						--secret_play_action( mock )
						play_action( mock )
						-- Create a temporary hand of only the card we mocked to ensure not only it gets used
						-- but also any mods that tamper with this function still call what they want to call on the action
						-- This does however skirt Wand Refreshes breaking of this mechanic
						hand = {mock}
						discarded = {}
						move_hand_to_discarded()
						hand = _hand
						discarded = _discarded
						table.remove( hand, hand_index + 1 )
					end
				else
					OnNotEnoughManaForAction()
				end
			end

			if not mockery then
				OnActionPlayed("GKBRKN_MIMICRY")
				draw_action(1)
			end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_DOUBLE_CAST", "double_cast", ACTION_TYPE_UTILITY,
		"2,3,4,10", "0.7,0.7,0.7,0.3", 400, 0, -1,
		nil,
		function()
			if reflecting then return false end
			duplicate_draw_action( 1, 2, true )
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIPLE_CAST", "triple_cast", ACTION_TYPE_UTILITY,
		"3,4,5,10", "0.5,0.5,0.5,0.3", 500, 0, -1,
		nil,
		function()
			if reflecting then return false end
			duplicate_draw_action( 1, 3, true )
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_SECRET_SHOT", "secret_shot", ACTION_TYPE_UTILITY, 
		"0,1,2,3,4,5,6,10", "0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/secret_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	-- The reason we can't just stack TimerTriggers is because they also cast on expiration, so if we were to set up
	-- 10 timers for example, a projetile that expires immediately would still cast all 10 of them

	-- This works by releasing an invisible trigger hit projectile that parents to the projectile we cast
	-- On command we force the invisible trigger to "hit" something which causes the trigger to activate
	-- Because trigger hit does not expire after triggering we can freely trigger it whenever we want
	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_REPEAT", "trigger_repeat", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 500, 70, -1,
		nil,
		function()
			c.fire_rate_wait = c.fire_rate_wait + 22
			current_reload_time = current_reload_time + 22

			-- Don't crash the game during reflection
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end

			-- For tracking projectile capture groups so we don't attach to the wrong spell
			local trigger_repeat_group = tonumber( GlobalsGetValue("gkbrkn_trigger_repeat_index","0") )
			GlobalsSetValue("gkbrkn_trigger_repeat_index", tostring( trigger_repeat_group + 1 ) )
			trigger_repeat_group = "trigger_repeat_"..trigger_repeat_group

			-- Shoot a dummy projectile that will die immediately
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					-- Reset cast state for the initial trigger so mods before the trigger repeat
					-- don't affect the block
					reset_modifiers(c)
					draw_actions( 1, true )
					-- Add information about which group the main projectile belongs to
					c.action_unidentified_sprite_filename = c.action_unidentified_sprite_filename..trigger_repeat_group..","
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()

			-- Shoot a dummy projectile that will die immediately
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					-- This projectile is an invisible projectile that has its collide_with_tag value
					-- set on an interval to retrigger the hit world trigger below
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_repeat/projectile.xml" )
						-- This block will be the block that gets repeated on an interval
						BeginTriggerHitWorld()
							-- Reset cast state for the on command trigger so mods
							-- that affect the main projectile don't affect
							-- the repeating projectile
							reset_modifiers(c)
							draw_actions( 1, true )
							register_action( c )
							SetProjectileConfigs()
						EndTrigger()
					EndProjectile()
					
					-- Reset cast state so modifiers applied to the repeating projectile
					-- don't affect the invisible projectile
					reset_modifiers(c)
					-- Add information about which group the invisible projectile belongs to
					c.action_unidentified_sprite_filename = c.action_unidentified_sprite_filename..trigger_repeat_group..","
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_BOUNCE", "trigger_bounce", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 370, 50, -1,
		nil,
		function()
			-- Don't crash the game during reflection
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end

			-- For tracking projectile capture groups so we don't attach to the wrong spell
			local trigger_bounce_group = tonumber( GlobalsGetValue("gkbrkn_trigger_bounce_index","0") )
			GlobalsSetValue("gkbrkn_trigger_bounce_index", tostring( trigger_bounce_group + 1 ) )
			trigger_bounce_group = "trigger_bounce_"..trigger_bounce_group

			-- Shoot a dummy projectile that will die immediately
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					-- Reset cast state for the initial trigger so mods before the trigger bounce
					-- don't affect the block
					reset_modifiers(c)
					draw_actions( 1, true )
					c.action_unidentified_sprite_filename = c.action_unidentified_sprite_filename..trigger_bounce_group..","
					c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/trigger_bounce/bounce_fx_extra_entity.xml,"
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()

			-- Shoot a dummy projectile that will die immediately
			BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
				BeginTriggerDeath()
					-- This projectile is an invisible projectile that collides with gkbrkn_trigger_bounce
					BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_bounce/projectile.xml" )
						-- This block will be the block that gets triggered every bounce
						BeginTriggerHitWorld()
							-- Reset cast state for the on command trigger so mods
							-- that affect the main projectile don't affect
							-- the on bounce projectile
							reset_modifiers(c)
							draw_actions( 1, true )
							register_action( c )
							SetProjectileConfigs()
						EndTrigger()
					EndProjectile()
					
					-- Reset cast state so modifiers applied to the bounce trigger projectile
					-- don't affect the invisible projectile
					reset_modifiers(c)
					-- Add information about which group the invisible projectile belongs to
					c.action_unidentified_sprite_filename = c.action_unidentified_sprite_filename..trigger_bounce_group..","
					register_action( c )
					SetProjectileConfigs()
				EndTrigger()
			EndProjectile()
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TRIGGER_TAKE_DAMAGE", "trigger_take_damage", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 370, 50, -1,
		nil,
		function()
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			local take_damage_triggers = EntityGetWithTag("gkbrkn_trigger_take_damage_projectile") or {}
			for _,trigger in pairs(take_damage_triggers) do
				EntityKill(trigger)
			end
			add_projectile_trigger_hit_world( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_take_damage/projectile.xml", 1 )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_AREA_SHOT", "area_shot", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6", "0.2,0.3,0.6,0.7,0.4", 150, 8, -1,
		nil,
		function()
			add_extra_entity_unique("mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity_unique.xml,")
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/area_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PROXIMITY_FIELD", "proximity_field", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5,6", "0.5,0.5,0.5,0.4,0.3,0.2", 90, 3, -1,
		nil,
		function()
			--c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_field/projectile_extra_entity.xml,"
			--draw_actions( 1, true )
			if reflecting then Reflection_RegisterProjectile( "data/entities/base_projectile.xml" ) return end
			local old_capture = gkbrkn.add_projectile_capture_callback
			gkbrkn.add_projectile_capture_callback = function( filepath )
				gkbrkn.add_projectile_capture_callback = old_capture
				BeginProjectile( "mods/gkbrkn_noita/files/gkbrkn/actions/trigger_projectile.xml" )
					BeginTriggerDeath()
						BeginProjectile( filepath )
							BeginTriggerDeath()
								push_c(true)
								draw_actions( 1, true )
								register_action( c )
								SetProjectileConfigs()
								pop_c()
							EndTrigger()
						EndProjectile()
					c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/proximity_field/projectile_extra_entity.xml,"
					register_action( c )
					SetProjectileConfigs()
					EndTrigger()
				EndProjectile()
			end
			push_c()
			draw_actions( 1, true )
			pop_c()
			gkbrkn.add_projectile_capture_callback = old_capture
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_HYPER_BOUNCE", "hyper_bounce", ACTION_TYPE_MODIFIER, 
		"2,3,4", "0.8,0.8,0.8", 500, 10, -1,
		nil,
		function()
			c.bounces = c.bounces + 100
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/hyper_bounce/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_COLLISION_DETECTION", "collision_detection", ACTION_TYPE_MODIFIER,
		"2,4,6", "0.5,0.4,0.4", 50, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/collision_detection/projectile_extra_entity.xml,"
			--c.speed_multiplier = c.speed_multiplier * 0.85
			--c.bounces = math.max( 1, c.bounces )
			draw_actions( 1, true )
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPECTRAL_SHOT", "spectral_shot", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "1,1,1,1,1,1,1", 1020, 35, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spectral_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_BURROW_SHOT", "burrow_shot", ACTION_TYPE_MODIFIER, 
		"2,3,4,5,6", "0.2,0.3,0.6,0.4,0.6", 200, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/burrow_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_NO_FRICTION", "no_friction", ACTION_TYPE_MODIFIER, 
		"1,3,5", "0.3,0.3,0.3", 100, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/no_friction/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ZERO_GRAVITY", "zero_gravity", ACTION_TYPE_MODIFIER, 
		"2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5", 100, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/zero_gravity/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PATH_CORRECTION", "path_correction", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 250, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/path_correction/projectile_extra_entity.xml,"
			c.speed_multiplier = c.speed_multiplier * 0.75
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SEEKER_SHOT", "seeker_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.1,0.2,0.3,0.4,0.5,0.4,0.3", 280, 20, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/seeker_shot/projectile_extra_entity.xml,"
			c.speed_multiplier = c.speed_multiplier * 0.65
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_INNER_HOMING", "inner_homing", ACTION_TYPE_MODIFIER,
		"1,2,3,4,5,6", "0.1,0.4,0.4,0.4,0.4,0.4", 240, 35, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/inner_homing/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FAMILIAR_SHOT", "familiar_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 100, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/familiar_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_CURIOUS_SHOT", "curious_shot", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.3,0.3,0.3,0.3,0.3,0.3,0.3", 130, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/curious_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_GUIDED_SHOT", "guided_shot", ACTION_TYPE_MODIFIER,
		"1,2,3", "0.4,0.4,0.4", 160, 8, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/guided_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PERSISTENT_SHOT", "persistent_shot", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4", "0.4,0.4,0.4,0.4,0.4", 160, 9, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/persistent_shot/projectile_extra_entity.xml,"
			draw_actions( 2, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_ANCHORED_SHOT", "anchored_shot", ACTION_TYPE_MODIFIER,
		"0,1,2", "0.2,0.2,0.2", 150, 6, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/anchored_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

--[[ CAPTURES ]]
	table.insert( actions, generate_action_entry(
		"GKBRKN_FORMATION_STACK", "formation_stack", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 5, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_stack/separator.xml", true) end
			draw_actions( 3, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_FORMATION_SHIELD", "formation_shield", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 50, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_shield/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_shield/separator.xml", true) end
			c.speed_multiplier = 0.0
			c.lifetime_add = c.lifetime_add + 60
			draw_actions( 4, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_FORMATION_SWORD", "formation_sword", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.4,0.4,0.4,0.4,0.4,0.4,0.4", 160, 7, -1,
		"mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/custom_card.xml",
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/formation_sword/separator.xml", true) end
			draw_actions( 5, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_LINK_SHOT", "link_shot", ACTION_TYPE_MODIFIER, 
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 190, 7, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/link_shot/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/link_shot/separator.xml", true) end
			draw_actions( 2, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPELL_MERGE", "spell_merge", ACTION_TYPE_DRAW_MANY, 
		"0,1,2,3,4,5,6", "0.6,0.6,0.6,0.6,0.6,0.6,0.6", 190, 6, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/spell_merge/separator.xml", true) end
			draw_actions( 2, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PROJECTILE_GRAVITY_WELL", "projectile_gravity_well", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 210, 5, -1,
		nil,
		function()
			c.speed_multiplier = c.speed_multiplier * 0.75
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/projectile_gravity_well/separator.xml", true) end
			draw_actions( 3, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PROJECTILE_ORBIT", "projectile_orbit", ACTION_TYPE_DRAW_MANY,
		"0,1,2,3,4,5,6", "0.1,0.1,0.1,0.1,0.1,0.1,0.1", 100, 12, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/projectile_orbit/separator.xml", true) end
			draw_actions( 5, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	) )

--[[ MAGICS ]]
	table.insert( actions, generate_action_entry(
		"GKBRKN_TRAILING_SHOT", "trailing_shot", ACTION_TYPE_DRAW_MANY, 
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 5, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/trailing_shot/projectile_extra_entity.xml,"
			if not reflecting then add_projectile("mods/gkbrkn_noita/files/gkbrkn/actions/trailing_shot/separator.xml", true) end
			draw_actions( 4, true )
			if not reflecting then gkbrkn.do_projectile_capture = gkbrkn.do_projectile_capture + 1 end
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_RED_MAGIC", "red_magic", ACTION_TYPE_MODIFIER,
		"2,3,4,5", "0.2,0.3,0.4,0.4", 370, 27, -1,
		nil,
		function()
			if reflecting then return end
			c.damage_projectile_add = c.damage_projectile_add + tonumber(EntityGetVariableNumber( GetUpdatedEntityID(), "gkbrkn_red_magic_damage", damage ))
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/red_magic/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_GREEN_MAGIC", "green_magic", ACTION_TYPE_MODIFIER,
		"2,3,4,5", "0.2,0.3,0.4,0.4", 370, 27, -1,
		nil,
		function()
			if reflecting then return end
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/green_magic/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )
	

	table.insert( actions, generate_action_entry(
		"GKBRKN_BLUE_MAGIC", "blue_magic", ACTION_TYPE_PROJECTILE,
		"0,1,2,3,4,5", "0.5,0.4,0.3,0.2,0.2,0.2", 90, 11, -1,
		nil,
		function()
			c.fire_rate_wait = c.fire_rate_wait + 10
			current_reload_time = current_reload_time + 6
			if reflecting then return end
			
			local player = EntityGetWithTag( "player_unit" )[1]
			local projectile_file = EntityGetVariableString( player, "gkbrkn_blue_magic_projectile_file" )
			if projectile_file ~= nil and #projectile_file > 0 then
				c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/blue_magic/projectile_extra_entity.xml,"
				add_projectile( projectile_file )
			end
		end
	) )

--[[ SUPERS ]]
	table.insert( actions, generate_action_entry(
		"GKBRKN_CARRY_SHOT", "carry_shot", ACTION_TYPE_UTILITY,
		"2,3,4,5", "1,1,1,1", 160, 4, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/carry_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )
	
	table.insert( actions, generate_action_entry(
		"GKBRKN_CONTROL", "control", ACTION_TYPE_MODIFIER, 
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 300, 3, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/control/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_CLINGING_SHOT", "clinging_shot", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 150, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/clinging_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FOCUSED_SHOT", "focused_shot", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 500, 20, -1,
		nil,
		function()
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3.0
			c.damage_projectile_add = c.damage_projectile_add + 0.08
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/focused_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier / 3.0
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_TIME_SPLIT", "time_split", ACTION_TYPE_MODIFIER, 
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 140, 4, -1,
		nil,
		function()
			local sum = (c.fire_rate_wait + current_reload_time) * 0.5
			c.fire_rate_wait = c.fire_rate_wait / 3
			current_reload_time = current_reload_time / 3
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3
			draw_actions( 1, true )
		end, true
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_BOUND_SHOT", "bound_shot", ACTION_TYPE_MODIFIER,
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 150, 30, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/bound_shot/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_PROTECTIVE_ENCHANTMENT", "protective_enchantment", ACTION_TYPE_UTILITY,
		"2,3,4,5,6,10", "0.12,0.12,0.12,0.24,0.24,0.36", 200, 0, -1,
		nil,
		function()
			gkbrkn.mana_multiplier = gkbrkn.mana_multiplier * 3
			c.fire_rate_wait = c.fire_rate_wait + 17
			current_reload_time = current_reload_time + 17
			c.extra_entities = c.extra_entities.."mods/gkbrkn_noita/files/gkbrkn/actions/protective_enchantment/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end
	) )

--[[ EXTRA THINGS ]]
	table.insert( actions, generate_action_entry(
		"GKBRKN_FREEZING_MIST", "freezing_mist", ACTION_TYPE_PROJECTILE,
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 600, 200, -1,
		nil,
		function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/actions/freezing_mist/projectile.xml" )
		end,
		-- deprecated, icon_path, author, related_projectiles, never_unlimited, custom_uses_logic, default )
		false,
		nil,
		"goki_dev_extra",
		{"mods/gkbrkn_noita/files/gkbrkn/actions/freezing_mist/projectile.xml",1},
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_FREEZING_VAPOUR_TRAIL", "freezing_vapour_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 300, 13, -1,
		nil,
		function()
			c.trail_material = c.trail_material .. "blood_cold,"
			c.trail_material_amount = c.trail_material_amount + 5
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_RAINBOW_GLITTER_TRAIL", "rainbow_glitter_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_glitter_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_HONK", "honk", ACTION_TYPE_OTHER,
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 10, 0, -1,
		nil,
		function()
			if not reflecting then
				local entity = GetUpdatedEntityID()
				local x,y = EntityGetTransform( entity )
				GamePlaySound( "mods/gkbrkn_noita/files/gkbrkn_extras.snd", "lily_honk"..math.ceil( math.random() * 3 + 1 ), x, y )
			end
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	))

	table.insert( actions, generate_action_entry(
		"GKBRKN_LOVELY_TRAIL", "lovely_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/lovely_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_NULL_TRAIL", "null_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/null_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_POP_TRAIL", "pop_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/pop_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_RAINBOW_PROJECTILE", "rainbow_projectile", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_projectile/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_RAINBOW_TRAIL", "rainbow_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/rainbow_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_SPARKLING_TRAIL", "sparkling_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/sparkling_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_STARRY_TRAIL", "starry_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.2,0.2,0.2,0.2,0.2,0.2,0.2", 10, 0, -1,
		nil,
		function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/actions/starry_trail/projectile_extra_entity.xml,"
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	) )

	table.insert( actions, generate_action_entry(
		"GKBRKN_VOID_TRAIL", "void_trail", ACTION_TYPE_MODIFIER,
		"0,1,2,3,4,5,6", "0.5,0.5,0.5,0.5,0.5,0.5,0.5", 200, 6, -1,
		nil,
		function()
			c.trail_material = c.trail_material .. "void_liquid,"
			c.trail_material_amount = c.trail_material_amount + 1
			draw_actions( 1, true )
		end,
		false,
		nil,
		"goki_dev_extra",
		nil,
		nil,
		nil,
		false
	))