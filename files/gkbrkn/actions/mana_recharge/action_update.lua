if _GKBRKN_HELPER == nil then dofile( "files/gkbrkn/helper.lua"); end
local parent_wand = EntityGetParent( GetUpdatedEntityID() );
local ability = WandGetAbilityComponent( parent_wand, "AbilityComponent" );
if ability ~= nil then
    local mana = tonumber( ComponentGetValue( ability, "mana" ) );
    local max_mana = tonumber( ComponentGetValue( ability, "mana_max" ) );
    if mana < max_mana then
        ComponentSetValue( ability, "mana", tostring( mana + 0.625 ) );
    else
        ComponentSetValue( ability, "mana", tostring( max_mana ) );
    end
end