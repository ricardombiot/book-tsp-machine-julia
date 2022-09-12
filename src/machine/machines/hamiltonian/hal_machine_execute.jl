function execute!(machine :: HamiltonianMachine)
    # TSP: $ O(B) $
    # Hamiltonian: B=N then $ O(N) $
    #! [recursive-if] $ O(N) $
    if make_step!(machine)
        println("#KM: $(machine.actual_km)/$(machine.n)")
        execute!(machine)
    end
end

function make_step!(machine :: HamiltonianMachine) :: Bool
    if machine.actual_km < machine.n
        execute_line!(machine :: HamiltonianMachine)
        free_memory!(machine)
        machine.actual_km += Km(1)
        return true
    else
        return false
    end
end

function execute_line!(machine :: HamiltonianMachine)
    line = TableTimeline.get_line(machine.timeline, machine.actual_km)
    if line != nothing
        #! [for] $ O(N) $
        for (origin, cell) in line
            if if_valid_origin_execute_timeline_cell!(machine, origin)
                send_destines!(machine, origin)
            end
        end
    end
end

function if_valid_origin_execute_timeline_cell!(machine :: HamiltonianMachine, origin :: Color) :: Bool
    if is_valid_origin(machine, origin)
        (is_valid, action_id) = execute_timeline_cell_by_origin!(machine, origin)
        #println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
        return is_valid
    else
        return false
    end
end

function execute_timeline_cell_by_origin!(machine :: HamiltonianMachine, origin :: Color) :: Tuple{Bool, Union{ActionId,Nothing}}
    return TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)
end


function is_valid_origin(machine :: HamiltonianMachine, origin :: Color) :: Bool
    ## En el ultimo caso solo calculo si tiene como destine color_origin
    if Km(machine.actual_km) == Km(machine.n-1)
        have_arista_to_origin = Graf.have_arista(machine.graf, origin,  machine.color_origin)
        #println("# Before end check origin: $origin ($have_arista_to_origin)")
        return have_arista_to_origin
    else
        return true
    end
end


function free_memory!(machine :: HamiltonianMachine)
    if machine.actual_km > 1
        db_controller = machine.db_controller
        clear_km = machine.actual_km - Km(1)
        db = machine.db
        DatabaseMemoryController.free_memory_actions_step!(db_controller, clear_km, db)
        TableTimeline.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end
