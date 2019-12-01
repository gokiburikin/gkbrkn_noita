local entity = GetUpdatedEntityID();
local spell_storage = EntityGetAllChildren( entity )[1];
local x,y = EntityGetTransform( entity );

last_use_frame = last_use_frame or 0;

function update_amount_stored()
    for _,component in pairs( EntityGetAllComponents( entity ) or {} ) do
        if ComponentGetValue( component, "uses_remaining" ) ~= "" then
            ComponentSetValue( component, "uses_remaining", #( EntityGetAllChildren(spell_storage) or {} ) );
        end
    end
end

local parent = EntityGetParent( entity );
local holder = EntityGetParent( parent );
if holder ~= nil then
    local now = GameGetFrameNum();
    local controls = EntityGetFirstComponent( holder, "ControlsComponent" );
    if controls ~= nil then
        local alt_fire = ComponentGetValue( controls, "mButtonDownFire2" );
        local alt_fire_frame = ComponentGetValue( controls, "mButtonFrameFire2" );
        if alt_fire == "1" and tonumber(alt_fire_frame) == now then
            last_use_frame = tonumber(alt_fire_frame);
            local children = EntityGetAllChildren( spell_storage ) or {};
            if #children > 0 then
                local random_child = children[ math.ceil( math.random() * #children )];
                EntityRemoveFromParent( random_child );
                EntitySetComponentsWithTagEnabled( random_child,  "enabled_in_world", true );
                EntitySetComponentsWithTagEnabled( random_child,  "item_unidentified", false );
                local velocity = EntityGetFirstComponent( random_child, "VelocityComponent" );
                if velocity ~= nil then
                    ComponentSetValueVector2( velocity, "mVelocity", Random( -100, 100 ), -100 );
                end
                EntitySetTransform( random_child, x, y );
                update_amount_stored();
            end
        elseif now - last_use_frame > 30 then
            local holder_x, holder_y = EntityGetTransform( holder );
            local nearby_entities = EntityGetInRadiusWithTag( holder_x, holder_y, 8, "card_action" );
            for _,card in pairs( nearby_entities ) do
                if EntityGetParent( card ) == 0 then
                    local item_cost = EntityGetFirstComponent( card, "ItemCostComponent" );
                    if item_cost == nil or tonumber( ComponentGetValue( item_cost, "cost" ) ) <= 0 then
                        EntityAddChild( spell_storage, card );
                        EntitySetComponentsWithTagEnabled( card,  "enabled_in_world", false );
                        update_amount_stored();
                        --GamePlaySound( bank_filename, event_path, x, y );
                    end
                end
            end
        end
    end
end