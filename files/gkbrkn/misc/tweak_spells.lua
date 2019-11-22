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
            c.fire_rate_wait = math.min( c.fire_rate_wait, 1 );
        end
    end,
}
for i=#actions,1,-1 do
    local action = actions[i];
    if action ~= nil and edit_callbacks[ action.id ] ~= nil then
        edit_callbacks[action.id]( action, i );
    end
end