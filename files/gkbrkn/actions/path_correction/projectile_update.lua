local entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( entity );
local correction_distance = 36;

dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

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
        target_herd = ComponentGetMetaCustom( target_genome, "herd_id" );
    end
    if tonumber(target) ~= tonumber(shooter) and target_herd ~= shooter_herd then
        local damaged_entities = {};
        local damaged_entities_string = EntityGetVariableString( entity, "gkbrkn_damaged_entities","" );
        for word in string.gmatch( damaged_entities_string, '([^,]+)' ) do
            damaged_entities[tostring(word)] = true;
        end
        --[[ TODO fix this when someone figures this out
        if GameGetFrameNum() % 60 == 0 then
            for _,c_type in pairs( {
                "int","string","float"
                --"unsigned int","uint","unsigned","unsigned short","unsigned short int"
            })do
                local damaged_entities = ComponentGetVector( projectile, "mDamagedEntities", c_type );
            end
        end
        ]]
        if damaged_entities[tostring(entity)] ~= true then
            local tx, ty = EntityGetFirstHitboxCenter( target );
            if tx == nil or ty == nil then
                EntityGetTransform( target );
            end
            local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
            local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
            local angle = math.atan2( vy, vx );
            local target_angle = math.atan2( ty - y, tx - x );
            local magnitude = math.sqrt( vx * vx + vy * vy );
            local distance = math.sqrt( math.pow( tx - x, 2 ) + math.pow( ty - y, 2 )  );
            if distance <= 12 then
                EntitySetVariableString( entity, "gkbrkn_damaged_entities",damaged_entities_string..entity.."," )
            end
            ComponentSetValueVector2( velocity, "mVelocity", math.cos( target_angle ) * magnitude, math.sin( target_angle ) * magnitude );
        end
    end
end

