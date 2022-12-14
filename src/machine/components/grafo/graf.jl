module Graf
    using Main.PathsSet.Alias: Color, Weight

    mutable struct Grafo
        count_aristas :: Int64
        n :: Color
        dict :: Dict{Color, Dict{Color, Weight}}
        max_weight :: Weight
    end

    function new( n :: Color)
        dict = Dict{Color, Dict{Color, Weight}}()
        max_weight = Weight(0)
        Grafo(0, n, dict, max_weight)
    end

    function is_valid_index(graf :: Grafo , index :: Color)
        index < graf.n
    end

    function get_nodes(graf :: Grafo) :: Array{Color, 1}
        list = Array{Color, 1}()
        #! [for] $ O(N) $
        for (node, _info) in graf.dict
            push!(list, node)
        end

        return list
    end

    function get_destines(graf :: Grafo , origin :: Color ) :: Union{Dict{Color, Weight},Nothing}
        if is_valid_index(graf, origin) && haskey(graf.dict, origin)
            return graf.dict[origin]
        else
            return Dict{Color, Weight}()
        end
    end

    function destines!( graf :: Grafo , origin :: Color ) :: Union{Dict{Color, Weight},Nothing}
        if is_valid_index(graf, origin)
            if !haskey(graf.dict, origin)
                graf.dict[origin] = Dict{Color, Weight}()
            end

            return graf.dict[origin]
        else
            return nothing
        end
    end

    function add!( graf :: Grafo , origin :: Color, list_destines :: Array{Color, 1}, weight :: Weight = Weight(1))
        #! [for] $ O(N) $
        for destine in list_destines
            add!( graf, origin, destine)
        end
    end

    function add!( graf :: Grafo , origin :: Color,  destine :: Color, weight :: Weight = Weight(1))
        if is_valid_index(graf, origin) && is_valid_index(graf, destine)
            destines_origin = destines!(graf, origin)

            if !haskey(destines_origin, destine)
                graf.count_aristas += 1
            end

            if weight > graf.max_weight
                graf.max_weight = weight
            end

            destines_origin[destine] = weight
        end
    end

    function add_bidirectional!( graf :: Grafo , origin :: Color, list_destines :: Array{Color, 1}, weight :: Weight = Weight(1))
        #! [for] $ O(N) $
        for destine in list_destines
            add_bidirectional!( graf, origin, destine)
        end
    end

    function add_bidirectional!( graf :: Grafo , origin :: Color,  destine :: Color, weight :: Weight = Weight(1))
        add!(graf, origin, destine, weight)
        add!(graf, destine, origin, weight)
    end

    function get_weight(graf :: Grafo , origin :: Color,  destine :: Color) :: Union{Weight, Nothing}
        if is_valid_index(graf, origin) && is_valid_index(graf, destine)
            destines_origin = get_destines(graf, origin)
            if destines_origin != nothing && haskey(destines_origin, destine)
                return destines_origin[destine]
            end
        end

        return nothing
    end


    function have_arista(graf :: Grafo , origin :: Color,  destine :: Color) :: Bool
        weight = get_weight(graf, origin, destine)

        return weight != nothing && weight > 0
    end

    function remove!(graf :: Grafo , origin :: Color,  destine :: Color)
        if is_valid_index(graf, origin) && is_valid_index(graf, destine)
            destines_origin = destines!(graf, origin)
            if haskey(destines_origin, destine)
                delete!(destines_origin, destine)
                graf.count_aristas -= 1
            end
        end
    end

    function remove_bidirectional!(graf :: Grafo , origin :: Color,  destine :: Color)
        remove!(graf, origin, destine)
        remove!(graf, destine, origin)
    end


    function isequal(graf :: Grafo, graf_b :: Grafo) :: Bool
        if graf.n != graf_b.n
            return false
        end

        #! [for] $ O(N) $
        for origen=0:graf.n-1
            #! [for] $ O(N) $
            for destino=0:graf.n-1
                weight_a = get_weight(graf, Color(origen),  Color(destino))
                weight_b = get_weight(graf, Color(origen),  Color(destino))

                if weight_a != weight_b
                    return false
                end
            end
        end

        return true
    end

end
