dofile( "files/gkbrkn/helper.lua");
local parent_wand = EntityGetParent( GetUpdatedEntityID() );
local ability = WandGetAbilityComponent( parent_wand, "AbilityComponent" );
if ability ~= nil then
    ComponentSetValue( ability, "mReloadFramesLeft", tostring( tonumber( ComponentGetValue( ability, "mReloadFramesLeft" ) ) - 1  ) );
end