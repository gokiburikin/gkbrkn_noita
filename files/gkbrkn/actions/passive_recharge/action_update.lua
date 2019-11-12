if _GKBRKN_HELPER == nil then dofile( "files/gkbrkn/helper.lua"); end
local parent_wand = EntityGetParent( GetUpdatedEntityID() );
local ability = WandGetAbilityComponent( parent_wand, "AbilityComponent" );
if ability ~= nil then
    ComponentSetValue( ability, "mReloadFramesLeft", tostring( tonumber( ComponentGetValue( ability, "mReloadFramesLeft" ) ) - 1  ) );
end