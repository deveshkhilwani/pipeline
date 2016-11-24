library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity RR is
  port (
  	RF_write: in std_logic ;
	reg_file_A1: in std_logic_vector(2 downto 0) ;
	reg_file_A2: in std_logic_vector(2 downto 0) ;
	reg_file_A3: in std_logic_vector(2 downto 0) ;
	reg_file_D3: in std_logic_vector(15 downto 0) ;
	ex_data: in std_logic_vector(15 downto 0) ;
	mem_data: in std_logic_vector(15 downto 0) ;
	wb_data: in std_logic_vector(15 downto 0) ;
	incremented_PC: in std_logic_vector(15 downto 0) ;
	input1_mux_sel: in std_logic_vector(2 downto 0) ;
	input2_mux_sel: in std_logic_vector(2 downto 0) ;
	is_LMSM: in std_logic ;
	alu_a_input: out std_logic_vector(15 downto 0) ;
	alu_b_input: out std_logic_vector(15 downto 0) ;
	LMSM_memaddress_out: out std_logic_vector(15 downto 0) ;
	LMSM_memaddress_in: in std_logic_vector(15 downto 0) ;
	clk,reset: in std_logic
  ) ;
end entity ; -- RR

architecture arch of RR is

signal d1, d2, to_alu_b_input, temp_input1, temp_input2, adder_out:std_logic_vector( 15 downto 0);
signal registered_is_LMSM: std_logic;
constant c1: std_logic_vector(15 downto 0):=(0=>'1',others=>'0') ;

begin

RF : reg_file port map (RF_write=>RF_write, A1=>reg_file_A1, A2=>reg_file_A2, A3=>reg_file_A3,
						 D3=>reg_file_D3, D1=>d1, D2=>d2,clk=>clk,reset=>reset);
alu_a_mux1 : mux_4to1 port map (input0=> d1,				--when select is "00"
								input1=> wb_data,			--when select is "01"
								input2=> mem_data,			--when select is "10"
								input3=> ex_data,			--when select is "11"
								output0=> temp_input1,
								select_signal=> input1_mux_sel(1 downto 0)
								);
alu_a_mux2 : mux_2to1 port map (
								input0=> temp_input1,		--when select is'0'
								input1=> incremented_PC,	--when select is'1'
								output0=> alu_a_input,
								select_signal=> input1_mux_sel(2)
								);

alu_b_mux1 : mux_4to1 port map (input0=> d1,				--when select is "00"
								input1=> wb_data,			--when select is "01"
								input2=> mem_data,			--when select is "10"
								input3=> ex_data,			--when select is "11"
								output0=> temp_input2,
								select_signal=> input2_mux_sel(1 downto 0)
								);
alu_b_mux2 : mux_2to1 port map (
								input0=> temp_input2,		--when select is'0'
								input1=> incremented_PC,	--when select is'1'
								output0=> to_alu_b_input,
								select_signal=> input2_mux_sel(2)
								);

alu_b_input <= to_alu_b_input;

LMSM_mux: mux_2to1 port map(input0=>to_alu_b_input, input1=>adder_out, output0=>LMSM_memaddress_out, select_signal=>registered_is_LMSM);
bit_reg: DataRegister generic map(data_width=>1) port map(Din(0)=>is_LMSM , Dout(0)=>registered_is_LMSM , Enable=>'1' , clk=>clk);
incrementer: adder port map (x=>c1, y=>LMSM_memaddress_in, z=>adder_out);


end architecture ; -- arch