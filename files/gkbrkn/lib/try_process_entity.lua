last_handled_entity = last_handled_entity or 0
while last_handled_entity < EntitiesGetMaxID() do
    process_entity( last_handled_entity )
    last_handled_entity = last_handled_entity + 1
end