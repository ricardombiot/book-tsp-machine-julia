function test_grafo_complete_calc_sizes(n)
   graf = GrafGenerator.completo(Color(n))

   color_origin = Color(0)
   machine = HalMachine.new(graf, color_origin)


   println("## Calc. K$n...")
   HalMachine.execute!(machine)

   graph_join = SolutionGraphReader.get_graph_join_origin(machine)

   Graphviz.to_png(graph_join,"join_grafo_k$n","./machine/hamiltonian/visual_graphs/grafo_complete")

   expected_max_actions = n^2
   expected_max_nodes = n^3
   expected_max_nodes_by_action = expected_max_nodes/expected_max_actions
   expected_total_edges = n^4
   expected_max_sons_by_node = n
   expected_max_parents_by_node = n
   #Men(O(ϕ)) ≈ N^3 Nodes * N^3 Owners (Cada nodo siendo propietarios del resto)
   



   (max_actions, total_nodes, max_nodes_by_action) = calc_actions_and_nodes(graph_join)
   total_edges = calc_total_edges(graph_join)
   avg_edges_by_node = total_nodes/total_edges

   (total_sons, total_parents, max_sons, max_parents) = calc_parents_and_sons(graph_join)
   max_nodes_line = calc_max_nodes_by_line(graph_join)
   max_nodes_color = calc_max_nodes_by_color(graph_join)


   println("_________________________")
   println("#      Graph. k$n       #")

   println("MAX.ACTIONS: $max_actions/$expected_max_actions ")
   @test max_actions < expected_max_actions
   println("TOTAL.NODES: $total_nodes/$expected_max_nodes")
   @test total_nodes < expected_max_nodes
   println("MAX.NODES BY ACTION: $max_nodes_by_action/$expected_max_nodes_by_action")
   @test max_nodes_by_action < expected_max_nodes_by_action

   # (n-origin-last)*(n-origin) then (n-2)*(n-1)
   println("MAX. NODES (by line): $max_nodes_line")
   println("MAX. NODES (by color): $max_nodes_color")

   println("---   Edges ---")
   println("TOTAL. EDGES: $total_edges/$expected_total_edges")
   println("AVG. EDGES BY NODE: $avg_edges_by_node")
   @test total_edges < expected_total_edges
   println("---    PARENTS & SONS  ---")
   println("TOTAL. SONS: $total_sons")
   @test total_sons == total_edges
   println("TOTAL. PARENTS: $total_parents")
   @test total_sons == total_edges
   println("MAX. SONS (by node): $max_sons/$expected_max_sons_by_node")
   @test max_sons < expected_max_sons_by_node
   println("MAX. PARENTS (by node): $max_parents/$expected_max_parents_by_node")
   @test max_parents < expected_max_parents_by_node



   println("_________________________")


end


function calc_actions_and_nodes(graph_join)
   list_actions_id = keys(graph_join.table_nodes)
   max_actions = length(list_actions_id)

   total_nodes = 0
   max_nodes_by_action = 0
   for action_id in list_actions_id
      list_nodes_id = keys(graph_join.table_nodes[action_id])
      num_nodes = length(list_nodes_id)

      total_nodes += num_nodes
      max_nodes_by_action = max(num_nodes, max_nodes_by_action)

   end

   return (max_actions, total_nodes, max_nodes_by_action)
end

function calc_total_edges(graph_join)
   list_edges_id = keys(graph_join.table_edges)

   total_edges = length(list_edges_id)

   return total_edges
end

function calc_parents_and_sons(graph_join)
   list_actions_id = keys(graph_join.table_nodes)

   total_sons = 0
   total_parents = 0
   max_sons = 0
   max_parents = 0
   for action_id in list_actions_id
      for (node_id, node) in graph_join.table_nodes[action_id]

         num_sons = length(keys(node.sons))
         num_parents = length(keys(node.parents))

         total_sons += num_sons
         total_parents += num_parents

         max_sons = max(max_sons, num_sons)
         max_parents = max(max_parents, num_parents)
      end
   end


   return (total_sons, total_parents, max_sons, max_parents)
end

function calc_max_nodes_by_line(graph_join)
   max_nodes = 0
   for (step, line) in graph_join.table_lines
      num_nodes = length(line)
      max_nodes = max(max_nodes, num_nodes)
   end

   return max_nodes
end

function calc_max_nodes_by_color(graph_join)
   max_nodes = 0
   for (color, set_color) in graph_join.table_color_nodes
      num_nodes = length(set_color)
      max_nodes = max(max_nodes, num_nodes)
   end

   return max_nodes
end

test_grafo_complete_calc_sizes(7)
