# $ O(N^4) $
function join!(graph :: Graph, inmutable_graph_join :: Graph) :: Bool
    if is_valid_join(graph, inmutable_graph_join)
        # Expensive...
        # @TODO CALCULAR COST
        graph_join = deepcopy(inmutable_graph_join)

        # $ O(N^3) $
        union_owners!(graph, graph_join)
        # $ O(N^4) $
        join_nodes!(graph, graph_join)
        # $ O(N^3) $
        join_lines!(graph, graph_join)
        # $ O(N^3) $
        join_color_nodes!(graph, graph_join)
        # $ O(N^4) $
        join_edges!(graph, graph_join)

        join_max_stages_review!(graph, graph_join)

        return true
    else
        return false
    end
end

# $ O(N^3) $
function union_owners!(graph :: Graph, graph_join :: Graph)
    # $ O(steps) * O(N^2) $
    Owners.union!(graph.owners, graph_join.owners)
end

# $ O(N^4) $
function join_nodes!(graph :: Graph, graph_join :: Graph)
    # $ O(N actions by step) = O(N^2) $
    #! [for] $ O(N*N) $
    for (action_id, dict) in graph_join.table_nodes
        if !haskey(graph.table_nodes, action_id)
            graph.table_nodes[action_id] = dict
        else
            actual_dict = graph.table_nodes[action_id]
            # $ O(N nodes by action) $
            #! [for] $ O(N) $
            for (node_id, node) in dict
                if !haskey(actual_dict, node_id)
                    actual_dict[node_id] = node
                else
                    actual_node = actual_dict[node_id]
                    PathNode.join!(actual_node, node)
                end
            end
        end
    end
end

# $ O(N^3) $
function join_lines!(graph :: Graph, graph_join :: Graph)
    # O(N) steps * each line can have $ O(N^2) $ nodes
    #! [for] $ O(N) $
    for (step, nodes) in graph_join.table_lines
        union!(graph.table_lines[step], nodes)
    end
end

# $ O(N^3) $
function join_color_nodes!(graph :: Graph, graph_join :: Graph)
    # each color $ O(N) $
    #! [for] $ O(N) $
    for (color, nodes) in graph_join.table_color_nodes
        if !haskey(graph.table_color_nodes, color)
            graph.table_color_nodes[color] = NodesIdSet()
        end
        # union of set of ids nodes same color
        # $ O(N^2) $
        #! [fixed] $ O(N*N) $
        union!(graph.table_color_nodes[color], nodes)
    end
end

# $ O(N^4) $
function join_edges!(graph :: Graph, graph_join :: Graph)
    #??$ O(N^3) nodes * O(N) edges = O(N^4) $
    #! [for] $ O(N*N*N*N) $
    for (edge_id, edge) in graph_join.table_edges
        if !haskey(graph.table_edges, edge_id)
            graph.table_edges[edge_id] = edge
        end
    end
end

function is_valid_join(graph :: Graph, graph_join :: Graph)
    is_eq_step = graph.next_step == graph_join.next_step
    is_eq_origin = graph.color_origin == graph_join.color_origin
    is_both_valid = graph.valid && graph_join.valid
    is_eq_action_parent = graph.action_parent_id == graph_join.action_parent_id

    is_both_valid && is_eq_step && is_eq_origin && is_eq_action_parent
end

function join_max_stages_review!(graph :: Graph, graph_join :: Graph)
    graph.max_review_stages = max(graph.max_review_stages, graph_join.max_review_stages)
end
