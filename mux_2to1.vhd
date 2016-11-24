library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1 is
  port (
	input1: in std_logic_vector(15 downto 0) ;		--selct is '1'
	input0: in std_logic_vector(15 downto 0) ;		--selct is '0'
	output0: out std_logic_vector(15 downto 0) ;
	select_signal: in std_logic
  ) ;
end entity ; -- mux_4to1

architecture arch of mux_2to1 is


begin
process(input0,input1,select_signal)
	begin
		for i in 15 downto 0 loop
			output0(i) <= (input0(i) and (not select_signal)) or (input1(i) and select_signal);
		end loop;
end process;



end architecture ; -- arch