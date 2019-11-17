local game_frame = GameGetFrameNum();
if PerkLostTreasureUpdate ~= nil then PerkLostTreasureUpdate(); end

local tracked_projectiles = EntityGetWithTag( "gkbrkn_projectile_orbit" );
if #tracked_projectiles > 0 then
    local previous_projectile = nil;
    local leader = nil;
    for i,projectile in pairs(tracked_projectiles) do
        EntityRemoveTag( projectile, "gkbrkn_projectile_orbit" );
        if previous_projectile ~= nil then
            EntityAddChild( leader, projectile );
            EntityAddComponent( projectile, "VariableStorageComponent", {
                _tags="gkbrkn_orbit",
                name="gkbrkn_orbit",
                value_string=tostring(#tracked_projectiles);
                value_int=tostring(i-1);
            } );
            EntityAddComponent( projectile, "LuaComponent", { script_source_file="files/gkbrkn/actions/projectile_orbit/projectile_update.lua", execute_on_added="1" } );
        else
            leader = projectile;
        end
        previous_projectile = projectile;
    end
end

function EntitiesAverageMemberList( entities, component_type, member_list, rounded, overrides )
    local averages = {};
    local overridden = {};
    for _,member in pairs(member_list) do
        averages[member] = 0;
    end
    local components = {};
    for _,entity in pairs(entities) do
        for _,component in pairs( EntityGetComponent( entity, component_type ) or {} ) do
            table.insert( components, component );
        end
    end
    for _,component in pairs( components ) do
        local members = ComponentGetMembers( component );
        for _,member in pairs(member_list) do
            averages[member] = averages[member] + members[member];
        end
        for member,value in pairs(overrides or {}) do
            if overridden[member] == nil and members[member] == value then
                overridden[member] = members[member];
            end
        end
    end
    for _,member in pairs(member_list) do
        averages[member] = averages[member] / #tracked_projectiles;
        if (rounded or {})[member] ~= nil then
            averages[member] = math.floor( averages[member] + 0.5 );
        end
    end
    for _,component in pairs( components ) do
        for _,member in pairs(member_list) do
            ComponentSetValue( component, member, averages[member] );
        end
        for member,value in pairs(overridden) do
            ComponentSetValue( component, member, value );
        end
    end
end

function mean_angle ( angles )
    local sumSin, sumCos = 0, 0;
    for i, angle in pairs( angles ) do
        sumSin = sumSin + math.sin( angle );
        sumCos = sumCos + math.cos( angle );
    end
    return math.atan2( sumSin, sumCos );
end

tracked_projectiles = EntityGetWithTag( "gkbrkn_projectile_equalization" );
if #tracked_projectiles > 0 then
    EntitiesAverageMemberList( tracked_projectiles, "ProjectileComponent", {
            "damage", "lifetime", "bounces_left", "bounce_energy",
            "ground_penetration_coeff", "knockback_force", "ragdoll_force_multiplier", "camera_shake_when_shot",
            "angular_velocity", "friction"
        },
        { bounces_left = true },
        { bounce_at_any_angle="1", bounce_always="1" } );
    EntitiesAverageMemberList( tracked_projectiles, "VelocityComponent", { 
        "gravity_x", "gravity_y", "mass", "air_friction", "terminal_velocity"
    } );
    local leader_angle
    local average_velocity_magnitude = 0;
    local angles = {};
    for i,entity in pairs( tracked_projectiles ) do
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local magnitude = math.sqrt( vx * vx + vy * vy );
        average_velocity_magnitude = average_velocity_magnitude + magnitude;

        -- ignore projectiles that don't move
        if magnitude > 0 then table.insert( angles, angle ); end

        EntityRemoveTag( entity, "gkbrkn_projectile_equalization" );
    end
    local average_angle = mean_angle( angles );
    average_velocity_magnitude = average_velocity_magnitude / #tracked_projectiles;
    for i,entity in pairs(tracked_projectiles) do
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        ComponentSetValueVector2( velocity, "mVelocity", math.cos( average_angle ) * average_velocity_magnitude, math.sin( average_angle ) * average_velocity_magnitude );
    end
    --[[
    local overridden = {};
    local averages = {};
    for _,member in pairs(averaged_projectile_members) do
        averages[member] = 0;
    end
    local average_velocity_magnitude = 0;
    local leader_angle = 0;
    local leader = nil;
    for i,entity in pairs(tracked_projectiles) do
        EntityRemoveTag( entity, "gkbrkn_true_spell_merge" );
        local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
        local members = ComponentGetMembers( projectile );
        for _,member in pairs(averaged_projectile_members) do
            averages[member] = averages[member] + members[member];
        end
        for member,value in pairs(overrides) do
            if overridden[member] == nil and members[member] == value then
                overridden[member] = members[member];
            end
        end
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
        local vx, vy = ComponentGetValueVector2( velocity, "mVelocity" );
        local angle = math.atan2( vy, vx );
        local magnitude = math.sqrt( vx * vx + vy * vy );
        average_velocity_magnitude = average_velocity_magnitude + magnitude;
        --average_velocity_angle = average_velocity_angle + angle;
        --GamePrint( angle * 180 / math.pi );
        if leader == nil then
            leader_angle = angle;
            leader = entity;
        else
            --EntityAddChild( leader, entity );
            --EntityAddComponent( entity, "InheritTransformComponent" );
            --EntityKill( entity );
        end
    end
    for _,member in pairs(averaged_projectile_members) do
        averages[member] = averages[member] / #tracked_projectiles;
        if rounded[member] ~= nil then
            averages[member] = math.floor( averages[member] + 0.5 );
        end
    end
    average_velocity_magnitude = average_velocity_magnitude / #tracked_projectiles;
    for i,entity in pairs(tracked_projectiles) do
        local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
        local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );

        for _,member in pairs(averaged_projectile_members) do
            ComponentSetValue( projectile, member, tostring( averages[member] ) );
        end
        for member,value in pairs(overridden) do
            ComponentSetValue( projectile, member, value );
        end
        ComponentSetValueVector2( velocity, "mVelocity", math.cos( leader_angle ) * average_velocity_magnitude, math.sin( leader_angle ) * average_velocity_magnitude );
    end
        ]]
end

local players = EntityGetWithTag( "player_unit" );
for _,player in pairs( players ) do
    local x,y = EntityGetTransform( player );

    local nearby_entities = EntityGetInRadiusWithTag( x, y, 256, "mortal" );
    if HasFlagPersistent( MISC.ChampionEnemies.Enabled ) then
        DoFileEnvironment( "files/gkbrkn/misc/champion_enemies.lua", { nearby_entities = nearby_entities } );
    end

    nearby_entities = EntityGetInRadius( x, y, 256 );
    if HasFlagPersistent( MISC.LessParticles.Enabled ) then
        DoFileEnvironment( "files/gkbrkn/misc/less_particles.lua", { nearby_entities = nearby_entities } );
    end
    if HasFlagPersistent( MISC.GoldDecay.Enabled ) then
        DoFileEnvironment( "files/gkbrkn/misc/gold_decay/update.lua", { nearby_entities = nearby_entities } );
    end

    if CONTENT[PERKS.MaterialCompression].enabled() then
        DoFileEnvironment( "files/gkbrkn/perks/material_compression/player_update.lua", { player = player } );
    end

    if HasFlagPersistent( MISC.QuickSwap.Enabled ) then
        local controls = EntityGetFirstComponent( player, "ControlsComponent" );
        local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
        if controls ~= nil and inventory2 ~= nil then
            local active_item = ComponentGetValue( inventory2, "mActiveItem" );
            if active_item == nil or EntityHasTag( active_item, "wand" ) == true then
                local alt_fire = ComponentGetValue( controls, "mButtonDownFire2" );
                local alt_fire_frame = ComponentGetValue( controls, "mButtonFrameFire2" );
                if alt_fire == "1" and GameGetFrameNum() == tonumber(alt_fire_frame) then
                    local inventory = nil;
                    local swap_inventory = nil;
                    for _,child in pairs(EntityGetAllChildren( player )) do
                        if EntityGetName(child) == "inventory_quick" then
                            inventory = child;
                        elseif EntityGetName(child) == "gkbrkn_swap_inventory" then
                            swap_inventory = child;
                        end
                    end
                    if inventory ~= nil and swap_inventory ~= nil then
                        local inventory_entities = EntityGetAllChildren( inventory ) or {};
                        local swap_inventory_entities = EntityGetAllChildren( swap_inventory ) or {};
                        for _,child in pairs(inventory_entities) do EntityRemoveFromParent( child ); end
                        for _,child in pairs(swap_inventory_entities) do EntityRemoveFromParent( child ); end
                        for _,child in pairs(inventory_entities) do EntityAddChild( swap_inventory, child ); end
                        for _,child in pairs(swap_inventory_entities) do EntityAddChild( inventory, child ); end
                    end
                end
            end
        end
    end
    
    --local genome = EntityGetFirstComponent( player, "GenomeDataComponent" );
    --GamePrint( "herd id: ".. ComponentGetValue( genome, "herd_id" ) );
    --[[
    local cape = EntityGetNamedChild( player, "cape" );
    if cape ~= nil then
        local verlet = EntityGetFirstComponent( cape, "VerletPhysicsComponent" );
        if verlet ~= nil then
            local culled = ComponentGetValue( verlet, "m_is_culled_previous" );
            if culled == "1" then
                local cx, cy = EntityGetTransform( cape );
                GamePrint("trying to fix cape");
                local inherit = EntityGetFirstComponent( cape, "InheritTransformComponent" );
                if inherit~= nil then
                    EntitySetComponentIsEnabled( cape, inherit, false );
                    EntitySetTransform( cape, x, y);
                end
                --EntitySetComponentIsEnabled( cape, verlet, false );
                --EntitySetComponentIsEnabled( cape, verlet, true );
                ComponentSetValue( verlet, "follow_entity_transform", "1" );
                local px, py = ComponentGetValueVector2( verlet, "m_position_previous" );
                GamePrint( cx.."/"..cy.." || "..x.."/"..y);
                --ComponentSetValueVector2( verlet,"m_position_previous", x, y );
                --ComponentSetValue( verlet, "m_position_previous", tostring(x) );
                --ComponentSetValue( verlet, "m_position_previous", tostring(y) );
                --Log( "cape is missing" );
            end
            --EntitySetTransform( cape, Random( -100, 100 ), Random( -100, 100 ) ) ;
        end
    end
    ]]

    --[[
    local children = EntityGetAllChildren( player );
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
    local active_item = ComponentGetValue( inventory2, "mActiveItem" );
    for key, child in pairs( children ) do
        if EntityGetName( child ) == "inventory_quick" then
            valid_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
            break;
        end
    end

    for _,wand in pairs(valid_wands) do
        if wand ~= active_item then
            local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
            if ability ~= nil then
                local charge_wait = tonumber( ComponentGetValue( ability, "mNextFrameUsable" ) );
                --ComponentSetValue( ability, "mNextFrameUsable", "0" )
                GamePrint(charge_wait - game_frame );
            end
        end
    end
    ]]

    --[[
    local paused = HasFlagPersistent("gkbrkn_paused");
    if GameGetFrameNum() % 40 == 0 then
        GamePrint( tostring( paused ) );
        if paused then
            RemoveFlagPersistent("gkbrkn_paused");
            ModMagicNumbersFileAdd( "files/gkbrkn/misc/unpause_simulation.xml" );
        else
            AddFlagPersistent("gkbrkn_paused");
            ModMagicNumbersFileAdd( "files/gkbrkn/misc/pause_simulation.xml" );
        end
        GamePrint( "physics toggle" );
    end
    ]]
end

--[[
    local players = EntityGetWithTag( "player_unit" );
    for _,player in pairs( players ) do
        local x, y = EntityGetTransform( player );
        local nearby_entities = EntityGetInRadius( x, y, 128 );
        for _,entity in pairs( nearby_entities ) do
            if EntityHasTag( entity, "gkbrkn_bad_aimer" ) == false then
                local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" );
                if animal_ais ~= nil then
                    for _,ai in pairs( animal_ais ) do
                        ComponentSetValue( ai, "creature_detection_range_x", "100" );
                        ComponentSetValue( ai, "creature_detection_range_y", "100" );
                        --ComponentSetValue( ai, "attack_ranged_frames_between", "10" );
                        GamePrint("made enemy "..entity.." suck at detection");
                    end
                    EntityAddTag( entity, "gkbrkn_bad_aimer" );
                end
            end
        end
    end
    ]]

    --GameCreateParticle( "gold", -0, -100, 1, 0, 0, false )
    --GamePrint( #EntityGetWithTag("gkbrkn_action_orbit") );
    
    --[[
    local players = EntityGetWithTag( "player_unit" );
    if players ~= nil then
        for index,player_entity_id in pairs( players ) do
            local component = EntityGetFirstComponent( player_entity_id, "Inventory2Component" );
            GamePrint( component.."@ herd"..ComponentGetValue( component, "mActiveItem" ) );
        end
    end
    ]]