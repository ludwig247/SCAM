-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro CtlToDec_port_sync   :  boolean  := end macro; 
--macro DecToCtl_port_sync   :  boolean  := end macro; 					-- Redundant?


-- DP SIGNALS -- 
macro CtlToDec_port_sig           : unsigned  := CtlToDec_port           end macro; 
macro DecToCtl_port_sig_encType   : EncType   := DecToCtl_port.encType   end macro; 
macro DecToCtl_port_sig_imm       : unsigned  := DecToCtl_port.imm       end macro; 
macro DecToCtl_port_sig_instrType : InstrType := DecToCtl_port.instrType end macro; 
macro DecToCtl_port_sig_rd_addr   : unsigned  := DecToCtl_port.rd_addr   end macro; 
macro DecToCtl_port_sig_rs1_addr  : unsigned  := DecToCtl_port.rs1_addr  end macro; 
macro DecToCtl_port_sig_rs2_addr  : unsigned  := DecToCtl_port.rs2_addr  end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro decoded_instr_encType   : EncType   := DecToCtl_port.encType   end macro; 
macro decoded_instr_imm       : unsigned  := DecToCtl_port.imm       end macro; 
macro decoded_instr_instrType : InstrType := DecToCtl_port.instrType end macro; 
macro decoded_instr_rd_addr   : unsigned  := DecToCtl_port.rd_addr   end macro; 
macro decoded_instr_rs1_addr  : unsigned  := DecToCtl_port.rs1_addr  end macro; 
macro decoded_instr_rs2_addr  : unsigned  := DecToCtl_port.rs2_addr  end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: decoded_instr_encType = B;
	 at t: decoded_instr_imm = 0;
	 at t: decoded_instr_instrType = And_Instr;
	 at t: decoded_instr_rd_addr = 0;
	 at t: decoded_instr_rs1_addr = 0;
	 at t: decoded_instr_rs2_addr = 0;
end property;


property run_0_read_0 is
dependencies: no_reset;
freeze:
	decoded_instr_encType_at_t = decoded_instr_encType@t,
	decoded_instr_imm_at_t = decoded_instr_imm@t,
	decoded_instr_instrType_at_t = decoded_instr_instrType@t,
	decoded_instr_rd_addr_at_t = decoded_instr_rd_addr@t,
	decoded_instr_rs1_addr_at_t = decoded_instr_rs1_addr@t,
	decoded_instr_rs2_addr_at_t = decoded_instr_rs2_addr@t;
assume: 
	 at t: run_0;
	 at t: not(CtlToDec_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = decoded_instr_encType_at_t;
	 at t+1: DecToCtl_port_sig_imm = decoded_instr_imm_at_t;
	 at t+1: DecToCtl_port_sig_instrType = decoded_instr_instrType_at_t;
	 at t+1: DecToCtl_port_sig_rd_addr = decoded_instr_rd_addr_at_t;
	 at t+1: DecToCtl_port_sig_rs1_addr = decoded_instr_rs1_addr_at_t;
	 at t+1: DecToCtl_port_sig_rs2_addr = decoded_instr_rs2_addr_at_t;
	 at t+1: decoded_instr_encType = decoded_instr_encType_at_t;
	 at t+1: decoded_instr_imm = decoded_instr_imm_at_t;
	 at t+1: decoded_instr_instrType = decoded_instr_instrType_at_t;
	 at t+1: decoded_instr_rd_addr = decoded_instr_rd_addr_at_t;
	 at t+1: decoded_instr_rs1_addr = decoded_instr_rs1_addr_at_t;
	 at t+1: decoded_instr_rs2_addr = decoded_instr_rs2_addr_at_t;
end property;

property run_0_read_1 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_2 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = sll_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = sll_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_3 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = addI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = addI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_4 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = addI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = addI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_5 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = add;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = add;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_6 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = sub;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = sub;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_7 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = slt;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = slt;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_8 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = andI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = andI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_9 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = andI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = andI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_10 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = sltu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = sltu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_11 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t,
	decoded_instr_imm_at_t = decoded_instr_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = Error_Type;
	 at t+1: DecToCtl_port_sig_imm = decoded_instr_imm_at_t;
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = Error_Type;
	 at t+1: decoded_instr_imm = decoded_instr_imm_at_t;
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_12 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = orI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = orI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_13 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = orI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = orI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_14 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = Xor_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = Xor_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_15 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = U;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(12,32))) and ((shift_left(resize(1,32),((31 - 12) + 1))) - 1)),12))) or (((shift_left(resize(1,32),12)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = lui;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = U;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(12,32))) and ((shift_left(resize(1,32),((31 - 12) + 1))) - 1)),12))) or (((shift_left(resize(1,32),12)) - 1) and 0));
	 at t+1: decoded_instr_instrType = lui;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_16 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = xorI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = xorI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_17 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = xorI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = xorI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_18 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = lb;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = lb;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_19 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = lb;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = lb;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_20 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = U;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(12,32))) and ((shift_left(resize(1,32),((31 - 12) + 1))) - 1)),12))) or (((shift_left(resize(1,32),12)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = auipc;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = U;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(12,32))) and ((shift_left(resize(1,32),((31 - 12) + 1))) - 1)),12))) or (((shift_left(resize(1,32),12)) - 1) and 0));
	 at t+1: decoded_instr_instrType = auipc;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_21 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = sltI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = sltI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_22 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = sltI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = sltI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_23 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_24 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = Or_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = Or_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_25 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = lh;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = lh;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_26 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = lh;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = lh;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_27 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = sltIu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = sltIu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_28 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = sltIu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = sltIu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_29 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = srl_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = srl_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_30 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = sra_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = sra_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_31 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = R;
	 at t+1: DecToCtl_port_sig_imm = 0;
	 at t+1: DecToCtl_port_sig_instrType = And_Instr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = R;
	 at t+1: decoded_instr_imm = 0;
	 at t+1: decoded_instr_instrType = And_Instr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_32 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = beq;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = beq;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_33 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = beq;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = beq;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_34 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = lw;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = lw;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_35 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = lw;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = lw;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_36 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = jalr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = jalr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_37 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bne;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bne;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_38 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bne;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bne;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_39 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = lbu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = lbu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_40 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_41 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = lbu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = lbu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_42 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_43 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = jalr;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = jalr;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_44 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = blt;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = blt;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_45 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = blt;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = blt;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_46 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = lhu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = lhu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_47 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = lhu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = lhu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_48 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111);
	 at t: not((((shift_right(CtlToDec_port_sig,31)) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)) = 1));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = J;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),9)) - 1),12)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),8)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),8))) or (((shift_left(resize(1,32),8)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,12)) and ((shift_left(resize(1,32),((19 - 12) + 1))) - 1)))),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),11)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),10)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(20,32))) and ((shift_left(resize(1,32),((20 - 20) + 1))) - 1)),10))) or (((shift_left(resize(1,32),10)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,21)) and ((shift_left(resize(1,32),((30 - 21) + 1))) - 1)))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0))));
	 at t+1: DecToCtl_port_sig_instrType = jal;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = J;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),9)) - 1),12)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),8)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),8))) or (((shift_left(resize(1,32),8)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,12)) and ((shift_left(resize(1,32),((19 - 12) + 1))) - 1)))),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),11)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),10)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(20,32))) and ((shift_left(resize(1,32),((20 - 20) + 1))) - 1)),10))) or (((shift_left(resize(1,32),10)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,21)) and ((shift_left(resize(1,32),((30 - 21) + 1))) - 1)))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0))));
	 at t+1: decoded_instr_instrType = jal;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_49 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = sb;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = sb;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_50 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = sllI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = sllI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_51 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = sllI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = sllI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_52 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bge;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bge;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_53 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bge;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bge;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_54 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111);
	 at t: (((shift_right(CtlToDec_port_sig,31)) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = J;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),11)) - 1),21)) and (shift_left(((shift_left(resize(1,32),11)) - 1),21))) or (((shift_left(resize(1,32),21)) - 1) and (((shift_left(((shift_left(resize(1,32),9)) - 1),12)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),8)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),8))) or (((shift_left(resize(1,32),8)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,12)) and ((shift_left(resize(1,32),((19 - 12) + 1))) - 1)))),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),11)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),10)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(20,32))) and ((shift_left(resize(1,32),((20 - 20) + 1))) - 1)),10))) or (((shift_left(resize(1,32),10)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,21)) and ((shift_left(resize(1,32),((30 - 21) + 1))) - 1)))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0))))));
	 at t+1: DecToCtl_port_sig_instrType = jal;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = J;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),11)) - 1),21)) and (shift_left(((shift_left(resize(1,32),11)) - 1),21))) or (((shift_left(resize(1,32),21)) - 1) and (((shift_left(((shift_left(resize(1,32),9)) - 1),12)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),8)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),8))) or (((shift_left(resize(1,32),8)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,12)) and ((shift_left(resize(1,32),((19 - 12) + 1))) - 1)))),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),11)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),10)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(20,32))) and ((shift_left(resize(1,32),((20 - 20) + 1))) - 1)),10))) or (((shift_left(resize(1,32),10)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,21)) and ((shift_left(resize(1,32),((30 - 21) + 1))) - 1)))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0))))));
	 at t+1: decoded_instr_instrType = jal;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_55 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: DecToCtl_port_sig_instrType = sb;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: decoded_instr_instrType = sb;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_56 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = sh;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = sh;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_57 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_58 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: (((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_59 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_60 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bltu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bltu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_61 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_62 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bltu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bltu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_63 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_64 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: DecToCtl_port_sig_instrType = sh;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: decoded_instr_instrType = sh;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_65 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: DecToCtl_port_sig_instrType = Unknown;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: decoded_instr_instrType = Unknown;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_66 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: DecToCtl_port_sig_instrType = sw;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))));
	 at t+1: decoded_instr_instrType = sw;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_67 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = srlI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = srlI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_68 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bgeu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),19)) - 1),12)) and (shift_left(((shift_left(resize(1,32),19)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bgeu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_69 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99);
	 at t: not((((shift_right((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = B;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: DecToCtl_port_sig_instrType = bgeu;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = B;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),31)) - 1),1)) and (shift_left((((shift_left(((shift_left(resize(1,32),2)) - 1),10)) and (shift_left((((shift_left(((shift_left(resize(1,32),1)) - 1),1)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(31,32))) and ((shift_left(resize(1,32),((31 - 31) + 1))) - 1)),1))) or (((shift_left(resize(1,32),1)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((7 - 7) + 1))) - 1)))),10))) or (((shift_left(resize(1,32),10)) - 1) and (((shift_left(((shift_left(resize(1,32),6)) - 1),4)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((30 - 25) + 1))) - 1)),4))) or (((shift_left(resize(1,32),4)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,8)) and ((shift_left(resize(1,32),((11 - 8) + 1))) - 1)))))),1))) or (((shift_left(resize(1,32),1)) - 1) and 0));
	 at t+1: decoded_instr_instrType = bgeu;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_70 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 51));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 99));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 55));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 23));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 111));
	 at t: not((((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 103));
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 35);
	 at t: (((shift_right((((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1)))),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1);
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = S;
	 at t+1: DecToCtl_port_sig_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: DecToCtl_port_sig_instrType = sw;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = S;
	 at t+1: decoded_instr_imm = (((shift_left(((shift_left(resize(1,32),20)) - 1),12)) and (shift_left(((shift_left(resize(1,32),20)) - 1),12))) or (((shift_left(resize(1,32),12)) - 1) and (((shift_left(((shift_left(resize(1,32),7)) - 1),5)) and (shift_left(((shift_right(CtlToDec_port_sig_at_t,resize(25,32))) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)),5))) or (((shift_left(resize(1,32),5)) - 1) and ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1))))));
	 at t+1: decoded_instr_instrType = sw;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;

property run_0_read_71 is
dependencies: no_reset;
freeze:
	CtlToDec_port_sig_at_t = CtlToDec_port_sig@t;
assume: 
	 at t: run_0;
	 at t: CtlToDec_port_sync;
	 at t: (((shift_right(CtlToDec_port_sig,0)) and ((shift_left(resize(1,32),((6 - 0) + 1))) - 1)) = 19);
	 at t: not((((shift_right(((shift_right(CtlToDec_port_sig,20)) and ((shift_left(resize(1,32),((31 - 20) + 1))) - 1)),11)) and ((shift_left(resize(1,32),((11 - 11) + 1))) - 1)) = 1));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 0));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 7));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 6));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 4));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 2));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 3));
	 at t: not((((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 1));
	 at t: (((shift_right(CtlToDec_port_sig,12)) and ((shift_left(resize(1,32),((14 - 12) + 1))) - 1)) = 5);
	 at t: not((((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 0));
	 at t: (((shift_right(CtlToDec_port_sig,25)) and ((shift_left(resize(1,32),((31 - 25) + 1))) - 1)) = 32);
	 at t: CtlToDec_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: DecToCtl_port_sig_encType = I;
	 at t+1: DecToCtl_port_sig_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_instrType = sraI;
	 at t+1: DecToCtl_port_sig_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: DecToCtl_port_sig_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_encType = I;
	 at t+1: decoded_instr_imm = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
	 at t+1: decoded_instr_instrType = sraI;
	 at t+1: decoded_instr_rd_addr = ((shift_right(CtlToDec_port_sig_at_t,7)) and ((shift_left(resize(1,32),((11 - 7) + 1))) - 1));
	 at t+1: decoded_instr_rs1_addr = ((shift_right(CtlToDec_port_sig_at_t,15)) and ((shift_left(resize(1,32),((19 - 15) + 1))) - 1));
	 at t+1: decoded_instr_rs2_addr = ((shift_right(CtlToDec_port_sig_at_t,20)) and ((shift_left(resize(1,32),((24 - 20) + 1))) - 1));
end property;
