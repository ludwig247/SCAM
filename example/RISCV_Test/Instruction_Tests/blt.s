#
# @author:Luka
# blt.s
#
# Test for branch less than (blt)

addi $1,$0,5		 # $1 = 5
addi $2,$0,-6		 # $2 = -6
#addi $31,$0,0        # $31 = 0
addi $30,$0,0        # $30 = 0
addi $29,$0,0        # $29 = 0

blt $1,$2,TRY1    # not taken
blt $2,$1,TRY2    # taken

TRY1:
addi $31,$0,15    # $31 = 0xF (not executed)
addi $0,$0,0     # halt

TRY2:
addi $30,$0,15    # $30 = 0xF  (executed)
blt  $1,$1,TRY3   # not taken
addi $0,$0,0     # halt

addi $0,$0,0	     # end of ID stage of the last instruction
addi $0,$0,0	     # end of EX stage of the last instruction
addi $0,$0,0	     # end of MEM stage of the last instruction
addi $0,$0,0	     # end of WB stage of the last instruction
addi $31,$0,0  	     # end of program

TRY3:
addi $29,$0,15    # $29 = 0xF (not executed)
addi $0,$0,0     # halt
