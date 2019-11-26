-- Include functionality from the base games perks file
dofile_once( "data/scripts/perks/perk.lua" );
-- This runs when player entity has been created, even from a loaded game
function OnPlayerSpawned( player_entity )
    -- Use a unique identifier for this mod
    local init_check_flag = "add_starting_perk";
    -- If we haven't set this flag on this run, set the flag and give the player the perk
    -- This ensures we don't give the player the perk again every time they save and quit and come back
    if GameHasFlagRun( init_check_flag ) == false then
        -- Set the unique flag used to ensure we don't give the perk again until they start a new run
        GameAddFlagRun( init_check_flag );
        -- Create the perk pickup in the world
        local perk_entity = perk_spawn( x, y, "EDIT_WANDS_EVERYWHERE" );
        -- If for whatever reason the spawn failed (typo in the name, wrong id, missing perk, etc) we don't attempt to pick it up
        if perk_entity ~= nil then
            -- Attempt to pick up the perk, giving it to the player and removing it from the world
            perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false );
        end
    end
end