
# Maximum theoretical $ O(N^{10}) $
# Most probable less than N stages: $ O(N^8) $
# $ O(Stages) * O(N^7) $
function review_owners_all_graph!(graph :: Graph)
    recursive_review_owners_all_graph!(graph, 1)
end

function save_max_review_stages!(graph :: Graph, stage :: Int64)
    #=
    if stage > graph.n
        println("-> Expensive review more than N.")
    elseif stage >= 1
        println("-> Stages: $stage >= 1.")
    end
    =#
    graph.max_review_stages = max(graph.max_review_stages, stage)
end

# Theoretical Maximum Cost of execution $ O(N^7) * O(stages) $
# Theoretical:
# If we would execute it after remove each node $ O(N^3) * O(N^7) = O(N^10) $
# but in the practise we execute it at least deleting all nodes of a color
# each delete node can produce a propation deleting, and before of delete all nodes of
# graph will detected this situation with the owners.
function recursive_review_owners_all_graph!(graph :: Graph, stage :: Int64)
    # It is important see that the number of executions dependes of the deletes stages required
    # to be valid or invalid graph, that at the same time depends of the instance
    # but in all cases follow a polynomial function.
    # -yes, polynomial expensive function, but polynomial be-

    #! [recursive-if] $ O(N*N*N) $
    if graph.valid && graph.required_review_owners
        save_max_review_stages!(graph, stage)

        # $ O(N^3) $
        rebuild_owners!(graph)
        # $ O(N^7) $
        review_owners_nodes_and_relationships!(graph)

        graph.required_review_owners = false
        if graph.valid && !isempty(graph.nodes_to_delete)
            graph.required_review_owners = true
            apply_node_deletes!(graph)
            recursive_review_owners_all_graph!(graph, stage + 1)
        end
    end
end

# $ O(N^3) $
function rebuild_owners!(graph :: Graph)
    owners_new = Owners.empty_derive(graph.owners)
    # $ O(N) $ steps
    #! [for] $ O(N) $
    for step in Step(0):Step(graph.next_step-1)
        if haskey(graph.table_lines, step)
            nodes = graph.table_lines[step]
            # $ O(N^2) $  nodes by step
            #! [for] $ O(N*N) $
            for node_id in nodes
                Owners.push!(owners_new, step, node_id)
            end
        end
    end

    graph.owners = owners_new
    make_validation_graph_by_owners!(graph)
end

#=
Down to top
1. filter_by_intersection_owners!
2. filter_by_sons_intersection_owners!
3. filter_by_incoherence_colors!
4. filtering_sons_using_parents_interection_owners!
=#
function review_owners_nodes_and_relationships!(graph :: Graph)
    if graph.valid && graph.required_review_owners
        step = graph.next_step - Step(1)
        stop_while = false
        # $ O(N) steps $
        #! [while] $ O(N) $
        while !stop_while
            # $ O(N^2) $ nodes by step
            #! [for] $ O(N*N) $
            for node_id in graph.table_lines[Step(step)]
                node = get_node(graph, node_id)

                if !node.owners.valid
                    save_to_delete_node!(graph, node_id)
                elseif filter_by_intersection_owners!(node, graph.owners)
                    save_to_delete_node!(graph, node_id)
                elseif filter_by_sons_intersection_owners!(graph, node)
                    save_to_delete_node!(graph, node_id)
                elseif filter_by_incoherence_colors!(graph, node)
                    save_to_delete_node!(graph, node_id)
                end
            end

            if !isempty(graph.nodes_to_delete)
                filtering_sons_using_parents_interection_owners!(graph, step)
            end

            if step == Step(0) || !graph.valid
                stop_while = true
            else
                step -= Step(1)
            end
        end
    end
end

# $ O(N^3) $
function filter_by_intersection_owners!(node :: Node, owners :: OwnersByStep) :: Bool
    PathNode.intersect_owners!(node, owners)

    return !node.owners.valid
end


# $ O(N^6) $
# Date inclusion 7/5/2021
function filtering_sons_using_parents_interection_owners!(graph :: Graph, step :: Step)
    #last_step = graph.next_step - Step(1)
    first_step = Step(0)
    #if step != last_step && graph.valid
    if step != first_step && graph.valid
        # $ O(N^2) $ nodes by step
        #! [for] $ O(N*N) $
        for node_id in graph.table_lines[Step(step)]
            node = get_node(graph, node_id)

            if node.owners.valid
                # $ O(N^4) $
                if filter_by_parents_intersection_owners!(graph, node)
                    #println("Filter by parents intersection")
                    save_to_delete_node!(graph, node_id)
                end
            end
        end
    end
end
# $ O(N^4) $
function filter_by_sons_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    last_step = Step(graph.next_step-1)
    if node.step != last_step
        owners_sons_union :: Union{OwnersByStep,Nothing} = nothing

        #! [for] $ O(N) $
        for (son_node_id, edge_id) in node.sons
            son_node = get_node(graph, son_node_id)

            if son_node.owners.valid
                if owners_sons_union == nothing
                    owners_sons_union = deepcopy(son_node.owners)
                else
                    # $ O(N) Steps * O(N^2) = O(N^3) $
                    Owners.union!(owners_sons_union, son_node.owners)
                end
            end
        end

        if owners_sons_union == nothing
            return true
        elseif owners_sons_union.valid
            PathNode.intersect_owners!(node, owners_sons_union)
            if !node.owners.valid
                return true
            else
                if node.step != Step(0)
                    remove_parents_edges_arent_owner_node!(graph, node)
                end

                return false
            end
        else
            # Reviewing 4/oct/2021 - If owners no valid then filter;
            return false
        end
    else
        return false
    end
end

# $ O(N^4) $
function filter_by_parents_intersection_owners!(graph :: Graph, node :: Node) :: Bool
    first_step = Step(0)
    if node.step != first_step
        owners_parents_union :: Union{OwnersByStep,Nothing} = nothing

        #! [for] $ O(N) $
        for (parent_node_id, edge_id) in node.parents
            parent_node = get_node(graph, parent_node_id)

            if parent_node.owners.valid
                if owners_parents_union == nothing
                    owners_parents_union = deepcopy(parent_node.owners)
                else
                    # $ O(N) Steps * O(N^2) Nodes by Step = O(N^3) Owners $
                    Owners.union!(owners_parents_union, parent_node.owners)
                end
            end
        end

        if owners_parents_union == nothing
            return true
        elseif owners_parents_union.valid
            PathNode.intersect_owners!(node, owners_parents_union)
            if !node.owners.valid
                return true
            else
                if node.step != Step(0)
                    remove_sons_edges_arent_owner_node!(graph, node)
                end

                return false
            end
        else
            # Reviewing 4/oct/2021 - If owners no valid then filter;
            return false
        end
    else
        return false
    end
end

# $ O(N^3) $
function filter_by_incoherence_colors!(graph :: Graph, node :: Node) :: Bool
    set_all_colors = SetColors()
    set_fixed_colors = SetColors()

    #! [for] $ O(N) $
    for step in Step(0):Step(graph.next_step-1)
        colors_step = load_all_colors_node_step_at_review_owners(graph, step, node)

        if filter_if_incoherence_fixed_color!(graph.n, step, colors_step, set_fixed_colors)
            return true
        end

        if filter_if_incoherence_enough_color!(graph.n, step, colors_step, set_all_colors)
            return true
        end
    end

    if !isempty(graph.nodes_to_delete)
        return filter_owners_repeat_fixed_colors!(graph, node, set_fixed_colors)
    end

    return false
end

function remove_parents_edges_arent_owner_node!(graph :: Graph, node :: Node)
    #! [for] $ O(N) $
    for (origin_id, edge_id) in node.parents

        node_parent = get_node(graph, origin_id)
        if !PathNode.have_owner(node, node_parent)
            delete_edge_by_id!(graph, edge_id)
        end
    end
end


function remove_sons_edges_arent_owner_node!(graph :: Graph, node :: Node)
    #! [for] $ O(N) $
    for (destine_id, edge_id) in node.sons

        node_son = get_node(graph, destine_id)
        if !PathNode.have_owner(node, node_son)
            delete_edge_by_id!(graph, edge_id)
        end
    end
end
