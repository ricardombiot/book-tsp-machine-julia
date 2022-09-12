include("./solver.jl")


function main()
    draw_graph_join_original()
    draw_graph_join_trasformation()
end

function draw_graph_join_trasformation()
    graf = grafo_example_book()
    graph_join = solver(graf)

    reader_exp = build_reader_exp(graph_join)
    println("# Solutions after Trasformation #")
    show_all_solutions(reader_exp)

    Graphviz.to_png(graph_join,"example_book_spaik_trasformation","./visual_testing")
end

function draw_graph_join_original()
    n = Color(4)
    graph_join_original = get_graph_join(n)
    reader_exp = build_reader_exp(graph_join_original)
    println("# Solutions Original #")
    show_all_solutions(reader_exp)
    Graphviz.to_png(graph_join_original,"example_book_spaik_complete$n","./visual_testing")
end

function grafo_example_book()
    n = Color(4)
    g = Graf.new(n)

    Graf.add!(g, Color(0), [Color(1), Color(3)])
    Graf.add!(g, Color(1), [Color(0), Color(2), Color(3)])
    Graf.add!(g, Color(2), [Color(0), Color(1), Color(2), Color(3)])
    Graf.add!(g, Color(3), [Color(0), Color(1), Color(2)])

    return g
end

main()
