#
# @author:Luka
# slti.s
#
# Test for set less than immediate (slti)
.globl _start

_start:
addi  x1,x0,7          # x1 = 7
addi  x2,x0,-12        # x2 = -12

sltiu x3,x1,32	       # x3 = 1
sltiu x4,x1,3	       # x4 = 0
sltiu x5,x1,-100       # x5 = 1
sltiu x6,x2,-5         # x6 = 1
sltiu x7,x2,0          # x7 = 0
sltiu x8,x2,100        # x8 = 0
sltiu x9,x2,-13        # x9 = 0
sltiu x10,x2,-100      # x10 = 0

nop		# end of ID stage of the last instruction
nop		# end of EX stage of the last instruction
nop		# end of MEM stage of the last instruction
nop		# end of WB stage of the last instruction

# call exit (SYS_EXIT=93) with exit code 0 (argument in a0)
li a7,93
li a0,0
ecall
