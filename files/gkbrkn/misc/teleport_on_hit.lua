dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" );

-- This is spawn
local FALLBACK_LOCATION = { x=228, y=-80 };

-- If this is nil (block commented out) or empty, always teleport to fallback location (for No-Hit)
-- Locations in the Holy Mountains where the collapse will happen
local TELEPORT_LOCATIONS = {
    { x=145, y=1340 },
    { x=145, y=2880 },
    { x=145, y=4930 },
    { x=145, y=6460 },
    { x=145, y=8510 },
    { x=145, y=10560 },
    { x=2672, y=13200 },
}

-- Locations at the entrance to the Holy Mountains
--[[
local TELEPORT_LOCATIONS = {
    { x=-662, y=1350 },
    { x=-662, y=1850 },
    { x=-662, y=4950 },
    { x=-662, y=6450 },
    { x=-662, y=8450 },
    { x=-662, y=10550 },
    { x=2672, y=13150 },
}
]]

-- To ensure we don't run the teleport function over and over again rapidly
local MINIMUM_DISTANCE = 64;

-- So that adjustments can be made to the spawn locations without having to recalculate them
local SPAWN_OFFSET = { x=0, y=-5 };

-- Should the player maintain velocity?
local MAINTAIN_VELOCITY = false;

-- The message to display upon teleporting (nil will not display)
local TELEPORT_MESSAGE = { text="A minor setback", note=nil }

-- If true you can never be teleported to an earlier location than you've been teleported to before
local USE_CHECKPOINTS = true;

local INCLUDE_ENVIRONMENTAL_HITS = true;
local INCLUDE_SELF_HITS = true;
local INCLUDE_NEGATIVE_DAMAGE = true;

function damage_received( damage, message, entity_thats_responsible, is_fatal )
    local entity = GetUpdatedEntityID();
    local x,y = EntityGetTransform( entity );

    local last_checkpoint = {
        x=EntityGetVariableNumber( entity, "gkbrkn_teleport_on_hit_checkpoint_x", FALLBACK_LOCATION.x ),
        y=EntityGetVariableNumber( entity, "gkbrkn_teleport_on_hit_checkpoint_y", FALLBACK_LOCATION.y )
    };

    -- Default to last checkpoint (which defaults to fallback location) if none of the locations end up being valid
    local nearest_location =  last_checkpoint;
    for _,location in pairs( TELEPORT_LOCATIONS or {} ) do
        if location.y <= y then
            if USE_CHECKPOINTS == false or last_checkpoint == nil or location.y >= last_checkpoint.y then
                nearest_location = location;
            end
        end
    end

    -- Assume the hit won't be counted
    local counted_hit = false;

    -- 0 is the null entity which tends to represent environmental / world damage
    if tonumber( entity_thats_responsible ) == 0 then
        if INCLUDE_ENVIRONMENTAL_HITS then counted_hit = true; end
    -- If the entity that is responsible is the player
    elseif tonumber( entity_thats_responsible ) == entity then
        if INCLUDE_SELF_HITS then counted_hit = true; end
    -- Otherwise it was from an enemy (most likely)
    else
        counted_hit = true;
    end

    -- If damage would be negative and counted, but we don't include negative damage, reset counted to false
    if counted_hit and damage <= 0 and INCLUDE_NEGATIVE_DAMAGE ~= true then counted_hit = false; end

    -- If the hit passes all the validators
    if counted_hit then
        local distance = math.sqrt( math.pow( nearest_location.x - x, 2 ) + math.pow( nearest_location.y - y, 2 ) );
        if distance > MINIMUM_DISTANCE then
            if USE_CHECKPOINTS then
                EntitySetVariableNumber( entity, "gkbrkn_teleport_on_hit_checkpoint_x", nearest_location.x );
                EntitySetVariableNumber( entity, "gkbrkn_teleport_on_hit_checkpoint_y", nearest_location.y );
            end
            EntitySetTransform( entity, nearest_location.x + SPAWN_OFFSET.x, nearest_location.y + SPAWN_OFFSET.y );
            if not MAINTAIN_VELOCITY then
                local velocity = EntityGetFirstComponent( entity, "VelocityComponent" );
                ComponentSetValueVector2( velocity, "mVelocity", 0, 0 );
            end
            if TELEPORT_MESSAGE ~= nil then
                GamePrintImportant( TELEPORT_MESSAGE.text or "", TELEPORT_MESSAGE.note or "" );
            end
        end
    end
end