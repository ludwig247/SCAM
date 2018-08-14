#
# @author:Don Dennis
# multiplication.s
#
# Multiplication using repeated addition
# a*b is returned in r5

# r1:a, r2:b, r3: is_neg
# r5: ans
_START_:
    addi $1, $0, 11   	#0x00
    addi $2, $0, 12   	#0x04
    addi $3, $0, 0	#0x08
    addi $5, $0, 0	#0x0C
    blt  $0, $1, LOOP	#0x10
    addi $3, $0, 1	#0x14
    addi $4, $0, -1	#0x18
    xor  $1, $1, $4	#0x1C
    addi $1, $1, 1	#0x20
LOOP:
    beq  $0, $1, DONE	#0x24
    add  $5, $5, $2	#0x28
    addi $1, $1, -1	#0x2C
    jal  $0, LOOP	#0x30
DONE: 
    beq  $0, $3, HALT	#0x34
    addi $4, $0, -1	#0x38
    xor  $5, $5, $4	#0x3C
    addi $5, $5, 1	#0x40
HALT:	
    addi $0,$0,0	#0x44	#end of ID stage
    addi $0,$0,0	#0x48	#end of EX stage
    addi $0,$0,0	#0x4C	#end of MEM stage
    addi $0,$0,0	#0x50	#end of WB stage
    addi $31,$0,0 	#0x54	#end of program
