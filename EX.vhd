library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity EX is 
port(
		Rs1, Rs2: in std_logic_vector(15 downto 0);
		SE_6: in std_logic_vector(15 downto 0);
		alu_a_sel, alu_b_sel: in std_logic;
		alu_op: in std_logic_vector(1 downto 0);
		alu_out: out std_logic_vector(15 downto 0);
		c_out: out std_logic;
		z_out: out std_logic;
		clk: in std_logic;
		reset: in std_logic
	);
end entity;

architecture arch of EX is

	signal alu_MUX1_out, alu_MUX2_out: std_logic_vector(15 downto 0);
	signal R7_write: std_logic;
begin
	alu_MUX1: mux_2to1 port map (input0=>Rs1, input1=>SE_6, output0=>alu_MUX1_out, select_signal=>alu_a_sel);
	alu_MUX2: mux_2to1 port map (input0=>Rs2, input1=>SE_6, output0=>alu_MUX2_out, select_signal=>alu_b_sel);
	alu1: alu port map(x=>alu_MUX1_out, y=>alu_MUX2_out, op_code=>alu_op, z=>alu_out, carry=>c_out, zero=>z_out);

end architecture ; -- arch