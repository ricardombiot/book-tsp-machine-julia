include("./../../src/main.jl")
include("./utils.jl")

function main(args)
     n = parse(UInt128,popfirst!(args))
     n = Color(n)
     build_db!(n)
 end

function build_db!(n :: Color)
    if !exists_graph_join(n)
        println("Preparing Graf. K_$n ... ")
        graf = GrafGenerator.completo(n)

        color_origin = Color(0)
        machine = HalMachine.new(graf, color_origin)
        HalMachine.execute!(machine)

        graph_join = SolutionGraphReader.get_graph_join_origin(machine)
        save_graph_join!(graph_join,n)
    end
end




main(ARGS)
