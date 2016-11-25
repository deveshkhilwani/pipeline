library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity staller is
  port (
	control_word: in std_logic_vector(19 downto 0) ;		
	control_word_for_stall: out std_logic_vector(19 downto 0) 	
  ) ;
end entity ; 

architecture arch of staller is

begin

--12,11,7,5,4,3,2,1,0 have to be switched off 
--12,11,7,5,4,3 are RW,MW,FW,PE_input_sel
--2,1,0 are R7d and we don't want to forward from useless instructions 

control_word_for_stall(17)<=control_word(17);
control_word_for_stall(16)<=control_word(16);
control_word_for_stall(15)<='0';
control_word_for_stall(14)<='0';
control_word_for_stall(13)<=control_word(13);
control_word_for_stall(12)<=control_word(12);
control_word_for_stall(11)<=control_word(8);
control_word_for_stall(10)<=control_word(7);
control_word_for_stall(9)<=control_word(6);
control_word_for_stall(8)<=control_word(5);
control_word_for_stall(7)<='0';
control_word_for_stall(6)<=control_word(3);
control_word_for_stall(5)<='0';
control_word_for_stall(4)<='0';
control_word_for_stall(3)<='0';
control_word_for_stall(2)<='0';
control_word_for_stall(1)<='0';
control_word_for_stall(0)<='0';

end architecture ; -- arch