module HalBruteForce
    using Main.PathsSet.Alias: Km, Color, Weight

    using Main.PathsSet.Graf
    using Main.PathsSet.Graf: Grafo

    mutable struct HalBruteMachine
        n :: Color
        graf :: Grafo
        origin_color :: Color
        current_route :: Array{Color, 1}
        list_solutions :: Set{Array{Color, 1}}
        is_finished :: Bool
        limit :: Union{Nothing,Int64}
    end

    function new(graf :: Grafo, limit = nothing) :: HalBruteMachine
        n = graf.n
        origin_color = Color(0)
        current_route = Array{Color, 1}()
        list_solutions = Set{Array{Color, 1}}()
        is_finished = false

        brute_machine = HalBruteMachine(n, graf, origin_color, current_route, list_solutions, is_finished, limit)
        init!(brute_machine)
        return brute_machine
    end

    function init!(brute_machine :: HalBruteMachine)
        n = brute_machine.n
        current_route = Array{Color, 1}()
        push!(current_route, Color(0))
        for color=1:n-1
            push!(current_route, Color(color))
        end
        push!(current_route, Color(0))
        brute_machine.current_route = current_route
    end

    function execute!(brute_machine :: HalBruteMachine)
        step = 0
        while !brute_machine.is_finished
            #println("Step: $step")
            #println(brute_machine.current_route)
            calc_step!(brute_machine)
            step += 1
        end
    end

    function calc_step!(brute_machine :: HalBruteMachine)
        if !brute_machine.is_finished
            if_valid_route_saved_it!(brute_machine)
            next_route!(brute_machine)
        end
    end

    function if_valid_route_saved_it!(brute_machine :: HalBruteMachine)
        if check_route(brute_machine)
            #println("Saved solution!")
            push!(brute_machine.list_solutions,deepcopy(brute_machine.current_route))
            if brute_machine.limit != nothing
                brute_machine.limit -= 1
                if brute_machine.limit == 0
                    brute_machine.is_finished = true
                end
            end
        end
    end

    function next_route!(brute_machine :: HalBruteMachine)
        if !brute_machine.is_finished
            n = brute_machine.n
            inc_index = Int64(n)

            is_finished = true
            while inc_index != 1
                value = brute_machine.current_route[inc_index]
                if value < Color(n-1)
                    value += 1
                    brute_machine.current_route[inc_index] = Color(value)
                    inc_index = 1
                    is_finished = false
                elseif value == Color(n-1)
                    brute_machine.current_route[inc_index] = Color(0)
                    inc_index -= 1
                end
            end

            brute_machine.is_finished = is_finished
        end
    end

    function check_route(brute_machine :: HalBruteMachine) :: Bool
        without_repeats = length(Set(brute_machine.current_route)) == brute_machine.n

        if without_repeats
            n = brute_machine.n
            for index=2:Int64(n)
                origin = brute_machine.current_route[index-1]
                destine = brute_machine.current_route[index]

                if !Graf.have_arista(brute_machine.graf, origin,  destine)
                    return false
                end
            end

            return true
        else
            return false
        end
    end

end
