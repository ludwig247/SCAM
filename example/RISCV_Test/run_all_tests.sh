#!/bin/bash
export SYSTEMC_DISABLE_COPYRIGHT_MESSAGE=1
export SCAM_DIR=/import/home/ludwig/SCAM

printf "\n=============================== run_all_tests.sh ==================================================== \n\n"
printf "=============================== Running program tests =============================================== \n\n"
for f in ${SCAM_DIR}/example/RISCV_Test/Programs/*.hex  ;
do 	
   "${SCAM_DIR}/bin/RISCV_regression_test" "$f"
done
printf "\n=============================== Running tests for each instruction ================================= \n\n"
for f in ${SCAM_DIR}/example/RISCV_Test/Instruction_Tests/*.hex  ;
do 	
    "${SCAM_DIR}/bin/RISCV_regression_test" "$f"
done
printf "\n=============================== Finished run_all_tests.sh =========================================== \n\n"

