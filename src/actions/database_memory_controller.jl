module DatabaseMemoryController
    using Main.PathsSet.Alias: Km, ActionId, ActionsIdSet

    #using Main.PathsSet.DatabaseActions
    #using Main.PathsSet.DatabaseActions: DBActions
    using Main.PathsSet.DatabaseInterface
    using Main.PathsSet.DatabaseInterface: IDBActions

    mutable struct DBMemoryController
        table :: Dict{Km, ActionsIdSet}
    end

    function new()
        table = Dict{Km, ActionsIdSet}()
        DBMemoryController(table)
    end

    function register!(controller :: DBMemoryController, action_id :: ActionId, km_last_use :: Km)
        if !haskey(controller.table, km_last_use)
            controller.table[km_last_use] = ActionsIdSet()
        end

        push!(controller.table[km_last_use], action_id)
    end

    function free_memory_actions_step!(controller :: DBMemoryController, km :: Km, db :: IDBActions)
        if haskey(controller.table, km)
            # HAL: $ O(N) $
            # TSP: Avg. $ O(N) $
            #! [for] $ O(N) $
            for action_id in controller.table[km]
                DatabaseInterface.remove!(db, action_id)
            end
            delete!(controller.table, km)
        end
    end


end
