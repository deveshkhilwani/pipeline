library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity HDU_Control is
port(
	ID_R7d: in std_logic_vector(2 downto 0);
	RR_R7d: in std_logic_vector(2 downto 0);
	EX_R7d: in std_logic_vector(2 downto 0);
	MEM_R7d: in std_logic_vector(2 downto 0);
	PC_MUX2_sel: out std_logic;
	PC_MUX1_sel: out std_logic_vector(1 downto 0);
	flush_assign: out std_logic_vector(3 downto 0)
);
end entity;

architecture arch of HDU_Control is

	signal fwd_from_ID, fwd_from_RR, fwd_from_EX, fwd_from_MEM, control_hazard: std_logic;
	signal R7_fwd: std_logic_vector(1 downto 0);
	signal flush_assign_signal: std_logic_vector(3 downto 0);

begin
--data hazard stalls
c1: comparator3 port map (x=>ID_R7d, y=>"001", equal_flag=>fwd_from_ID);
c2: comparator3 port map (x=>RR_R7d, y=>"010", equal_flag=>fwd_from_RR);
c3: comparator3 port map (x=>EX_R7d, y=>"011", equal_flag=>fwd_from_EX);
c4: comparator3 port map (x=>MEM_R7d, y=>"100", equal_flag=>fwd_from_MEM);


control_hazard<=fwd_from_MEM or fwd_from_EX or fwd_from_RR or fwd_from_ID; 

pe: priority_encoder_4to2 port map (x(3)=>fwd_from_MEM, x(2)=>fwd_from_EX, x(1)=>fwd_from_RR, x(0)=>fwd_from_ID, y=>R7_fwd(1 downto 0));

PC_MUX2_sel<=control_hazard;
PC_MUX1_sel<=R7_fwd;
flush_assign_signal<="1111" when (R7_fwd = "11") 
			else "1110" when (R7_fwd = "10")
			else "1100" when (R7_fwd = "01")
			else "1000" when (R7_fwd = "00");

flush_assign(0)<=control_hazard and flush_assign_signal(0);
flush_assign(1)<=control_hazard and flush_assign_signal(1);
flush_assign(2)<=control_hazard and flush_assign_signal(2);
flush_assign(3)<=control_hazard and flush_assign_signal(3);
--Conventions used:
--flush = 1 means "FLUSH"
--if R7_fwd = 11 then forward from MEM
--if R7_fwd = 10 then forward from EX
--if R7_fwd = 01 then forward from RR
--if R7_fwd = 00 then forward from ID

end arch ; -- arch