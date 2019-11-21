local game_frame = GameGetFrameNum();

local players = EntityGetWithTag( "player_unit" );
for _,player in pairs( players ) do
    local x,y = EntityGetTransform( player );

    if game_frame % 60 == 0 then
        --[[ Stain Data
        local status_effect_data = EntityGetFirstComponent( player, "StatusEffectDataComponent" );
        if status_effect_data ~= nil then
            local vector_size = ComponentGetVectorSize( status_effect_data, "stain_effects", "float" );
            local replacement = {};
            for i=0,vector_size-1 do
                replacement[i+1] = 1.0;
                GamePrint( ComponentGetVectorValue( status_effect_data, "stain_effects", "float", i ) or "nil" );
            end
            ComponentSetValue( status_effect_data, "stain_effects", replacement );
        end
        ]]
        --[[ Inventory Slot
        local inventory = EntityGetNamedChild( player, "inventory_quick" );
        if inventory ~= nil then
            local inventory_items = EntityGetAllChildren( inventory ) or {};
            if inventory_items ~= nil then
                for i,item_entity in pairs( inventory_items ) do
                    local item = FindFirstComponentThroughTags( item_entity, "item_name" );
                    if item ~= nil then
                        GamePrint( EntityGetFirstComponent( item_entity, "ItemComponent" ) );
                        --local x,y = ComponentGetValueVector2( item, "inventory_slot" );
                        --GamePrint( x .. "/"..y );
                        --local vector_size = ComponentGetVectorSize( item, "inventory_slot", "int" );
                        --GamePrint(vector_size);
                        local x = ComponentGetVectorValue( item, "inventory_slot", "int", 0 );
                        local y = ComponentGetVectorValue( item, "inventory_slot", "int", 1 );
                        GamePrint( x or "nil" );
                        GamePrint( y or "nil" );
                    end
                    --local components = EntityGetAllComponents( item_entity ) or {};
                    --GamePrint(#components);
                    --local item = EntityGetFirstComponent( item_entity, "ItemComponent" );
                    --GamePrint(tostring(item));
                    --if item ~= nil then
                    --    local vector_size = ComponentGetVectorSize( item, "inventory_slot", "int" );
                    --    GamePrint(vector_size);
                    --end
                    --local item = EntityGetFirstComponent( item_entity, "ItemComponent" );
                    --GamePrint( tostring( item ) or "nil");
                end
            end
        end
        ]]
    end

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
        DoFileEnvironment( "files/gkbrkn/misc/quick_swap.lua", { player = player } );
    end

    --[[ Healing 
    local damage_models = EntityGetComponent( player, "DamageModelComponent" );
    if damage_models ~= nil then
        for index,damage_model in pairs( damage_models ) do
            local max_hp = tonumber(ComponentGetValue( damage_model, "max_hp" ));
            ComponentSetValue( damage_model, "hp", tostring( max_hp ) );
        end
    end
    ]]

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