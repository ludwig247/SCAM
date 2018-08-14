-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig_mode : Mode := end macro; 
macro b_in_sig_x : int := end macro; 
macro b_in_sig_y : bool := end macro; 
macro b_out_sig_mode : Mode := end macro; 
macro b_out_sig_x : int := end macro; 
macro b_out_sig_y : bool := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --


-- STATES -- 
macro SECTION_A_0 : boolean := true end macro;
macro SECTION_A_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: SECTION_A_0;
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property SECTION_A_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_mode_at_t = b_in_sig_mode@t,
	b_in_sig_x_at_t = b_in_sig_x@t,
	b_in_sig_y_at_t = b_in_sig_y@t;
assume: 
	 at t: SECTION_A_0;
	 at t: b_in_sync;
prove:
	 at t_end: SECTION_A_1;
	 at t_end: b_out_sig_mode = b_in_sig_mode_at_t;
	 at t_end: b_out_sig_x = b_in_sig_x_at_t;
	 at t_end: b_out_sig_y = b_in_sig_y_at_t;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property SECTION_A_1_write_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: SECTION_A_1;
	 at t: b_out_sync;
prove:
	 at t_end: SECTION_A_0;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property SECTION_A_1_write_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: SECTION_A_1;
	 at t: not(b_out_sync);
prove:
	 at t_end: SECTION_A_0;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property wait_SECTION_A_0 is
dependencies: no_reset;
assume: 
	 at t: SECTION_A_0;
	 at t: not(b_in_sync);
prove:
	 at t+1: SECTION_A_0;
	 at t+1: b_in_notify = true;
	 at t+1: b_out_notify = false;
end property;