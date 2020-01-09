dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua");
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local entity = GetUpdatedEntityID();
local projectile = EntityGetFirstComponent( entity, "ProjectileComponent" );
if projectile ~= nil then
    local keep = false;
    local shooter = tonumber( ComponentGetValue( projectile, "mWhoShot" ) ) or 0;
    local active_wand = WandGetActive( shooter );
    if active_wand ~= nil then
        local x, y = EntityGetTransform( entity );
        local wx, wy = EntityGetTransform( active_wand );
        local distance = math.sqrt( math.pow( wx - x, 2 ) + math.pow( wy - y, 2 ) ) + 8;
        EntitySetVariableNumber( entity, "gkbrkn_magic_hand_distance", distance );
    end
end