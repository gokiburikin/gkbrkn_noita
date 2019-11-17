if _ONCE == nil then
    _ONCE = true;
    dofile( "files/gkbrkn/helper.lua" );
    dofile( "files/gkbrkn/lib/variables.lua" );
end
local player = GetUpdatedEntityID();
local mana_recovery = EntityGetVariableNumber( player, "gkbrkn_mana_recovery", 0 );
if mana_recovery ~= 0 then
    local children = EntityGetAllChildren( player ) or {};
    local valid_wands = {};
    local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
    if inventory2 ~= nil then
        for key, child in pairs( children ) do
            if EntityGetName( child ) == "inventory_quick" then
                valid_wands = EntityGetChildrenWithTag( child, "wand" ) or {};
                break;
            end
        end

        for _,wand in pairs(valid_wands) do
            local ability = WandGetAbilityComponent( wand, "AbilityComponent" );
            if ability ~= nil then
                local mana = tonumber( ComponentGetValue( ability, "mana" ) );
                local max_mana = tonumber( ComponentGetValue( ability, "mana_max" ) );
                if mana < max_mana then
                    ComponentSetValue( ability, "mana", tostring( math.min( mana + mana_recovery, max_mana ) ) );
                end
            end
        end
    end
end