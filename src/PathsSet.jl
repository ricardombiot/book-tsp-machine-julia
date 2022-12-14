module PathsSet

    #include("utils/alias.jl")
    # Was design with 64 bits...
    include("utils/alias_64bits.jl")
    # For reduce memory usage, we recomend use 32 bits...
    #include("utils/alias_32bits.jl")

    include("utils/generator_ids.jl")

    include("fbset/FBSet128.jl")
    include("fbset/FBSet.jl")

    include("graph/components/node_identity/node_identity.jl")
    include("graph/components/edge_identity/edge_identity.jl")
    #include("graph/components/owners/owners_set.jl")
    include("graph/components/owners/owners_set_notbinary.jl")
    include("graph/components/owners/owners.jl")
    include("graph/components/node/node.jl")
    include("graph/components/edge/edge.jl")
    include("graph/graph/path_graph.jl")
    include("graph/graphviz/graphviz.jl")
    include("graph/readers/path_reader/path_reader.jl")
    include("graph/readers/path_exp_reader/path_exp_reader.jl")


    include("actions/actions.jl")
    include("actions/database_actions.jl")
    include("actions/database_actions_disk.jl")
    include("actions/database_actions_multithread.jl")
    include("actions/database_interface.jl")
    include("actions/database_memory_controller.jl")
    include("actions/database_memory_controller_disk.jl")
    include("actions/execute.jl")

    include("machine/components/grafo/graf.jl")
    include("machine/components/grafo/graf_generator.jl")
    include("machine/components/grafo/graf_writer.jl")

    include("machine/components/timeline/timeline_cell.jl")
    include("machine/components/timeline/timeline_table.jl")
    include("machine/components/timeline/table_disk/timeline_table_disk.jl")

    include("machine/components/jumper/machine_jumper.jl")

    include("machine/machines/hamiltonian/hal_machine.jl")
    include("machine/machines/tsp/tsp_machine/tsp_machine.jl")
    include("machine/machines/tsp/parallel_tsp_machine/parallel_tsp_machine.jl")
    include("machine/machines/tsp/tsp_machine_parallel.jl")

    include("machine/machines/tsp_disk/tsp_machine_disk_info.jl")
    include("machine/machines/tsp_disk/tsp_machine_disk/tsp_machine_disk.jl")

    include("machine/machines/subset_sum/subset_sum_program.jl")
    include("machine/machines/subset_sum/subset_sum_machine.jl")
    include("machine/machines/subset_sum/subset_sum_solver.jl")

    include("machine/readers/imachine.jl")
    include("machine/readers/solution_graph_reader.jl")
    include("machine/readers/path_checker.jl")

    include("machine/testing/tsp_brute_force/tsp_brute_force.jl")
    include("machine/testing/tsp_brute_force/tsp_brute_force_parallel.jl")
    include("machine/testing/hal_brute_force.jl")
    include("machine/testing/space_inspector.jl")


end # module
