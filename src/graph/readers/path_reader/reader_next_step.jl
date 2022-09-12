function calc!(path :: PathSolutionReader)
    #! [recursive-if] $ O(N) $
    if next_step!(path)
        calc!(path)
    else
        close_path!(path)
    end
end

function close_path!(path :: PathSolutionReader)
    if !path.is_origin_join
        push!(path.route, path.graph.color_origin)
        path.step += 1
    end
end

function next_step!(path :: PathSolutionReader) :: Bool
    is_finished = path.next_node_id == nothing
    if !is_finished
        push_step!(path)
        fixed_next!(path)
        clear_graph_by_owners!(path)
        return true
    else
        return false
    end
end

# Printing debuging with:
#println("[$(path.step)] Push step: $(path.next_node_id.key) ($(node.color))")
function push_step!(path :: PathSolutionReader)
    node = PathGraph.get_node(path.graph, path.next_node_id)
    push!(path.route, node.color)

    path.step += 1
end
