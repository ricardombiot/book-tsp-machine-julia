# Printing debuging with:
#println("[$(path.step)] Selected: $(path.next_node_id.key)")
function fixed_next!(path :: PathSolutionReader)
    node = PathGraph.get_node(path.graph, path.next_node_id)
    path.next_node_id = selected_next(path, node)
end

function selected_next(path :: PathSolutionReader, node :: Node) :: Union{NodeId,Nothing}
    is_valid = path.graph.valid
    have_sons = !isempty(node.sons)

    if is_valid && have_sons
        (node_id, edge_id) = first(node.sons)
        return node_id
    else
        return nothing
    end
end
