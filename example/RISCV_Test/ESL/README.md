# Directory: Test Framework

## Setup

1) Create a Core.h file, with a class Core containing your processor . 
2) Within Core.h specify these ports for accessing the memory:
    * blocking_out<CPtoME_IF> COtoME_port;
    * blocking_in<MEtoCP_IF> MEtoCO_port;
    * *Make sure you use the same names*
    * Name your registers file RF
3) Add your Core.h to the Core_Test.h and uncomment all other cores


## Running

1) Compile the riscv_regression_test and make sure the binary is in SCAM/bin
2) run the run_all_tests.sh


## Debugging
 
For now the log doesn't work? 










 

