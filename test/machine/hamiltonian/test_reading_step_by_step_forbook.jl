function test_reading_step_by_step(n)
    n = Color(n)
    graf = GrafGenerator.completo(n)

    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)

    println("## Calc. K$n...")
    HalMachine.execute!(machine)

    graph_join = SolutionGraphReader.get_graph_join_origin(machine)
    dir_plots = "./machine/hamiltonian/visual_graphs/reading_step_by_step"
    Graphviz.to_png(graph_join,"join_grafo_k$n",dir_plots)

    b = Km(n)
    path = PathReader.new(n, b, graph_join, true)
    PathReader.calc_and_plot!(path, dir_plots)

end

test_reading_step_by_step(5)
