
function clear_graph_by_owners!(path :: PathSolutionReader)
    if save_all_nodes_dont_selected_line_to_delete!(path)
        PathGraph.apply_node_deletes!(path.graph)
        path.graph.required_review_owners = true
        PathGraph.review_owners_all_graph!(path.graph)
    end
end


# Printing debuging with:
#println("[$(path.step)] Remove node in line... $(node_id.key) ")
function save_all_nodes_dont_selected_line_to_delete!(path :: PathSolutionReader) :: Bool
    nodes_to_delete = 0
    #! [for] $ O(N*N) $
    for node_id in PathGraph.get_line_nodes(path.graph, path.step)
        if node_id != path.next_node_id

            PathGraph.save_to_delete_node!(path.graph, node_id)
            nodes_to_delete += 1
        end
    end

    have_nodes_to_delete = nodes_to_delete > 0
    return have_nodes_to_delete
end
