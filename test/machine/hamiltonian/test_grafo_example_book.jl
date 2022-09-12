function create_grafo()
   n = Color(4)
   g = Graf.new(n)
   Graf.add_bidirectional!(g, Color(0), Color(1))
   Graf.add_bidirectional!(g, Color(0), Color(2))

   Graf.add_bidirectional!(g, Color(1), Color(2))
   Graf.add_bidirectional!(g, Color(1), Color(3))

   Graf.add_bidirectional!(g, Color(2), Color(1))
   Graf.add_bidirectional!(g, Color(2), Color(3))

   return g
end

function test_join_graph_solution_didactic_example_book()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)


   Graphviz.to_png(graph_join,"didactic_example_book_join_solution","./machine/hamiltonian/visual_graphs/examples_book")

   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
end


function test_exp_exploration_grafo_didactic_example_book()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   limit = UInt128(100)
   b = Km(graf.n)
   reader_exp = PathExpReader.new(graf.n, b, graph_join, limit, true)
   PathExpReader.calc!(reader_exp)

   PathExpReader.print_solutions(reader_exp)

   optimal = Weight(graf.n)
   @test PathChecker.check_all!(graf, reader_exp.paths_solution, optimal)
end

test_join_graph_solution_didactic_example_book()
test_exp_exploration_grafo_didactic_example_book()
