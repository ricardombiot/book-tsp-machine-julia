function test_hal_brute_force()
    n = Color(4)
    graf = GrafGenerator.completo(n)

    brute_machine = HalBruteForce.new(graf)

    @test brute_machine.current_route == [Color(0),Color(1),Color(2),Color(3),Color(0)]

    HalBruteForce.calc_step!(brute_machine)
    @test brute_machine.list_solutions == Set([
        [Color(0),Color(1),Color(2),Color(3),Color(0)]
    ])
    @test brute_machine.current_route == [Color(0),Color(1),Color(3),Color(0),Color(0)]


    HalBruteForce.execute!(brute_machine)
    total_solutions = length(brute_machine.list_solutions)
    @test total_solutions == factorial(n-1)
end

function test_hal_brute_force_complete(n :: Color)
    graf = GrafGenerator.completo(n)

    brute_machine = HalBruteForce.new(graf)
    HalBruteForce.execute!(brute_machine)
    total_solutions = length(brute_machine.list_solutions)
    #println("N:$n - total_solutions: $total_solutions")
    @test total_solutions == factorial(n-1)
end

#=
function test_hal_brute_force_dode()
    ## EXTREME SLOWLY...
    graf = GrafGenerator.dodecaedro()

    brute_machine = HalBruteForce.new(graf)
    HalBruteForce.execute!(brute_machine)
    total_solutions = length(brute_machine.list_solutions)
    @test total_solutions == 60
end
=#

test_hal_brute_force()
test_hal_brute_force_complete(Color(6))
test_hal_brute_force_complete(Color(7))
#test_hal_brute_force_dode()
