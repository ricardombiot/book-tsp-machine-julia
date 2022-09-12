
function new(n :: Color, b :: Km, color_origin :: Color, action_id :: ActionId)
    next_step = Step(0)
    owners = new_graph_owners(n, b)

    table_nodes = Dict{ActionId, Dict{NodeId, Node}}()
    table_color_nodes = Dict{Color, NodesIdSet}()
    table_lines = Dict{Step, NodesIdSet}()
    table_edges = Dict{EdgeId, Edge}()
    nodes_to_delete = NodesIdSet()

    required_review_owners = false
    valid = true
    action_parent_id = nothing
    max_review_stages = 0

    graph = Graph(n, b, next_step, color_origin, owners,
            table_nodes, table_edges,
            table_lines, table_color_nodes,
            action_parent_id,
            nodes_to_delete, required_review_owners, max_review_stages, valid)

    init!(graph, action_id)
    return graph
end

function new_graph_owners(n :: Color, b :: Km) :: OwnersByStep
    # If we want be able to close the cycles,
    # we need space for make a UP to origin,
    # then, we need add one more
    b = b + 1
    n = n + 1

    bbnnn :: UniqueNodeKey = b^2*n^3
    return Owners.new(bbnnn)
end
