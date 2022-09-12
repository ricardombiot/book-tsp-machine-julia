

function build_reader_exp(graph_join :: Graph)
    n = graph_join.n
    limit = UInt128(factorial(n-1))
    reader_exp = PathExpReader.new(n, Km(n), graph_join, limit, true)
    PathExpReader.calc!(reader_exp)
    return reader_exp
end

function show_all_solutions(reader_exp)
    solutions_expected = PathExpReader.to_string_solutions(reader_exp)
    println(solutions_expected)
end
