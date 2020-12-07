function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
    local entity = GetUpdatedEntityID();
    local hp = 0;
    for _,damage_model in pairs( EntityGetComponent( entity, "DamageModelComponent" ) or {} ) do
        local this_hp = ComponentGetValue2( damage_model, "hp" );
        if this_hp > hp then
            hp = this_hp;
        end
    end
    if hp > 0.04 and damage > hp then
        local allowable_damage = hp - 0.04;
        return allowable_damage, critical_hit_chance;
    end
    return damage, critical_hit_chance;
end