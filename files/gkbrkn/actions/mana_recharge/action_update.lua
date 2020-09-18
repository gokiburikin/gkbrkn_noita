dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua");
local parent_wand = EntityGetParent( GetUpdatedEntityID() );
local ability = WandGetAbilityComponent( parent_wand, "AbilityComponent" );
if ability ~= nil then
    local mana = ComponentGetValue2( ability, "mana" );
    local max_mana = ComponentGetValue2( ability, "mana_max" );
    if mana < max_mana then
        ComponentSetValue2( ability, "mana", mana + 0.625 );
    else
        ComponentSetValue2( ability, "mana", max_mana );
    end
end