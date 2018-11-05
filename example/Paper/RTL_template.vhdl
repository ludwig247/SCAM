package SCAM_Model_types is
subtype bool is Boolean;
subtype int is Integer;
type Example_SECTIONS is (frame_data,frame_start,idle);
type status_t is (in_frame,oof_frame);
type msg_t is record
	data: int;
	status: status_t;
end record;
end package SCAM_Model_types;

library ieee ;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SCAM_Model_types.all;

entity Example is
port(
	clk:		in std_logic;
	rst:		in std_logic;
	b_in:		in msg_t;
	b_in_sync:	 in bool;
	b_in_notify:	 out bool;
	m_out:		out int;
	m_out_sync:	 in bool;
	m_out_notify:	 out bool;
	s_out:		out bool);
end Example;


architecture Example_arch of Example is
signal section: Example_SECTIONS;
			 signal cnt_signal:int;
			 signal msg_signal:msg_t;
			 signal ready_signal:bool;
begin
	 process(clk)
	 begin
	 if(clk='1' and clk'event) then
		 if rst = '1' then
			 section <=idle;
			cnt_signal<=0;
			msg_signal.data<=0;
			msg_signal.status<=in_frame;
			ready_signal<=false;
			b_in_notify <= true;
			m_out_notify <= false;
		 else
		 if section = frame_data then
		 -- FILL OUT HERE;
		 end if;
		 if section = frame_start then
		 -- FILL OUT HERE;
		 end if;
		 if section = idle then
		 -- FILL OUT HERE;
		 end if;
		 end if;
	 end if;
	 end process;