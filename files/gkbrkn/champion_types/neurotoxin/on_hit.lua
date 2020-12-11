local entity = GetUpdatedEntityID();
EntityAddRandomStains( entity, CellFactory_GetType( "poison" ), 10 );
EntityAddRandomStains( entity, CellFactory_GetType( "material_confusion" ), 10 );