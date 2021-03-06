-- PLEASE NOTE THE FOLLOWING CHANGES:
-- Replaced "!=" with "not" (Only appeared for ALU_X)
--
-- For SRA Instructions, the brackets have been generated wrong! 
-- The Property put the "shift_right" before the "and", which resulted in a false result.
-- Two pairs of brackets have been removed in every shift-line of a SRA property.
-- SRA: 121, 145, 147, 167, 169, 172, 174, 190, 192, 195, 203, 205
--
-- For ADD and SUB Operations, we decided to ignore overflow failures by adding "(31 downto 0)" to the corresponding lines.
-- The following properties have been adjusted:
-- ADD: 4, 11, 12, 19, 22, 13, 35, 38, 51
-- SUB: 10, 18, 21, 31, 37, 39, 47, 50, 54, 70





-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
--macro CtlToALU_port_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro ALUtoCtl_port_sig_ALU_result    : unsigned     := ALUtoCtl_port.ALU_result    end macro; 
macro CtlToALU_port_sig_alu_fun       : ALU_function := CtlToALU_port.alu_fun       end macro; 
macro CtlToALU_port_sig_imm           : unsigned     := CtlToALU_port.imm           end macro; 
macro CtlToALU_port_sig_op1_sel       : ALUopType    := CtlToALU_port.op1_sel       end macro; 
macro CtlToALU_port_sig_op2_sel       : ALUopType    := CtlToALU_port.op2_sel       end macro; 
macro CtlToALU_port_sig_pc_reg        : unsigned     := CtlToALU_port.pc_reg        end macro; 
macro CtlToALU_port_sig_reg1_contents : unsigned     := CtlToALU_port.reg1_contents end macro; 
macro CtlToALU_port_sig_reg2_contents : unsigned     := CtlToALU_port.reg2_contents end macro;   


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --
macro ALUtoCtl_data_ALU_result : unsigned := ALUtoCtl_port.ALU_result end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: ALUtoCtl_data_ALU_result = 0;
end property;


property run_0_read_0 is
dependencies: no_reset;
freeze:
	ALUtoCtl_data_ALU_result_at_t = ALUtoCtl_data_ALU_result@t;
assume: 
	 at t: run_0;
	 at t: not(CtlToALU_port_sync);
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = ALUtoCtl_data_ALU_result_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = ALUtoCtl_data_ALU_result_at_t;
end property;

property run_0_read_1 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_2 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_3 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_4 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
end property;

property run_0_read_5 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_6 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_7 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_8 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_9 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_10 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
end property;

property run_0_read_11 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_imm_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_imm_at_t)(31 downto 0);
end property;

property run_0_read_12 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
end property;

property run_0_read_13 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_14 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_15 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_16 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_17 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
end property;

property run_0_read_18 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_imm_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_imm_at_t))(31 downto 0);
end property;

property run_0_read_19 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
end property;

property run_0_read_20 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_21 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
end property;

property run_0_read_22 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (2 * CtlToALU_port_sig_imm_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (2 * CtlToALU_port_sig_imm_at_t)(31 downto 0);
end property;

property run_0_read_23 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
end property;

property run_0_read_24 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_25 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_26 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
end property;

property run_0_read_27 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_28 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_29 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_30 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_imm_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_imm_at_t)));
end property;

property run_0_read_31 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_pc_reg_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t + (4294967295 * CtlToALU_port_sig_pc_reg_at_t))(31 downto 0);
end property;

property run_0_read_32 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_33 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_imm_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_imm_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
end property;

property run_0_read_34 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (0 * CtlToALU_port_sig_imm_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (0 * CtlToALU_port_sig_imm_at_t);
end property;

property run_0_read_35 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t + CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t + CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
end property;

property run_0_read_36 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_37 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + (4294967295 * CtlToALU_port_sig_reg2_contents_at_t))(31 downto 0);
end property;

property run_0_read_38 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + CtlToALU_port_sig_imm_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + CtlToALU_port_sig_imm_at_t)(31 downto 0);
end property;

property run_0_read_39 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (4294967295 * CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (4294967295 * CtlToALU_port_sig_reg2_contents_at_t)(31 downto 0);
end property;

property run_0_read_40 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_41 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_42 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_imm_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_imm_at_t);
end property;

property run_0_read_43 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_pc_reg_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_reg1_contents_at_t) or not(CtlToALU_port_sig_pc_reg_at_t)));
end property;

property run_0_read_44 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_45 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t or CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t or CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_46 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_47 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t + (4294967295 * CtlToALU_port_sig_pc_reg_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t + (4294967295 * CtlToALU_port_sig_pc_reg_at_t))(31 downto 0);
end property;

property run_0_read_48 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_49 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_pc_reg_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_pc_reg_at_t) or not(CtlToALU_port_sig_reg2_contents_at_t)));
end property;

property run_0_read_50 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + (4294967295 * CtlToALU_port_sig_imm_at_t))(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t + (4294967295 * CtlToALU_port_sig_imm_at_t))(31 downto 0);
end property;

property run_0_read_51 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (2 * CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (2 * CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
end property;

property run_0_read_52 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_53 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_54 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (4294967295 * CtlToALU_port_sig_imm_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (4294967295 * CtlToALU_port_sig_imm_at_t)(31 downto 0);
end property;

property run_0_read_55 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_56 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_ADD);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_57 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_imm_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_imm_at_t);
end property;

property run_0_read_58 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_pc_reg_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t or CtlToALU_port_sig_pc_reg_at_t);
end property;

property run_0_read_59 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_60 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_61 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_62 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_imm_at_t) or not(CtlToALU_port_sig_pc_reg_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_imm_at_t) or not(CtlToALU_port_sig_pc_reg_at_t)));
end property;

property run_0_read_63 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_64 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t or CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t or CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_65 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = not((not(CtlToALU_port_sig_pc_reg_at_t) or not(CtlToALU_port_sig_imm_at_t)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = not((not(CtlToALU_port_sig_pc_reg_at_t) or not(CtlToALU_port_sig_imm_at_t)));
end property;

property run_0_read_66 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (0 * CtlToALU_port_sig_pc_reg_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (0 * CtlToALU_port_sig_pc_reg_at_t);
end property;

property run_0_read_67 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_68 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
end property;

property run_0_read_69 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_70 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (4294967295 * CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (4294967295 * CtlToALU_port_sig_pc_reg_at_t)(31 downto 0);
end property;

property run_0_read_71 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SUB);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_72 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_reg2_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_73 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_reg2_contents)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_74 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_pc_reg_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_reg1_contents_at_t xor CtlToALU_port_sig_pc_reg_at_t);
end property;

property run_0_read_75 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_76 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_77 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t or CtlToALU_port_sig_pc_reg_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t or CtlToALU_port_sig_pc_reg_at_t);
end property;

property run_0_read_78 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_79 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t xor CtlToALU_port_sig_reg2_contents_at_t);
end property;

property run_0_read_80 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t or CtlToALU_port_sig_imm_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t or CtlToALU_port_sig_imm_at_t);
end property;

property run_0_read_81 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_82 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_83 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg2_contents_at_t;
end property;

property run_0_read_84 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_85 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_86 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_AND);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_87 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_reg1_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_88 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_reg1_contents);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_89 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_90 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_imm));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_91 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_imm)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_92 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_imm) < signed(CtlToALU_port_sig_reg2_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_93 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_imm) < signed(CtlToALU_port_sig_reg2_contents)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_94 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_imm_at_t xor CtlToALU_port_sig_pc_reg_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_imm_at_t xor CtlToALU_port_sig_pc_reg_at_t);
end property;

property run_0_read_95 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_96 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (CtlToALU_port_sig_pc_reg_at_t xor CtlToALU_port_sig_imm_at_t);
	 at t+1: ALUtoCtl_port_sig_ALU_result = (CtlToALU_port_sig_pc_reg_at_t xor CtlToALU_port_sig_imm_at_t);
end property;

property run_0_read_97 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_98 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_99 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_100 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_101 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_OR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_102 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_imm <= CtlToALU_port_sig_reg1_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_103 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_imm <= CtlToALU_port_sig_reg1_contents);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_104 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_105 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_pc_reg));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_106 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_reg1_contents) < signed(CtlToALU_port_sig_pc_reg)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_107 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_reg1_contents) < signed(0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_108 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_reg1_contents) < signed(0)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_109 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_imm));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_110 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_imm);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_111 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_112 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_imm) < signed(CtlToALU_port_sig_imm)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_113 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_pc_reg) < signed(CtlToALU_port_sig_reg2_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_114 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_pc_reg) < signed(CtlToALU_port_sig_reg2_contents)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_115 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_116 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_117 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(0) < signed(CtlToALU_port_sig_reg2_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_118 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(0) < signed(CtlToALU_port_sig_reg2_contents)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_119 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_120 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_XOR);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_121 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
end property;

property run_0_read_122 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_123 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_pc_reg <= CtlToALU_port_sig_reg1_contents));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_124 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_pc_reg <= CtlToALU_port_sig_reg1_contents);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_125 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_126 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_127 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_128 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_129 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_130 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_imm) < signed(CtlToALU_port_sig_pc_reg));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_131 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_imm) < signed(CtlToALU_port_sig_pc_reg)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_132 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_imm) < signed(0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_133 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_imm) < signed(0)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_134 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_pc_reg));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_135 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_reg2_contents <= CtlToALU_port_sig_pc_reg);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_136 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_137 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_pc_reg) < signed(CtlToALU_port_sig_imm));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_138 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_pc_reg) < signed(CtlToALU_port_sig_imm)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_139 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_reg2_contents = 0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_140 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_reg2_contents = 0);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_141 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_142 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(0) < signed(CtlToALU_port_sig_imm));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_143 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(0) < signed(CtlToALU_port_sig_imm)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_144 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_145 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
end property;

property run_0_read_146 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_147 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
end property;

property run_0_read_148 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_149 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_pc_reg <= CtlToALU_port_sig_imm));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_150 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_pc_reg <= CtlToALU_port_sig_imm);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_151 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_152 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_153 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_154 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_imm <= CtlToALU_port_sig_pc_reg));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_155 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_imm <= CtlToALU_port_sig_pc_reg);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_156 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_157 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_pc_reg) < signed(CtlToALU_port_sig_pc_reg)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_158 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(CtlToALU_port_sig_pc_reg) < signed(0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_159 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(CtlToALU_port_sig_pc_reg) < signed(0)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_160 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_imm = 0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_161 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_imm = 0);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_162 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_163 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: (signed(0) < signed(CtlToALU_port_sig_pc_reg));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_164 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(0) < signed(CtlToALU_port_sig_pc_reg)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_165 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: not(CtlToALU_port_sig_alu_fun = ALU_X);
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_ADD));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_SUB));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_AND));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_OR));
	 at t: not((CtlToALU_port_sig_alu_fun = ALU_XOR));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLT);
	 at t: not((signed(0) < signed(0)));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_166 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_167 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
end property;

property run_0_read_168 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_reg1_contents_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_169 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(0) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_reg1_contents_at_t),signed(0) and 31));
end property;

property run_0_read_170 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_171 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_172 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
end property;

property run_0_read_173 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_174 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_reg2_contents_at_t) and 31));
end property;

property run_0_read_175 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t,
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_176 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_177 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_178 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_179 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_180 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_reg2_contents_at_t))) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_reg2_contents_at_t))) and 31));
end property;

property run_0_read_181 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg2_contents_at_t = CtlToALU_port_sig_reg2_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(0,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(0,(CtlToALU_port_sig_reg2_contents_at_t and 31)));
end property;

property run_0_read_182 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: not((CtlToALU_port_sig_pc_reg = 0));
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 1;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 1;
end property;

property run_0_read_183 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: (CtlToALU_port_sig_pc_reg = 0);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_184 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_left(resize(0,32),(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_185 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLTU);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_186 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SLL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_187 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_188 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_reg1_contents_at_t = CtlToALU_port_sig_reg1_contents@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_REG);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_reg1_contents_at_t;
end property;

property run_0_read_189 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_190 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
end property;

property run_0_read_191 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_imm_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_192 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(0) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_imm_at_t),signed(0) and 31));
end property;

property run_0_read_193 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_194 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_195 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_imm_at_t) and 31));
end property;

property run_0_read_196 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t,
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_197 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_REG);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_198 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_imm_at_t))) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_imm_at_t))) and 31));
end property;

property run_0_read_199 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(0,(CtlToALU_port_sig_imm_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(0,(CtlToALU_port_sig_imm_at_t and 31)));
end property;

property run_0_read_200 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_201 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_imm_at_t = CtlToALU_port_sig_imm@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_IMM);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_imm_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_imm_at_t;
end property;

property run_0_read_202 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_203 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(CtlToALU_port_sig_pc_reg_at_t) and 31));
end property;

property run_0_read_204 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(CtlToALU_port_sig_pc_reg_at_t,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_205 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(0) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(shift_right(signed(CtlToALU_port_sig_pc_reg_at_t),signed(0) and 31));
end property;

property run_0_read_206 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_207 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_IMM);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_208 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_pc_reg_at_t))) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(((shift_right(signed(0),signed(CtlToALU_port_sig_pc_reg_at_t))) and 31));
end property;

property run_0_read_209 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = (shift_right(0,(CtlToALU_port_sig_pc_reg_at_t and 31)));
	 at t+1: ALUtoCtl_port_sig_ALU_result = (shift_right(0,(CtlToALU_port_sig_pc_reg_at_t and 31)));
end property;

property run_0_read_210 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRA);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = unsigned(((shift_right(signed(0),signed(0))) and 31));
	 at t+1: ALUtoCtl_port_sig_ALU_result = unsigned(((shift_right(signed(0),signed(0))) and 31));
end property;

property run_0_read_211 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_SRL);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_212 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_213 is
dependencies: no_reset;
freeze:
	CtlToALU_port_sig_pc_reg_at_t = CtlToALU_port_sig_pc_reg@t;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: (CtlToALU_port_sig_op1_sel = OP_PC);
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
	 at t+1: ALUtoCtl_port_sig_ALU_result = CtlToALU_port_sig_pc_reg_at_t;
end property;

property run_0_read_214 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: (CtlToALU_port_sig_op2_sel = OP_PC);
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;

property run_0_read_215 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: CtlToALU_port_sync;
	 at t: not((CtlToALU_port_sig_op1_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op1_sel = OP_PC));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_REG));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_IMM));
	 at t: not((CtlToALU_port_sig_op2_sel = OP_PC));
	 at t: (CtlToALU_port_sig_alu_fun = ALU_COPY1);
	 at t: CtlToALU_port_sync;
prove:
	 at t+1: run_0;
	 at t+1: ALUtoCtl_data_ALU_result = 0;
	 at t+1: ALUtoCtl_port_sig_ALU_result = 0;
end property;
