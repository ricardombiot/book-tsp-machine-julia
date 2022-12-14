function create_grafo()
   n = Color(4)
   g = Graf.new(n)
   Graf.add_bidirectional!(g, Color(0), Color(1))
   Graf.add_bidirectional!(g, Color(0), Color(3))

   Graf.add_bidirectional!(g, Color(1), Color(2))
   Graf.add_bidirectional!(g, Color(1), Color(3))

   Graf.add_bidirectional!(g, Color(2), Color(3))

   return g
end

function test_hal_grafo_slices()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calculating Graph Simple")
   HalMachine.execute!(machine)

   graph = SolutionGraphReader.get_one_solution_graph(machine)
   #println(graph)

   Graphviz.to_png(graph,"solucion_grafo_slices","./machine/hamiltonian/visual_graphs/grafo_slices")

   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
end

function test_multiples_solutions_grafo_slices()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)

   b = Km(graf.n)
   for (parent_id, graph) in SolutionGraphReader.get_all_solution_graph(machine)
      Graphviz.to_png(graph,"sol$parent_id","./machine/hamiltonian/visual_graphs/grafo_slices")

      (tour, path) = PathReader.load!(graf.n, b, graph)
      println(tour)
      @test path.step == graf.n+1

      optimal = Weight(graf.n)
      checker = PathChecker.new(graf, path, optimal)
      @test PathChecker.check!(checker)
   end

end


function test_join_graph_solution_grafo_slices()
   graf = create_grafo()

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   HalMachine.execute!(machine)
   graph_join = SolutionGraphReader.get_graph_join_origin(machine)


   Graphviz.to_png(graph_join,"join_solution","./machine/hamiltonian/visual_graphs/grafo_slices")

   b = Km(graf.n)
   (tour, path) = PathReader.load!(graf.n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1

   optimal = Weight(graf.n)
   checker = PathChecker.new(graf, path, optimal)
   @test PathChecker.check!(checker)
end


function test_exp_exploration_grafo_slices()
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

test_hal_grafo_slices()
#test_multiples_solutions_grafo_slices()
test_join_graph_solution_grafo_slices()
#test_exp_exploration_grafo_slices()
