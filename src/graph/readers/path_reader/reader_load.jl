
function read_and_plot!(n :: Color, b :: Km, graph :: Graph, dir :: String, is_origin_join :: Bool = false) :: PathSolutionReader
    path = new(n, b, graph, is_origin_join)
    calc_and_plot!(path, dir)
    return path
end

function read!(n :: Color, b :: Km, graph :: Graph, is_origin_join :: Bool = false) :: PathSolutionReader
    path = new(n, b, graph, is_origin_join)
    calc!(path)
    return path
end

function load_and_plot!(n :: Color, b :: Km, graph :: Graph, dir :: String, is_origin_join :: Bool = false) :: Tuple{String, PathSolutionReader}
    path = new(n, b, graph, is_origin_join)
    calc_and_plot!(path, dir)
    txt_path = to_string_path(path)
    txt_path = "Longitud: $(path.step) Path: $txt_path"
    return (txt_path, path)
end

function load!(n :: Color, b :: Km, graph :: Graph, is_origin_join :: Bool = false) :: Tuple{String, PathSolutionReader}
    path = new(n, b, graph, is_origin_join)
    calc!(path)
    txt_path = to_string_path(path)
    txt_path = "Longitud: $(path.step) Path: $txt_path"
    return (txt_path, path)
end

function to_string_path(path :: PathSolutionReader) :: String
    txt = ""
    #! [for] $ O(N) $
    for color in path.route
        txt *= "$color, "
    end
    return chop(txt, tail = 2)
end

function to_string_path(path :: PathSolutionReader, map_names :: Dict{Color, String}) :: String
    txt = ""
    #! [for] $ O(N) $
    for color in path.route
        name = map_names[color]
        txt *= "$name($color), "
    end
    return chop(txt, tail = 2)
end
