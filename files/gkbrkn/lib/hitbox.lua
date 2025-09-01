local entity_hitbox_test = function( entity_a, entity_b )
    local a_aabbs = {}
    local ax, ay = EntityGetTransform( entity_a )
    for _,hb in pairs(EntityGetComponent( entity_a, "HitboxComponent" )) do
        local ox, oy = ComponentGetValue2( hb, "offset" )
        table.insert( a_aabbs, {
            x1 = ComponentGetValue2( hb, "aabb_min_x" ) + ox + ax,
            x2 = ComponentGetValue2( hb, "aabb_max_x" ) + ox + ax,
            y1 = ComponentGetValue2( hb, "aabb_min_y" ) + oy + ay,
            y2 = ComponentGetValue2( hb, "aabb_max_y" ) + oy + ay
        })
    end
    local b_aabbs = {}
    local bx, by = EntityGetTransform( entity_b )
    for _,hb in pairs(EntityGetComponent( entity_b, "HitboxComponent" )) do
        local ox, oy = ComponentGetValue2( hb, "offset" )
        table.insert( a_aabbs, {
            x1 = ComponentGetValue2( hb, "aabb_min_x" ) + ox + bx,
            x2 = ComponentGetValue2( hb, "aabb_max_x" ) + ox + bx,
            y1 = ComponentGetValue2( hb, "aabb_min_y" ) + oy + by,
            y2 = ComponentGetValue2( hb, "aabb_max_y" ) + oy + by
        })
    end
    for _,a_hb in pairs(a_aabbs) do
        for _,b_hb in pairs(b_aabbs) do
        if a_hb.x1 < b_hb.x2 and a_hb.x2 > b_hb.x1 then
            if a_hb.y1 < b_hb.y2 and a_hb.y2 > b_hb.y1 then
                return true
            end
        end
    end
    return false
end