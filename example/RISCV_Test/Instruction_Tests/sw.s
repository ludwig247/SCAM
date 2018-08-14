#
# @author:Luka
# sw.s
#
# Test for store word (sw)

addi $1,$0,128		 # address 0x80
addi $2,$0,156		 # address 0x9C

addi  $3,$0,352 	 # $3 = 0x160
addi  $4,$0,55 		 # $4 = 0x37
addi  $5,$0,1		 # $5 = 0x1
addi  $6,$0,-13		 # $6 = 0xFFFFFFF3

sw    $1,$3,0 		 # mem[0x80] = 0x60, mem[0x81] = 0x01, mem[0x82] = 0x0, mem[0x83] = 0x0
sw    $1,$6,-4       # mem[0x7C] = 0xF3, mem[0x7D] = 0xFF, mem[0x7E] = 0xFF, mem[0x7F] = 0xFF
sw    $1,$5,4        # mem[0x84] = 0x1, mem[0x85] = 0x0, mem[0x86] = 0x0, mem[0x87] = 0x0

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program
