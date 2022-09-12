include("./solver.jl")


function main()
    graf = GrafGenerator.grafo_ciclo_simple()
    graph_join = solver(graf)

    if !isnothing(graph_join)
        println("Is Hamiltonian")
        Graphviz.to_png(graph_join,"join_solution","./visual_testing")
    else
        println("NonHamiltonian")
    end
end

main()
