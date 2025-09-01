function EntityHasVarTag( e, tag )
    for _,v in pairs( EntityGetComponentIncludingDisabled( e, "VariableStorageComponent" ) or {} ) do
        if ComponentGetValue2( v, "name" ) == tag then return true end
    end
    return false
end

function EntityAddVarTag( e, tag )
    if not EntityHasVarTag( e, tag ) and EntityGetIsAlive( e ) then
        EntityAddComponent2( e, "VariableStorageComponent", { name = tag } )
    end
end

function EntityRemoveVarTag( e, tag )
    for _,v in pairs( EntityGetComponentIncludingDisabled( e, "VariableStorageComponent" ) or {} ) do
        if ComponentGetValue2( v, "name" ) == tag then
            EntityRemoveComponent( e, v )
            return true
        end
    end
    return false
end