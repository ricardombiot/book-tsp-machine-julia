function get_info_node_id(n :: Color, node_id :: NodeId) :: Tuple{Tuple{Km,Color}, Tuple{Km,Color}}
    return get_info_node_id(n, node_id.action_id, node_id.action_parent_id)
end

function get_info_node_id(n :: Color, action_id :: ActionId, action_parent_id :: ActionId) :: Tuple{Tuple{Km,Color}, Tuple{Km,Color}}
    (km_destino, color_destino) = GeneratorIds.get_info_id(n, action_id)
    (km_origen, color_origin) = GeneratorIds.get_info_id(n, action_parent_id)

    return ( (km_destino, color_destino),  (km_origen, color_origin) )
end

function calc_key(n :: Color, b :: Km, step :: Step, action_id :: ActionId, action_parent_id :: ActionId) :: UniqueNodeKey
    ((km_destine, color_destine), (km_origin, color_origin)) = get_info_node_id(n, action_id, action_parent_id)

    return (step*b^2*n^2) + (km_origin*(b*n^2)) + (color_origin*b*n) + (km_destine*n) + (color_destine) + 1
end
