#include("./../src/main.jl")
include("./solver.jl")
using Test
using Dates

function main(args)
    n = parse(UInt128,popfirst!(args))
    n = Color(n)

    graf = GrafGenerator.dirgraf_random(n, -1, 1)
    #println(graf)

    (time_execution_original, graph_join_original) = halmiltonian_machine_solver(graf)
    (time_execution_improve, graph_join_improve) = improve_solver(graf)

    if graph_join_original == nothing
        println("Original [Nothing] in $time_execution_original")
    else
        println("Original [OK] in $time_execution_original")
    end

    if graph_join_improve == nothing
        println("Improve [Nothing] in $time_execution_improve")
    else
        println("Improve [OK] in $time_execution_improve")
    end

    if graph_join_improve == nothing || graph_join_original == nothing
        if graph_join_improve != graph_join_original
            throw("Error... Incoherent Answer... ")
        end
    else
        #println("Printing...")
        #Graphviz.to_png(graph_join_original,"join_solution_original","./visual_testing")
        #Graphviz.to_png(graph_join_original,"join_solution_improve","./visual_testing")



        limit = UInt128(factorial(n-1))
        reader_exp = PathExpReader.new(n, Km(n), graph_join_original, limit, true)
        println("## Solutions Original ##")
        PathExpReader.calc!(reader_exp)
        solutions_expected = PathExpReader.to_string_solutions(reader_exp)
        println(solutions_expected)

        reader_exp_improve = PathExpReader.new(n, Km(n), graph_join_improve, limit, true)
        println("## Solutions Improve ##")
        PathExpReader.calc!(reader_exp_improve)
        solutions_calc = PathExpReader.to_string_solutions(reader_exp_improve)
        println(solutions_calc)

        set_solutions_expected = Set(split(solutions_expected,"\n"))
        set_solutions_calc = Set(split(solutions_calc,"\n"))

        @test set_solutions_calc == set_solutions_expected

        total_solutions_expected = length(delete!(set_solutions_expected,"\n"))
        total_solutions_calc = length(delete!(set_solutions_calc,"\n"))
        println("## -----  ----  ----  ----  ---- ##")
        println("## Total. Solutions Expected $total_solutions_expected ##")
        println("## Total. Solutions Improve $total_solutions_calc ##")
    end
end



function improve_solver(graf :: Grafo) :: Tuple{Millisecond,Union{Graph, Nothing}}
    time = now()
    graph_join = solver(graf)
    time_execute = now() - time
    return (time_execute, graph_join)
end

function halmiltonian_machine_solver(graf :: Grafo) :: Tuple{Millisecond,Union{Graph, Nothing}}
    time = now()
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    HalMachine.execute!(machine)

    graph_join = SolutionGraphReader.get_graph_join_origin(machine)
    time_execute = now() - time
    return (time_execute, graph_join)
end

main(ARGS)
