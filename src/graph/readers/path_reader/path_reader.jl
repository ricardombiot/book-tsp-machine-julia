module PathReader
    using Main.PathsSet.Alias: Km, Step, Color, ActionId

    using Main.PathsSet.PathGraph
    using Main.PathsSet.PathGraph: Graph

    using Main.PathsSet.NodeIdentity
    using Main.PathsSet.NodeIdentity: NodeId
    using Main.PathsSet.PathNode: Node
    using Main.PathsSet.Owners
    using Main.PathsSet.Owners: OwnersByStep

    using Main.PathsSet.Graphviz

    mutable struct PathSolutionReader
        step :: Step
        route :: Array{Color, 1}
        next_node_id :: Union{NodeId, Nothing}

        graph :: Graph
        is_origin_join :: Bool
    end

    include("./reader_constructor.jl")
    include("./reader_next_step.jl")
    include("./reader_selection.jl")
    include("./reader_reduce_graph.jl")
    include("./reader_calc_and_plot.jl")
    include("./reader_load.jl")

end
