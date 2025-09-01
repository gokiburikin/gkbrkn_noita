dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/helper.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/variables.lua" )

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity )
	if entity_who_caused == entity or entity_who_caused == EntityGetParent( entity ) or entity_who_caused == NULL_ENTITY or damage <= 0 then return end
    if is_fatal then
        EntityLoad( "mods/gkbrkn_noita/files/gkbrkn/champion_types/tremor/tremor.xml", x, y )
        --EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
        GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/crumbling_earth/create", x, y )
        EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/warning_effect.xml", x, y)
    end
end
