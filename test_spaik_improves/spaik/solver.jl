include("./../../src/main.jl")
include("./utils.jl")
include("./reader.jl")
using Serialization



function solver(graf :: Grafo) :: Union{Nothing,Graph}
    n = graf.n
    graph_join = get_graph_join(n)
    #clean_graph_join!(graf, graph_join)
    if clean_graph_join_of_incoherences!(graf, graph_join)
        return graph_join
    else
        return nothing
    end
end

function get_graph_join(n :: Color) :: Graph
    if exists_graph_join(n)
        graph_join = restore_graph_path_join(n)
        return graph_join
    else
        throw("Err. We need generate graph_join_$n before...")
    end
end

function clean_graph_join_of_incoherences!(graf :: Grafo, graph_join :: Graph) :: Bool
    list_nodes_to_remove = Array{NodeId,1}()
    owners = deepcopy(graph_join.owners)
    n = graf.n
    b = Km(graf.n)

    for km in 0:n-1
        next_km = km+1
        step = Step(next_km)
        for color_origin in 0:n-1
            action_parent_id = GeneratorIds.get_action_id(n, Km(km), color_origin)
            #println("From [$action_parent_id] (step:$km,color:$color_origin) -> ")
            for color_destine in 0:n-1
                action_id_destine = GeneratorIds.get_action_id(Color(n), Km(next_km), Color(color_destine))
                node_id = NodeIdentity.new(n, b, step, action_id_destine, action_parent_id)
                is_owner = Owners.have(owners, step, node_id)
                is_coherente_action = Graf.have_arista(graf, color_origin, color_destine)
                #println("    to [$action_id_destine] (step:$next_km,color:$color_destine) [Key: $(node_id.key)][Coh: $is_coherente_action]")


                should_be_removed = is_owner && !is_coherente_action
                if should_be_removed
                    #println("Remove owners... (step:$km,color:$color_origin) -> (step:$next_km,color:$color_destine) ")
                    println("Remove node [Key: $(node_id.key)] (step:$km,color:$color_origin) -> (step:$next_km,color:$color_destine) ")
                    Owners.pop!(owners, step, node_id)
                    push!(list_nodes_to_remove, node_id)
                end
            end

        end

    end

    if owners.valid
        #println("Is valid owners... ")
        update_graph_clean_nodes!(graph_join, list_nodes_to_remove)
        return graph_join.valid
    else
        return false
    end
end

function update_graph_clean_nodes!(graph_join :: Graph, list_nodes_to_remove :: Array{NodeId,1})
    for node_id_to_remove in list_nodes_to_remove
        PathGraph.save_to_delete_node!(graph_join, node_id_to_remove)
    end

    PathGraph.apply_node_deletes!(graph_join)
    PathGraph.review_owners_all_graph!(graph_join)
end
