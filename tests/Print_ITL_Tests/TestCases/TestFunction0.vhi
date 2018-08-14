-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- 
macro b_in_notify :  boolean  := end macro; 
macro b_in_sync   :  boolean  := end macro; 
macro b_out_notify :  boolean  := end macro; 
macro b_out_sync   :  boolean  := end macro; 


-- DP SIGNALS -- 
macro b_in_sig : int := end macro; 
macro b_out_sig : unsigned := end macro; 


--CONSTRAINTS-- 
constraint no_reset := rst = '0'; end constraint; 


-- FUNCTIONS --
macro foo(x: int) : int := 
	if(((x + 1)(31 downto 0) > 5)) then (shift_left((x + resize(1,32))(31 downto 0),1))
	elsif(not(((x + 1)(31 downto 0) > 5)) and ((x + 1)(31 downto 0) > 20)) then ((x + 1)(31 downto 0) + 2)(31 downto 0)
	elsif(not(((x + 1)(31 downto 0) > 5)) and not(((x + 1)(31 downto 0) > 20)) and ((x + 1)(31 downto 0) = 20)) then (x + 1)(31 downto 0)
	elsif(not(((x + 1)(31 downto 0) > 5)) and not(((x + 1)(31 downto 0) > 20)) and not(((x + 1)(31 downto 0) = 20))) then 0
end if;
end macro; 



-- VISIBLE REGISTERS --
macro y : unsigned := end macro; 


-- STATES -- 
macro run_0 : boolean := true end macro;
macro run_1 : boolean := true end macro;


--Operations -- 
property reset is
assume:
	 reset_sequence;
prove:
	 at t: run_0;
	 at t: y = 0;
	 at t: b_in_notify = true;
	 at t: b_out_notify = false;
end property;


property run_0_read_0 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	b_in_sig_at_t = b_in_sig@t;
assume: 
	 at t: run_0;
	 at t: not((15 > unsigned(foo(b_in_sig))));
	 at t: not((unsigned(foo(b_in_sig)) > 0));
	 at t: not(((unsigned(b_in_sig) > unsigned(foo(b_in_sig))) or (unsigned(foo(b_in_sig)) > unsigned(b_in_sig))));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = unsigned(foo(b_in_sig_at_t));
	 at t_end: y = unsigned(foo(b_in_sig_at_t));
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_1 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: (15 > unsigned(foo(b_in_sig)));
	 at t: not((unsigned(foo(b_in_sig)) > 0));
	 at t: not(((unsigned(b_in_sig) > 0) or (0 > unsigned(b_in_sig))));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 0;
	 at t_end: y = 0;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_2 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: not((15 > unsigned(foo(b_in_sig))));
	 at t: (unsigned(foo(b_in_sig)) > 0);
	 at t: not(((unsigned(b_in_sig) > 1) or (1 > unsigned(b_in_sig))));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 1;
	 at t_end: y = 1;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_3 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: not((15 > unsigned(foo(b_in_sig))));
	 at t: not((unsigned(foo(b_in_sig)) > 0));
	 at t: ((unsigned(b_in_sig) > unsigned(foo(b_in_sig))) or (unsigned(foo(b_in_sig)) > unsigned(b_in_sig)));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 2;
	 at t_end: y = 2;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_4 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: (15 > unsigned(foo(b_in_sig)));
	 at t: (unsigned(foo(b_in_sig)) > 0);
	 at t: not(((unsigned(b_in_sig) > 1) or (1 > unsigned(b_in_sig))));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 1;
	 at t_end: y = 1;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_5 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: (15 > unsigned(foo(b_in_sig)));
	 at t: not((unsigned(foo(b_in_sig)) > 0));
	 at t: ((unsigned(b_in_sig) > 0) or (0 > unsigned(b_in_sig)));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 2;
	 at t_end: y = 2;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_6 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: not((15 > unsigned(foo(b_in_sig))));
	 at t: (unsigned(foo(b_in_sig)) > 0);
	 at t: ((unsigned(b_in_sig) > 1) or (1 > unsigned(b_in_sig)));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 2;
	 at t_end: y = 2;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_0_read_7 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
assume: 
	 at t: run_0;
	 at t: (15 > unsigned(foo(b_in_sig)));
	 at t: (unsigned(foo(b_in_sig)) > 0);
	 at t: ((unsigned(b_in_sig) > 1) or (1 > unsigned(b_in_sig)));
	 at t: b_in_sync;
prove:
	 at t_end: run_1;
	 at t_end: b_out_sig = 2;
	 at t_end: y = 2;
	 during[t+1, t_end]: b_in_notify = false;
	 during[t+1, t_end-1]: b_out_notify = false;
	 at t_end: b_out_notify = true;
end property;

property run_1_write_8 is
dependencies: no_reset;
for timepoints:
	 t_end = t+1;
freeze:
	y_at_t = y@t;
assume: 
	 at t: run_1;
	 at t: b_out_sync;
prove:
	 at t_end: run_0;
	 at t_end: y = y_at_t;
	 during[t+1, t_end-1]: b_in_notify = false;
	 at t_end: b_in_notify = true;
	 during[t+1, t_end]: b_out_notify = false;
end property;

property wait_run_0 is
dependencies: no_reset;
freeze:
	y_at_t = y@t;
assume: 
	 at t: run_0;
	 at t: not(b_in_sync);
prove:
	 at t+1: run_0;
	 at t+1: y = y_at_t;
	 at t+1: b_in_notify = true;
	 at t+1: b_out_notify = false;
end property;

property wait_run_1 is
dependencies: no_reset;
freeze:
	y_at_t = y@t;
assume: 
	 at t: run_1;
	 at t: not(b_out_sync);
prove:
	 at t+1: run_1;
	 at t+1: b_out_sig = y_at_t;
	 at t+1: y = y_at_t;
	 at t+1: b_in_notify = false;
	 at t+1: b_out_notify = true;
end property;