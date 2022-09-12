using Serialization

function get_path_graph_join(n :: Color)
    path = "./db/graph_join_$n.bin"
    return path
end

function exists_graph_join(n :: Color) :: Bool
    path = get_path_graph_join(n)
    return isfile(path)
end

function save_graph_join!(graph_join :: Graph, n :: Color)
    path = get_path_graph_join(n)
    data = graph_join
    serialize(path, data)
    println("[INFO] Save GraphJoin... $path")
end

function restore_graph_path_join(n :: Color)
    path = get_path_graph_join(n)
    graph_join = deserialize(path)
    return graph_join
end
