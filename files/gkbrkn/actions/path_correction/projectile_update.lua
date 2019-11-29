local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local correction_distance = 36;

dofile_once( "files/gkbrkn/lib/variables.lua" );

--[[
for word in string.gmatch(str, '([^,]+)') do
end
]]

-- relatively performance impacting
function is_in_line_of_sight( x, y, tx, ty )
    return true;
    --[[
    local hit,hit_x,hit_y = Raytrace( x, y, tx, ty );
    local in_line_of_sight = false;
    if hit == false then
        in_line_of_sight = true;
    else
        local distance_to_hit = math.sqrt( (hit_x - x) ^2 + (hit_y - y) ^ 2 );
        local distance_to_target = math.sqrt( (tx - x) ^2 + (ty - y) ^ 2 );
        if distance_to_hit > distance_to_target then
            in_line_of_sight = true;
        end
    end
    return in_line_of_sight;
    ]]
end

function ease_angle( angle, target_angle, easing )
    local dir = (angle - target_angle) / (math.pi*2);
    dir = dir - math.floor(dir + 0.5);
    dir = dir * (math.pi*2);
    return angle - dir * easing;
end

local nearby_entities = EntityGetInRadiusWithTag( x, y, correction_distance, "homing_target" ) or {};
local target = nearby_entities[ math.ceil( math.random() * #nearby_entities ) ];
if target ~= nil then
    local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
    local shooter = ComponentGetValue( projectile, "mWhoShot" );
    local shooter_genome = EntityGetFirstComponent( shooter, "GenomeDataComponent" );
    local shooter_herd = -1;
    if shooter_genome ~= nil then
        shooter_herd = ComponentGetMetaCustom( shooter_genome, "herd_id" );
    end
    local target_genome = EntityGetFirstComponent( target, "GenomeDataComponent" );
    local target_herd = -1;
    if target_genome ~= nil then
        traget_herd = ComponentGetMetaCustom( target_genome, "herd_id" );
    end
    if tonumber(target) ~= tonumber(shooter) and target_herd ~= shooter_herd then
        local damaged_entities = {};
        local damaged_entities_string = EntityGetVariableString( entity, "gkbrkn_damaged_entities","" );
        for word in string.gmatch( damaged_entities_string, '([^,]+)' ) do
            damaged_entities[tostring(word)] = true;
        end
        --[[ TODO when someone figures this out, fix this
        if GameGetFrameNum() % 60 == 0 then
            for _,c_type in pairs( {
                "int","string","float"
                --"unsigned int","uint","unsigned","unsigned short","unsigned short int"
            })do
                local damaged_entities = ComponentGetVector( projectile, "mDamagedEntities", c_type );
                --GamePrint( type.." was there" );
            end
        end
        ]]
        if damaged_entities[tostring(entity)] ~= true then
            local tx, ty = EntityGetTransform( target );
            local hitbox = EntityGetFirstComponent( target, "HitboxComponent" );
            if hitbox ~= nil then
                local height = tonumber( ComponentGetValue( hitbox, "aabb_max_y" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_y" ) )
                ty = ty - height * 0.5;
            end
            local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
            local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( vy, vx );
            local target_angle = math.atan2( ty - y, tx - x );
            local magnitude = math.sqrt( vx * vx + vy * vy );
            local distance = math.sqrt( math.pow( tx - x, 2 ) + math.pow( ty - y, 2 )  );
            local new_angle = ease_angle( angle, target_angle, 1.0 );
            if distance <= 12 then
                EntitySetVariableString( entity, "gkbrkn_damaged_entities",damaged_entities_string..entity.."," )
            end
            ComponentSetValueVector2( velocity, "mVelocity", math.cos( new_angle ) * magnitude, math.sin( new_angle ) * magnitude );
        end
    end
end

