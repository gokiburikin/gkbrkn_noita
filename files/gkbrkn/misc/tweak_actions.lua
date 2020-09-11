dofile( "mods/gkbrkn_noita/files/gkbrkn/content/tweaks.lua");

local edit_callbacks = {
    MANA_REDUCE = function( action, index )
        table.remove( actions, index );
    end,
    HEAVY_SHOT = function( action, index )
        action.mana = 35;
        action.action = function()
            c.damage_projectile_add = c.damage_projectile_add + 0.8
            c.damage_critical_chance = c.damage_critical_chance + 24
			c.fire_rate_wait    = c.fire_rate_wait + 30
			current_reload_time    = current_reload_time + 20
			c.gore_particles    = c.gore_particles + 10
			c.speed_multiplier = c.speed_multiplier * 0.3
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 50.0
			c.extra_entities = c.extra_entities .. "data/entities/particles/heavy_shot.xml,"
			draw_actions( 1, true );
        end
    end,
    DAMAGE = function( action, index )
        action.mana = 20;
        action.action = function()
			c.damage_projectile_add = c.damage_projectile_add + 0.4
			c.gore_particles    = c.gore_particles + 5
			c.fire_rate_wait    = c.fire_rate_wait + 10
			current_reload_time    = current_reload_time + 15
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_yellow.xml,"
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 10.0
			draw_actions( 1, true );
        end
    end,
    CHAINSAW = function( action, index )
        action.mana = 3;
        action.action = function()
            add_projectile("data/entities/projectiles/deck/chainsaw.xml");
			c.fire_rate_wait = math.min( c.fire_rate_wait, 5 );
			c.spread_degrees = c.spread_degrees + 3.0;
			current_reload_time = current_reload_time - ACTION_DRAW_RELOAD_TIME_INCREASE - 10;
        end
    end,
    FREEZE = function( action, index)
        action.action = function()
            c.damage_projectile_add = c.damage_projectile_add + 0.2;
            c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_frozen.xml,";
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/freeze_charge.xml,"
            draw_actions( 1, true );
        end
    end,
    AREA_DAMAGE = function( action, index )
        action.action = function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/area_damage.xml,";
			draw_actions( 1, true );
		end
    end,
    CHAIN_BOLT = function( action, index )
        action.action 		= function()
			add_projectile("mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/chain_bolt.xml");
			c.spread_degrees = c.spread_degrees + 7.0;
			c.fire_rate_wait = c.fire_rate_wait + 45;
		end
    end,
    THUNDER_BLAST = function( action, index )
        action.action 		= function()
			add_projectile("mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/thunder_blast.xml");
			c.fire_rate_wait = c.fire_rate_wait + 15
			c.screenshake = c.screenshake + 3.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 30.0
		end
    end,
    X_RAY = function( action, index )
        action.action = function()
			add_projectile("mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/xray.xml");
		end
    end,
    SPIRAL_SHOT = function ( action, index )
        action.action = function()
			add_projectile( "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/spiral_shot/spiral_shot.xml" );
			c.fire_rate_wait = c.fire_rate_wait + 20;
		end
    end,
    TELEPORT_CAST = function ( action, index )
        action.action = function()
			add_projectile_trigger_death( "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/teleport_cast.xml", 1 );
			c.fire_rate_wait = c.fire_rate_wait + 20;
			c.spread_degrees = c.spread_degrees + 12;
		end
    end,
    PIERCING_SHOT = function ( action, index )
        action.action = function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/piercing_shot.xml,"
			draw_actions( 1, true );
		end
    end,
    CLIPPING_SHOT = function ( action, index )
        action.action = function()
			c.extra_entities = c.extra_entities .. "mods/gkbrkn_noita/files/gkbrkn/tweaks/actions/clipping_shot.xml,"
            c.fire_rate_wait = c.fire_rate_wait + 50;
			current_reload_time = current_reload_time + 40;
			draw_actions( 1, true );
		end
    end
}

local apply_tweaks = {};
for _,tweak in pairs( tweaks ) do
    if tweak.options and tweak.options.action_id then
        apply_tweaks[ tweak.options.action_id ] = true
    end
end

for i=#actions,1,-1 do
    local action = actions[i];
    if action ~= nil then
        if edit_callbacks[ action.id ] ~= nil and apply_tweaks[ action.id ] == true then
            edit_callbacks[action.id]( action, i );
        end
    end
end