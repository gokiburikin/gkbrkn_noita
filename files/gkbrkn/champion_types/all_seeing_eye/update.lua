local entity = GetUpdatedEntityID();
local charmed = GameGetGameEffectCount( entity, "CHARM" );
local player = EntityGetWithTag( "player_unit" )[1];
if player and charmed < 1 then
    local entity_genome = EntityGetFirstComponent( entity, "GenomeDataComponent" );
    local entity_herd = -1;
    if entity_genome ~= nil then
        entity_herd = ComponentGetValue2( entity_genome, "herd_id" );
        if player_herd ~= entity_herd then
            local animal_ais = EntityGetComponent( entity, "AnimalAIComponent" ) or {};
            for _,ai in pairs( animal_ais ) do
                if ComponentGetValue2( ai, "tries_to_ranged_attack_friends" ) == false then
                    ComponentSetValue2( ai, "mGreatestPrey", player );
                end
            end
        end
    end
end