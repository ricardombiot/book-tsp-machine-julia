function parents_to_text(node :: Node) :: String
    parents_txt = ""
    for (node_id, edge_id) in node.parents
        node_id_txt = NodeIdentity.to_string(node_id)
        parents_txt *= "$(node_id_txt),"
    end

    return chop(parents_txt, tail = 1)
end

function sons_to_text(node :: Node) :: String
    sons_txt = ""
    for (node_id, edge_id) in node.sons
        node_id_txt = NodeIdentity.to_string(node_id)
        sons_txt *= "$(node_id_txt),"
    end

    return chop(sons_txt, tail = 1)
end

function owners_to_text(graph :: Graph, node :: Node) :: String
    owners_txt = ""
    for step in Step(0):node.owners.max_step
        vacio = Owners.isempty(node.owners, step)
        list = list_owners_to_text(graph, step, node)
        tolist = make_to_list(step, node)
        count = Owners.count(node.owners, step)

        #owners_txt *= "<BR /><FONT POINT-SIZE=\"8\"> CalcKm: $step: $list"
        #owners_txt *= "</FONT>"

        #owners_txt *= "<BR /><FONT POINT-SIZE=\"8\"> Km: $step: $tolist [$count|$vacio]"
        owners_txt *= "<BR /><FONT POINT-SIZE=\"8\"> Step $step: $tolist"

        #owners_txt *= "<BR /> $tolist"
        owners_txt *= "</FONT>"
    end

    return owners_txt
end


function make_to_list(step :: Step, node :: Node)
    owners_txt = ""
    for key in Owners.to_list(node.owners, step)
        owners_txt *= "K$key"
    end
    return owners_txt
end

function list_owners_to_text(graph :: Graph, step :: Step, node :: Node) :: String
    owners_txt = ""
    for node_id in graph.table_lines[step]
        if Owners.have(node.owners, step, node_id)
            node_id_txt = NodeIdentity.to_string(node_id)
            node_owner = PathGraph.get_node(graph, node_id)
            owners_txt *= "$node_id_txt( $(node_owner.color) )"
        end
    end

    return owners_txt
end



function node_edge_to_dot(graph :: Graph, edge :: Edge) :: String
    id_origin_txt = NodeIdentity.to_string(edge.id.origin_id,"_")
    id_destino_txt = NodeIdentity.to_string(edge.id.destine_id,"_")

    node_origin = "step_$(id_origin_txt)"
    node_destine = "step_$(id_destino_txt)"

    edge_txt = "$node_origin -> $node_destine;"

    return "$edge_txt \n"
end
