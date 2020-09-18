dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local parent_wand = EntityGetParent( GetUpdatedEntityID() );
local ability = WandGetAbilityComponent( parent_wand, "AbilityComponent" );
if ability ~= nil then
    ComponentSetValue2( ability, "mReloadFramesLeft", ComponentGetValue2( ability, "mReloadFramesLeft" ) - 1  );
end