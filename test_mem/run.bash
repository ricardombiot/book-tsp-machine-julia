#!bin/bash
julia --project=./../ --threads 1 ./../test_mem/test_complete.jl $1 1 &
_pid=$!
sh ./py_study_mem/run_listen.sh $_pid
wait "$_pid"
sh ./py_study_mem/stop_listen.sh $_pid mem_report_$1
