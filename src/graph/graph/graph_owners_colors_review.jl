# O(N^2)
function load_all_colors_node_step_at_review_owners(graph :: Graph, step :: Step, node :: Node) :: SetColors
    colors :: SetColors = SetColors()

    # $ O(N^2) $
    #! [for] $ O(N*N) $
    for node_id in graph.table_lines[step]
        if Owners.have(node.owners, step, node_id)
            node_owner = PathGraph.get_node(graph, node_id)

            if node_owner.owners.valid
                push!(colors, node_owner.color)
            end
        end
    end

    return colors
end

# $ O(N) $
function filter_if_incoherence_enough_color!(n :: Color, step :: Step, colors_step :: SetColors, set_all_colors :: SetColors) :: Bool
    should_be_filter = false
    # $ O(N) $
    union!(set_all_colors, colors_step)
    number_of_possible_colors = length(set_all_colors)
    # I shouldn´t filter the return to origin node
    number_color_required_step = Int64(min(n, step+1))
    if number_of_possible_colors < number_color_required_step
        should_be_filter = true
    end

    return should_be_filter
end

function is_fixed_color_step(n :: Color, step :: Step, colors_step :: SetColors) :: Bool
    #! [fixed] $ O(N) $
    return length(colors_step) == 1 && n > step+1
end

# $ O(N) $
function filter_if_incoherence_fixed_color!(n :: Color, step :: Step, colors_step :: SetColors, set_fixed_colors :: SetColors) :: Bool
    should_be_filter = false

    if is_fixed_color_step(n, step, colors_step)
        fixed_color_in_step = first(colors_step)

        #! [fixed] $ O(N) $
        is_fixed_color_in_previous_step = fixed_color_in_step in set_fixed_colors

        if is_fixed_color_in_previous_step
            should_be_filter = true
        else
            push!(set_fixed_colors, fixed_color_in_step)
        end
    end

    return should_be_filter
end

# Date inclusion 10/Nov/2021
function filter_owners_repeat_fixed_colors!(graph :: Graph, node :: Node, set_fixed_colors :: SetColors) :: Bool
    #! [for] $ O(N) $
    for step in Step(0):Step(graph.next_step-1)
        colors_step = SetColors()
        incoherente_owners = NodesIdSet()

        #! [for] $ O(N*N) $
        for node_id in graph.table_lines[step]
            if Owners.have(node.owners, step, node_id)
                node_owner = PathGraph.get_node(graph, node_id)
                push!(colors_step, node_owner.color)

                #! [fixed] $ O(N) $
                owner_have_conflict_color = node_owner.color in set_fixed_colors
                if node_owner.owners.valid && owner_have_conflict_color
                    push!(incoherente_owners, node_id)
                end
            end
        end

        #! [fixed] $ O(N) $
        is_fixed_color_step = length(colors_step) == 1
        if !is_fixed_color_step
            should_be_filter = clear_incoherent_owners!(graph, node, step, incoherente_owners)
            if should_be_filter
                return true
            end
        end
    end

    return false
end

function clear_incoherent_owners!(graph :: Graph, node :: Node, step :: Step, incoherente_owners :: NodesIdSet) :: Bool
    if !isempty(incoherente_owners)
        #! [for] $ O(N*N) $
        for node_id in incoherente_owners
            node_owner = PathGraph.get_node(graph, node_id)

            PathNode.pop_owner!(node, node_owner)
            PathNode.pop_owner!(node_owner, node)

            if !node_owner.owners.valid
                save_to_delete_node!(graph, node_id)
            end

            if !node.owners.valid
                return true
            end
        end

        is_step_parents = node.step-1 == step
        is_step_sons = node.step+1 == step

        if is_step_parents
            remove_sons_edges_arent_owner_node!(graph, node)
        end

        if is_step_sons
            remove_parents_edges_arent_owner_node!(graph, node)
        end

    end

    return false
end
