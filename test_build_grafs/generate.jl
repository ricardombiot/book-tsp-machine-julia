include("./../src/main.jl")
include("./build_grafs.jl")


function main(args)
    n = parse(Int128,first(args))
    n = Color(n)
    g = GrafGenerator.cycle(n)


    limit = 10000
    path = "./data/grafs$n"
    mkdir(path)

    builder = Main.BuildGraf.new(g, limit, path)

    Main.BuildGraf.generate_graf!(builder)
end

main(ARGS)
