library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity WB is 
port(
		--Rd: in std_logic_vector(2 downto 0);
		wb_address_sel: in std_logic_vector(1 downto 0);
		mem_out: in std_logic_vector(15 downto 0); --for LM, SM
		alu_out: in std_logic_vector(15 downto 0); --arithmetic instructions
		PC_plus_Imm_or_shifter: in std_logic_vector(15 downto 0);
		flag_out: in std_logic_vector(1 downto 0);
		RF_write: in std_logic;
		flag_write: in std_logic_vector(1 downto 0);
		--WB_Rd: out std_logic_vector(2 downto 0);
		WB_MUX_out: out std_logic_vector(15 downto 0);
		global_flag_out: out std_logic_vector(1 downto 0);
		clk: in std_logic;
		reset: in std_logic
	);
end entity;

architecture arch of WB is

	--signal WB_MUX_out: std_logic_vector(15 downto 0);
	constant C0: std_logic_vector(15 downto 0) := (others => '0');

	
begin
	--WB_Rd<=Rd;
	WB_MUX: mux_4to1 port map (input0=>alu_out, input1=>mem_out, input2=>PC_plus_Imm_or_shifter, input3=>C0, output0=>WB_MUX_out, select_signal=>wb_address_sel);
	--RF: reg_file port map (A3=>Rd,D3=>WB_MUX_out, RF_write=>RF_write, clk=>clk, reset=>reset);
	CY_Flag: DataRegister generic map (data_width=>1) port map(Din=>flag_out(1 downto 1), Dout=>global_flag_out(1 downto 1), Enable=>flag_write(1), clk=>clk);
	Z_Flag: DataRegister generic map (data_width=>1) port map(Din=>flag_out(0 downto 0), Dout=>global_flag_out(0 downto 0), Enable=>flag_write(0), clk=>clk);

end architecture ; -- arch