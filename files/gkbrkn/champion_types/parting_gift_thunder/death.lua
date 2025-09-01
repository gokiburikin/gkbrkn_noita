function death()
    local entity = GetUpdatedEntityID()
    local x,y = EntityGetTransform(entity)
    local gift = EntityLoad("data/entities/projectiles/thunderball.xml", x, y)
    EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
end