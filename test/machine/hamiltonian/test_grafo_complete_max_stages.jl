function test_grafo_complete_max_stages(n)
   n = Color(n)
   graf = GrafGenerator.completo(n)

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)

   println("## Calc. K$n...")
   HalMachine.execute!(machine)

   graph_join = SolutionGraphReader.get_graph_join_origin(machine)
   graph_join.max_review_stages = 0

   init_total_nodes = count_total_nodes(graph_join)
   total_manual_deleting = 0
   expected_tour = [0]

   for step_and_target in 1:n-1
      step = Step(step_and_target)
      color_target = Color(step_and_target)
      push!(expected_tour, color_target)

      println("# step_and_target: $step_and_target")
      all_are_target_color = false
      while !all_are_target_color

         all_are_target_color = true
         for node_id in PathGraph.get_line_nodes(graph_join, step)
            node = PathGraph.get_node(graph_join, node_id)

            if graph_join.valid && node.color != color_target
               println("# Delete & Review... $(node_id.key) ")
               total_manual_deleting += 1
               PathGraph.save_to_delete_node!(graph_join, node_id)
               PathGraph.apply_node_deletes!(graph_join)
               PathGraph.review_owners_all_graph!(graph_join)
               all_are_target_color = false
               break
            end
         end
      end
   end
   push!(expected_tour, Color(0))
   final_total_nodes = count_total_nodes(graph_join)
   @test final_total_nodes == n+1
   ratio_manual_vs_review = round((total_manual_deleting/init_total_nodes)*100,digits = 3)

   println("### After.. Manual Cleaning... ###")
   println("valid: $(graph_join.valid) ")
   println("max_review_stages: $(graph_join.max_review_stages)")
   println("------- ----- ----- ----- ---- ----")
   println("init_total_nodes: $init_total_nodes")
   println("final_total_nodes: $final_total_nodes")
   println("total_manual_deleting: $total_manual_deleting")
   println("Ratio manual deleting vs Review: $ratio_manual_vs_review %")
   #Graphviz.to_png(graph_join,"grafo_max_stages_k$n","./machine/hamiltonian/visual_graphs/grafo_max_stages")

   println("## Search solution and plot.. ")
   b = Km(n)
   (tour, path) = PathReader.load!(n, b, graph_join, true)
   println(tour)
   @test path.step == graf.n+1
   @test path.route == expected_tour


   total_manual_deleting

end

function count_total_nodes(graph)
   total = 0
   for (step, nodes_by_line) in graph.table_lines
       total += length(nodes_by_line)
   end
   return total
end

test_grafo_complete_max_stages(4)
