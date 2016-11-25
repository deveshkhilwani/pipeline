library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity generic_staller is
generic(data_width:integer);
  port (
	control_word: in std_logic_vector(data_width-1 downto 0) ;		
	pipelined_control_word : out std_logic_vector(data_width-1 downto 0); 
	NOP_mux_sel : in std_logic;
	flush: in std_logic
  ) ;
end entity ; 

architecture arch of generic_staller is
signal select_signal: std_logic;
constant control_word_for_stall: std_logic_vector(data_width-1 downto 0) := (others=>'0');

begin
select_signal<=(NOP_mux_sel and (not flush));

--12,11,7,5,4,3,2,1,0 have to be switched off 
--12,11,7,5,4,3 are RW,MW,FW,PE_input_sel
--2,1,0 are R7d and we don't want to forward from useless instructions 

--control_word_for_stall(17)<=control_word(17);
--control_word_for_stall(16)<=control_word(16);
--control_word_for_stall(15)<='0';

mux1 : generic_mux_2to1 generic map (data_width=>data_width) port map ( input0=>control_word_for_stall, input1=> control_word,
                           output0=>pipelined_control_word, select_signal=>select_signal) ; 


end architecture ; -- arch