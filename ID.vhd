library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity ID is 
port(
		IW: in std_logic_vector(15 downto 0);
		PC: in std_logic_vector(15 downto 0);
		PE_Flag: out std_logic;
		PE_input_sel: in std_logic;
		PE_input: in std_logic_vector(7 downto 0);
		control_word: out std_logic_vector(14 downto 0);
		PE_out: out std_logic_vector(7 downto 0);
		Rs1: out std_logic_vector(2 downto 0);
		Rs2: out std_logic_vector(2 downto 0);
		Rd: out std_logic_vector(2 downto 0);
		SE6: out std_logic_vector(15 downto 0);
		ID_MUX: out std_logic_vector(15 downto 0);
		clk: in std_logic;
		reset: in std_logic
	);
end entity;

architecture arch of ID is

	signal control_out: std_logic_vector(19 downto 0);
	signal Rs1_sig, Rd_sig, Rsel_sig: std_logic_vector(2 downto 0);
	signal PE_input_sig: std_logic_vector(7 downto 0);
	signal SE6_sig, SE9_sig: std_logic_vector(15 downto 0);
	signal PC_plus_imm9, PC_plus_imm6, shifted: std_logic_vector(15 downto 0);
	constant C0: std_logic_vector(15 downto 0) := (others => '0');
	
begin
	SE6<=SE6_sig;
	control_word<=control_out(14 downto 0);
	dec: Decoder port map (instruction_word=>IW, control_word=>control_out, Rs1=>Rs1_sig, Rs2=>Rs2, Rd=>Rd_sig);
	--PE_input_MUX: mux_2to1 port map(input1=>IW(7 downto 0), input2=>PE_input, select_signal=>PE_input_sel, output0=>PE_input_sig);
	PE_LM_SM: special_pe port map(input0=>PE_input_sig, output0=>PE_out, Flag=>PE_Flag, Rsel=>Rsel_sig, clk=>clk);
	
--	Rs1_MUX: mux_2to1 port map(input0=>Rs1_sig, input1=>Rsel_sig, output0=>Rs1, select_signal=>control_out(19));
--	Rd_MUX: mux_2to1 port map(input0=>Rd_sig, input1=>Rsel_sig, output0=>Rd, select_signal=>control_out(18)); 
	SE_6: sign_ext6 port map (x=>IW(5 downto 0), y=>SE6_sig);
	SE_9: sign_ext9 port map (x=>IW(8 downto 0), y=>SE9_sig);
	JAL_adder: adder port map (x=>PC, y=>SE9_sig, z=>PC_plus_imm9);
	BEQ_adder: adder port map (x=>PC, y=>SE6_sig, z=>PC_plus_imm6);
	LHI_Shifter: shift7 port map(x=>IW(8 downto 0), y=>shifted);

	ID_mux1: mux_4to1 port map(input1=>PC_plus_imm6, input2=>PC_plus_imm9, input0=>shifted, input3=>C0, output0=>ID_MUX, select_signal=>control_out(17 downto 16));
	

end architecture ; -- arch