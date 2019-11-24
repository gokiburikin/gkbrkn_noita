local entity_id = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity_id );

local projectiles = EntityGetWithTag( "projectile" );

if #projectiles > 0 then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id );
		
		local distance = math.abs( x - px ) + math.abs( y - py );
		local distance_full = 36;
		
		if distance < distance_full * 1.25 then
			distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 );
			direction = 0 - math.atan2( ( y - py ), ( x - px ) );
	
			if distance < distance_full then
				local velocity_component = EntityGetFirstComponent( projectile_id, "VelocityComponent" );
				
				local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.2 );
				local gravity_coeff = -128;
				
                if velocity_component ~= nil then
                    local vx,vy = ComponentGetValueVector2( velocity_component, "mVelocity" );
						
                    local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent );
                    local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent );

                    vx = vx + offset_x;
                    vy = vy + offset_y;

                    ComponentSetValueVector2( velocity_component, "mVelocity", vx, vy );
				end
			end
		end
	end
end