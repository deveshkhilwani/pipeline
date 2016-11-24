library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity MEM is 
port(
		Rs1: in std_logic_vector(15 downto 0);
		mem_address_sel: in std_logic;
		RA_plus_n: in std_logic_vector(15 downto 0); --for LM, SM
		alu_out: in std_logic_vector(15 downto 0);
		mem_write: in std_logic;
		mem_out: out std_logic;
		clk: in std_logic;
		reset: in std_logic
	);
end entity;

architecture arch of MEM is

	signal MEM_MUX_out: std_logic_vector(15 downto 0);
	
begin
	MEM_MUX: mux_2to1 port map (input0=>alu_out, input1=>RA_plus_n, output0=>MEM_MUX_out, select_signal=>mem_address_sel);
	data_mem: memory port map (address=>MEM_MUX_out, write_data=>Rs1, mem_write=>mem_write, mem_out=>mem_out, clk=>clk, reset=>reset);

end architecture ; -- arch