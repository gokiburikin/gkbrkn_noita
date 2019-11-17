function EntityGetVariableString( entity, variable_tag, default )
    local variable = EntityGetFirstComponent( entity, "VariableStorageComponent", variable_tag );
    if variable ~= nil then
        return ComponentGetValue( variable, "value_string" );
    end
    return default;
end

function EntitySetVariableString( entity, variable_tag, value )
    local current_variable = EntityGetFirstComponent( entity, "VariableStorageComponent", variable_tag );
    if current_variable == nil then
        EntityAddComponent( entity, "VariableStorageComponent", {
            _tags=variable_tag,
            value_string=tostring(value)
        } );
    else
        ComponentSetValue( current_variable, "value_string", tostring( value ) );
    end
end

function EntityGetVariableNumber( entity, variable_tag, default )
    return tonumber( EntityGetVariableString( entity, variable_tag, default ) );
end

function EntitySetVariableNumber( entity, variable_tag, value )
    return EntitySetVariableString( entity, variable_tag, value );
end

function EntityAdjustVariableNumber( entity, variable_tag, default, callback )
    EntitySetVariableNumber( entity, variable_tag, callback( EntityGetVariableNumber( entity, variable_tag, default ) ) );
end