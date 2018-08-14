#
# @author:Luka
# store.s
#
# Tests stores and loads in various situations

addi $1,$0,128		#0x00	 # address 0x80
addi $2,$0,156		#0x04	 # address 0x9C

lui   $20,5     	#0x08    # $20 = 5 << 12
auipc $21,0          	#0x0c	 # $21 = PC
auipc $22,100		#0x10	 # $22 = PC + (100 << 12)

addi  $5,$0,352 	#0x14	 # 0x160 imm
addi  $6,$0,55 		#0x18	 # 0x37 imm
addi  $7,$0,1		#0x1c	 # 0x1 imm
addi  $8,$0,3		#0x20	 # 0x3 imm

addi  $9,$0,-1		#0x24	 # 0xFFFFFFFF imm
addi  $10,$0,129	#0x28  	 # 0x81 imm
addi  $11,$0,-100	#0x2c 	 # 0xFFFFFF9C imm
	
sw    $1,$5,0  		#0x30 	 # mem[0x80] = 0x160
sh    $1,$6,4		#0x34 	 # mem[0x84] = 0x37
sb    $1,$7,6 		#0x38 	 # mem[0x86] = 0x1
sb    $1,$8,0 		#0x3c 	 # mem[0x80] = 0x3

sw    $2,$9,0		#0x40 	 # mem[0x9C] = 0xFFFFFFFF
sw    $2,$10,4		#0x44 	 # mem[0xA0] = 0x81
sh    $2,$11,8 		#0x48 	 # mem[0xA4] = 0xFF9C

lw    $31,$2,0     	#0x4c 	 # R31 = mem[0x9C] = 0xFFFFFFFF
lh    $30,$2,0     	#0x50 	 # R30 = mem[0x9C] = 0xFFFFFFFF
lhu   $29,$2,0     	#0x54 	 # R29 = mem[0x9C] = 0x0000FFFF
lb    $28,$2,0     	#0x58 	 # R28 = mem[0x9C] = 0xFFFFFFFF
lbu   $27,$2,0     	#0x5c 	 # R27 = mem[0x9C] = 0x000000FF

lb    $26,$2,4     	#0x60 	 # R26 = mem[0xA0] = 0xFFFFFF81
lbu   $25,$2,4     	#0x64	 # R25 = mem[0xA0] = 0x00000081

addi  $0,$0,0		#0x68	#end of ID stage of the last instruction
addi  $0,$0,0		#0x6c	#end of EX stage of the last instruction
addi  $0,$0,0		#0x70	#end of MEM stage of the last instruction
addi  $0,$0,0		#0x74	#end of WB stage of the last instruction
addi  $31,$0,0 		#0x78	#end of program
