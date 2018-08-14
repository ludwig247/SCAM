-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro m_out_notify :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig : int := end macro; 
macro m_out_sig : int := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- VISIBLE REGISTERS --


-- STATES -- 
macro run_0 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: b_in_notify = true;
	 at t: m_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume: 
	 at t: run_0;
	 at t: b_in_sync;
prove:
	 at t_end: run_0;
	 at t_end: m_out_sig = b_in_sig_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end-1]: m_out_notify = false;
	 at t_end: m_out_notify = true;
end property;

property wait_run_0 is
dependencies: no_reset;
assume: 
	 at t: run_0;
	 at t: not(b_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: b_in_notify = true;
	 at t+1: m_out_notify = false;
end property;