#
# @author:Don Dennis
# recursive_sum.s
#
# Finds sum of the first N 
# numbers recursively. Demonstrates
# how recursive functions can be added.
# 
# $31: Return Address
# $30: Stack Pointer
# $29: Return Value
# $1 : N

_START:
	addi $1,$0,9		#0x00		# N = 9
	addi $30,$0,256 	#0x04		# stack pointer = 0x100
	jal  $31,FAB		#0x08
HALT:
	addi $0,$0,0		#0x0C		# end of ID stage
    	addi $0,$0,0		#0x10		# end of EX stage
   	addi $0,$0,0		#0x14		# end of MEM stage
   	addi $0,$0,0		#0x18		# end of WB stage
   	addi $31,$0,0	 	#0x1C		# end of program

FAB:
	addi $3,$31,0		#0x20
	jal  $31,PUSH		#0x24
	addi $4,$0,2		#0x28
	blt  $1,$4,RET_ONE	#0x2C
	add  $3,$0,$1		#0x30
	jal  $31,PUSH		#0x34
	addi $1,$1,-1		#0x38
	jal  $31,FAB		#0x3C
	jal  $31,POP		#0x40
	add  $29,$29, $3	#0x44
	addi $3,$0,0		#0x48
	beq  $3,$0,RET		#0x4C
RET_ONE: 
	addi $29,$0,1		#0x50
RET:	
	jal  $31,POP		#0x54
	add  $31,$0, $3		#0x58
	jalr $0,$31, 0		#0x5C
PUSH:
	addi $30,$30,4		#0x60
	sw   $30,$3,0		#0x70
	jalr $0,$31,0		#0x74
POP:
	lw   $3,$30,0		#0x78
	addi $30,$30,-4		#0x7C
	jalr $0,$31,0		#0x80
