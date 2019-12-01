dofile_once( "files/gkbrkn/config.lua");

local edit_callbacks = {
    MANA_REDUCE = function( action, index )
        table.remove( actions, index );
    end,
    HEAVY_SHOT = function( action, index )
        action.mana = 35;
        action.action = function()
            c.damage_projectile_add = c.damage_projectile_add + 0.8
            c.damage_critical_chance = c.damage_critical_chance + 0.24
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
            draw_actions( 1, true );
        end
    end,
    AREA_DAMAGE = function( action, index )
        action.action = function()
			c.extra_entities = c.extra_entities .. "files/gkbrkn/tweaks/actions/area_damage.xml,";
			draw_actions( 1, true );
		end
    end
}

local apply_tweaks = {};
for _,content_id in pairs(TWEAKS) do
    local tweak = CONTENT[content_id];
    if tweak.enabled() and tweak.options ~= nil and tweak.options.action_id ~= nil then
        apply_tweaks[ tweak.options.action_id ] = true
    end
end

for i=#actions,1,-1 do
    local action = actions[i];
    if action ~= nil and edit_callbacks[ action.id ] ~= nil and apply_tweaks[ action.id ] == true then
        edit_callbacks[action.id]( action, i );
    end
end