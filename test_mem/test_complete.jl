include("./../src/main.jl")
using Dates

function execute_hamiltonian_machine(graf)
    color_origin = Color(0)
    machine = HalMachine.new(graf, color_origin)
    time = now()
    HalMachine.execute!(machine)

    graph = SolutionGraphReader.get_one_solution_graph(machine)
    println("## Search solution.. ")
    b = Km(graf.n)
    (tour, path) = PathReader.load!(graf.n, b, graph)
    println(tour)
    if path.step != graf.n+1
        throw("Grave Err.")
    end

    time_execute = now() - time

    return cast_time_to_int64(time_execute)
end

function cast_time_to_int64(ms :: Millisecond) :: Int64
    ms_txt = "$ms"
    ms_txt = replace(ms_txt," milliseconds" => "")
    ms_txt = replace(ms_txt," millisecond" => "")
    #ms = replace("$ms"," milliseconds" => "")
    #ms = replace("$ms"," millisecond" => "")
    parse(Int64,"$ms_txt")
end

function times_to_csv(list_times)
    txt = ""
    while !isempty(list_times)
        time = popfirst!(list_times)
        txt *= "$time"

        if length(list_times) != 0
            txt *= ";"
        end
    end
    return txt
end

function main(args)
     n = parse(UInt128,popfirst!(args))
     iter = parse(UInt128,popfirst!(args))
     n = Color(n)
     println("Preparing Graf. K_$n ... ")
     graf = GrafGenerator.completo(n)
     println("    Graf. K_$n ... [OK] ")

     list_times = []
     for i in 1:iter
         println("Executing Iter: [$i]")
         time_execution = execute_hamiltonian_machine(graf)
         println(" Time: $time_execution ms. [OK]")
         push!(list_times, time_execution)
     end


     report_csv = times_to_csv(list_times)
     #println(report_csv)

     open("./reports_times/times_n$n.part_a.csv", "w") do io
           write(io, report_csv)
     end;
 end


main(ARGS)
