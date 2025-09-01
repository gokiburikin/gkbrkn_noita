function damage_received( damage, message, entity_thats_responsible, is_fatal  )
    if is_fatal then
        GlobalsSetValue("gkbrkn_siphon_charges", tostring(tonumber( GlobalsGetValue( "gkbrkn_siphon_charges", "0") ) + 1) )
    end
end