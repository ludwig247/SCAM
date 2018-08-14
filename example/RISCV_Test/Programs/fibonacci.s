#
# @author:Don Dennis
# fibonacci.s
#
# Find the Nth fibonacci number.
# $5 holds N and ans returned in #3

    	addi $5,$0,9		#0x00	# Replace with N
    	addi $1,$0,1 		#0x04	#a1
    	addi $2,$0,0 		#0x08	#a0
    	addi $3,$0,0 		#0x0c	#ans
    	addi $4,$0,1 		#0x10	#i
FOR:
    	add  $3, $1, $2		#0x14
	add  $2, $0, $1		#0x18
    	add  $1, $0, $3		#0x1c
    	addi $4, $4, 1		#0x20
    	blt  $4, $5, FOR	#0x24
HALT:    
    	addi $0,$0,0		#0x28	#end of ID stage of the last instruction
    	addi $0,$0,0		#0x2c	#end of EX stage of the last instruction
    	addi $0,$0,0		#0x30	#end of MEM stage of the last instruction
    	addi $0,$0,0		#0x34	#end of WB stage of the last instruction
    	addi $31,$0,0	 	#0x38	#end of program
