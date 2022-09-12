#!bin/bash
echo "NOTE: Remeber run flask server... with:"
echo "    sh ./py_study_mem/start_server.sh"
echo "--------------------------------------"
for i in {4..18}
do
  bash ./run.bash $i
done
