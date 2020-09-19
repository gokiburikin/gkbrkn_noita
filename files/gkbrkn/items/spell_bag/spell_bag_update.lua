local entity = GetUpdatedEntityID();
local spell_storage = EntityGetAllChildren( entity )[1];
local x,y = EntityGetTransform( entity );

last_use_frame = last_use_frame or 0;

function update_amount_stored()
    local item = EntityGetFirstComponentIncludingDisabled( entity, "ItemComponent" );
    if item then
        ComponentSetValue2( item, "uses_remaining", #( EntityGetAllChildren(spell_storage) or {} ) );
    end
end

local parent = EntityGetParent( entity );
local holder = EntityGetParent( parent );
if holder ~= nil then
    local now = GameGetFrameNum();
    local controls = EntityGetFirstComponent( holder, "ControlsComponent" );
    if controls ~= nil then
        local use_button = ComponentGetValue2( controls, "mButtonDownFire" );
        local use_button_frame = ComponentGetValue2( controls, "mButtonFrameFire" );
        if use_button == true and use_button_frame == now then
            last_use_frame = use_button_frame;
            local children = EntityGetAllChildren( spell_storage ) or {};
            if #children > 0 then
                local random_child = children[ math.ceil( math.random() * #children )];
                EntityRemoveFromParent( random_child );
                EntitySetComponentsWithTagEnabled( random_child,  "enabled_in_world", true );
                EntitySetComponentsWithTagEnabled( random_child,  "item_unidentified", false );
                local velocity = EntityGetFirstComponent( random_child, "VelocityComponent" );
                if velocity ~= nil then
                    ComponentSetValue2( velocity, "mVelocity", Random( -100, 100 ), -100 );
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
                    if item_cost == nil or ComponentGetValue2( item_cost, "cost" ) <= 0 then
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