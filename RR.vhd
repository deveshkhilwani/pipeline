library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity RR is
  port (
	reg_file_A1: in std_logic_vector(2 downto 0) ;
	reg_file_A2: in std_logic_vector(2 downto 0) ;
	reg_file_A3: in std_logic_vector(2 downto 0) ;
	reg_file_D3: in std_logic_vector(15 downto 0) ;
	ex_data: in std_logic_vector(15 downto 0) ;
	mem_data: in std_logic_vector(15 downto 0) ;
	wb_data: in std_logic_vector(15 downto 0) ;
	incremented_PC: in std_logic_vector(15 downto 0) ;
	source1_mux_sel: in std_logic_vector(2 downto 0) ;
	source2_mux_sel: in std_logic_vector(2 downto 0) ;
	is_LMSM: in std_logic ;
  ) ;
end entity ; -- RR

architecture arch of RR is



begin



end architecture ; -- arch