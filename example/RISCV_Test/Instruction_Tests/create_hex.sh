#!/bin/bash
printf "========== create_hex.sh ========== \n\n"
for f in *.s ; 
do 	
    if [[ "$f" != "srai.s" ]]
    then
            python3 ../../RISCV_commons/RISCV-RV32I-Assembler/src/rvi.py "$f" --hex -o "${f%.s}.hex" ;
	    printf "${f%.s}.hex created. \n" 
    fi
done
printf "\n========== Finished create_hex.sh ========== \n\n"

