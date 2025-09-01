dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/vartags.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/helper.lua" )
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity )
    local options = {
        { filepath="data/entities/animals/longleg.xml", min=3, max=6 },
        { filepath="data/entities/animals/rat.xml", min=2, max=4 },
        { filepath="data/entities/animals/miniblob.xml", min=1, max=2, callback = function( entity )
            TryAdjustMaxHealth( entity, function( max, current ) return max * 0.33 end )
        end },
        { filepath="data/entities/animals/frog.xml", min=1, max=2 },
        { filepath="data/entities/animals/frog_big.xml", min=1, max=1, callback = function( entity )
            TryAdjustMaxHealth( entity, function( max, current ) return max * 0.18 end )
        end },
        { filepath="data/entities/animals/worm_tiny.xml", min=1, max=1 },
    }
    SetRandomSeed( GameGetFrameNum(), x + y + entity )
    local option = options[Random(1, #options)]
    local amount = Random( option.min, option.max )
    for i=1,amount do 
        local add = EntityLoad( option.filepath, x + Random( -8, 8 ), y + Random( 0, -16 ) )
        --EntityAddRandomStains( add, CellFactory_GetType("material_confusion"), 10 )
        local b = EntityCreateNew()
        local a = EntityAddComponent2( b, "GameEffectComponent", {
            effect="CUSTOM",
            frames=Random(25,50),
            disable_movement=true,
        })
        EntityAddChild( add, b )
        --EntitySetVelocity( add, Random( -50, 50 ), Random( -10, -100 ) )
        if option.callback then option.callback( add ) end
        if EntityHasVarTag( entity, "gkbrkn_weak_champion" ) then
            EntityAddVarTag( add, "gkbrkn_no_champion" )
        else
            EntityAddVarTag( add, "gkbrkn_weak_champion" )
        end
    end
    GamePlaySound( "data/audio/Desktop/animals.bank", "animals/bat/attack_dash", x, y )
    EntityLoad("mods/gkbrkn_noita/files/gkbrkn/misc/warning_effect.xml", x, y)
end