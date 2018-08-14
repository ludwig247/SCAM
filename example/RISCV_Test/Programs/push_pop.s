#
# @author:Don Dennis
# push_pop.s
#
# Testing functions PUSH, POP
# and HALT. There are used as
# pseudo instructions in other programs
#
# $31: Return Address
# $30: Stack Pointer
# $3: push register
# $4: pop register

_START:
	addi $3,$0,1345		#0x00	# value = 0x541
	addi $30,$0,64		#0x04	# stack pointer = 0x64
	jal  $31,PUSH		#0x08
	jal  $31,POP		#0x0C
HALT:
	addi $0,$0,0		#0x10	#end of ID stage
    	addi $0,$0,0		#0x14	#end of EX stage
   	addi $0,$0,0		#0x18	#end of MEM stage
   	addi $0,$0,0		#0x1C	#end of WB stage
   	addi $31,$0,0	 	#0x20	#end of program

# Increments stack pointer and pushes the value in $3 to stack

PUSH:
	addi $30,$30,4		#0x24
	sw   $30,$3, 0		#0x28
	jalr $0,$31,0		#0x2C

# Pops the value from stack to $4 and decrements stack pointer

POP:
	lw   $4,$30,0		#0x30
	addi $30,$30,-4		#0x34
	jalr $0,$31,0		#0x38
