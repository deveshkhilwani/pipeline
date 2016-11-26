library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity MEM is 
port(
		Rs1: in std_logic_vector(15 downto 0);
		mem_address_sel: in std_logic;
		mem_in: in std_logic_vector(15 downto 0);
		mem_write: in std_logic;
		mem_out: out std_logic_vector(15 downto 0);
		z_flag_in,z_enable,is_load_type: in std_logic;
		updated_z_flag: out std_logic;
		clk: in std_logic
	);
end entity;

architecture arch of MEM is

	signal MEM_MUX_out,temp_mem_out: std_logic_vector(15 downto 0);
	signal old_z_flag,new_z_flag: std_logic_vector(0 downto 0) ;
	signal z_mux_sel: std_logic;
	
begin
	--MEM_MUX: mux_2to1 port map (input0=>alu_out, input1=>RA_plus_n, output0=>MEM_MUX_out, select_signal=>mem_address_sel);
	data_mem: bram port map (address=>mem_in, data_i=>Rs1, we=>mem_write, data_o=>temp_mem_out, clk=>clk);

	new_z_flag(0) <= not(temp_mem_out(0) or temp_mem_out(1) or temp_mem_out(2) or temp_mem_out(3) or temp_mem_out(4) or temp_mem_out(5)
					or temp_mem_out(6) or temp_mem_out(7) or temp_mem_out(8) or temp_mem_out(9) or temp_mem_out(10) or temp_mem_out(11)
					or temp_mem_out(12) or temp_mem_out(13) or temp_mem_out(14) or temp_mem_out(15));
	mem_out <= temp_mem_out;

	old_z_flag(0) <= z_flag_in;
	z_mux_sel <= z_enable and is_load_type;
	z_mux: generic_mux_2to1 generic map (1) 
							port map (input0=>old_z_flag, input1=>new_z_flag, output0(0)=>updated_z_flag, select_signal=>z_mux_sel);
	--updated_z_flag <= z_out;

end architecture ; -- arch