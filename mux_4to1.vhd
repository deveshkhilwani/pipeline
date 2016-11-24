library ieee;
use ieee.std_logic_1164.all;

entity mux_4to1 is
  port (
	input1: in std_logic_vector(15 downto 0) ;--when select signal is "01"
	input2: in std_logic_vector(15 downto 0) ;--when select signal is "10"
	input3: in std_logic_vector(15 downto 0) ;--when select signal is "11"
	input0: in std_logic_vector(15 downto 0) ;--when select signal is "00"
	output0: out std_logic_vector(15 downto 0) ;
	select_signal: in std_logic_vector(1 downto 0)
  ) ;
end entity ; -- mux_4to1

architecture arch of mux_4to1 is


begin
process(input0,input1,input2,input3,select_signal)
	begin
		for i in 15 downto 0 loop
			output0(i) <= (input0(i) and (not select_signal(1)) and (not select_signal(0))) or 
			(input1(i) and (not select_signal(1)) and select_signal(0)) or
			(input2(i) and select_signal(1) and (not select_signal(0))) or
			(input3(i) and select_signal(1) and select_signal(0));
		end loop;
end process;



end architecture ; -- arch