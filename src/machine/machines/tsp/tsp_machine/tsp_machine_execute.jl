function execute!(machine :: TravellingSalesmanMachine)
    # TSP: $ O(B) $
    # Hamiltonian: B=N then $ O(N) $
    #! [recursive-if] $ O(B) $
    if make_step!(machine)
        km_halt = km_target(machine)
        println("#KM: $(machine.actual_km)/$(km_halt)")
        execute!(machine)
    end
end

function make_step!(machine :: TravellingSalesmanMachine) :: Bool
    if !rules_to_halt_machine(machine)
        execute_line!(machine)
        free_memory!(machine)
        machine.actual_km += Km(1)
        return true
    else
        return false
    end
end

function free_memory!(machine :: TravellingSalesmanMachine)
    if machine.actual_km > 1
        db_controller = machine.db_controller
        clear_km = machine.actual_km - Km(1)
        db = machine.db
        DatabaseMemoryController.free_memory_actions_step!(db_controller, clear_km, db)
        TableTimeline.remove!(machine.timeline, clear_km)
        #println(" Free memory km: $(clear_km)")
    end
end

function rules_to_halt_machine(machine :: TravellingSalesmanMachine) :: Bool
    km_to_halt = km_target(machine)
    return km_to_halt == machine.actual_km
end

function km_target(machine :: TravellingSalesmanMachine) :: Km
    if machine.km_solution_recived == nothing
        return machine.km_b
    else
        return min(machine.km_solution_recived, machine.km_b)
    end
end

function execute_line!(machine :: TravellingSalesmanMachine)
    line = TableTimeline.get_line(machine.timeline, machine.actual_km)
    if line != nothing
        #! [for] $ O(N) $
        for (origin, cell) in line
            (is_valid, action_id) = execute_timeline_cell_by_origin!(machine, origin)
            #println("Execute KM:$(machine.actual_km) Cell: $origin -> OP: $action_id ($is_valid)")
            if is_valid
                send_destines!(machine, origin)
            else
                controller_register_action_to_remove!(machine, action_id)
            end
        end
    end
end

function controller_register_action_to_remove!(machine :: TravellingSalesmanMachine, action_id :: ActionId)
    # If the action is not sent to anyone it is recorded to be deleted in the next step.
    DatabaseMemoryController.register!(machine.db_controller, action_id, machine.actual_km)
end

function execute_timeline_cell_by_origin!(machine :: TravellingSalesmanMachine , origin :: Color) :: Tuple{Bool, Union{ActionId,Nothing}}
    return TableTimeline.execute!(machine.timeline, machine.db, machine.actual_km, origin)
end
