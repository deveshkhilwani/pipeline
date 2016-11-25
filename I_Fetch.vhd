library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity I_Fetch is 
port(
		PC_MUX2_sel: in std_logic; --select signal for 2to1 MUX
		PC_MUX1_sel: in std_logic_vector(1 downto 0); --select signal of 4to1 MUX
		R7_ID: in std_logic_vector(15 downto 0);
		R7_RR: in std_logic_vector(15 downto 0);
		R7_EX: in std_logic_vector(15 downto 0);
		R7_MEM: in std_logic_vector(15 downto 0);
		PC_plus1: out std_logic_vector(15 downto 0);
		PC: out std_logic_vector(15 downto 0);
		IW: out std_logic_vector(15 downto 0);
		clk: in std_logic;
		reset: in std_logic
	);
end entity;

architecture arch of I_Fetch is

	signal PC_MUX1_out, PC_MUX2_out, PC_plus1_signal, R7_out: std_logic_vector(15 downto 0);
	signal R7_write: std_logic;
	constant C1: std_logic_vector(15 downto 0) := (0=>'1', others => '0');


begin
	PC_MUX1: mux_4to1 port map (input0=>R7_ID, input1=>R7_RR, input2=>R7_EX, input3=>R7_MEM, output0=>PC_MUX1_out, select_signal=>PC_MUX1_sel);
	PC_MUX2: mux_2to1 port map (input0=>PC_plus1_signal, input1=>PC_MUX1_out, output0=>PC_MUX2_out, select_signal=>PC_MUX2_sel);
	R7: DataRegister generic map(data_width=>16) port map(Din=>PC_MUX2_out , Dout=>R7_out, Enable=>R7_write , clk=>clk);
	IMem: i_Mem port map (address=>R7_out, instruction_out=>IW, clk=>clk, reset=>reset);
	PC<=R7_out;
	adder1: adder port map (x=>R7_out, y=>C1 ,z=>PC_plus1_signal);
	PC_plus1<=PC_plus1_signal;
end architecture ; -- arch