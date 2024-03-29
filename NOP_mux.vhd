library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity NOP_mux is
  port (
	control_word: in std_logic_vector(14 downto 0) ;  --select is '1', input1 
	control_word_for_stall: in std_logic_vector(14 downto 0); --select is '0', input0 
	pipelined_control_word : out std_logic_vector(14 downto 0); 
	NOP_mux_sel : in std_logic;
	flush: in std_logic
  ) ;
end entity ; 

--if NOP_MUX_sel = 0, RW,FW,MW = 000; 

architecture arch of NOP_mux is
signal select_signal: std_logic;
begin 
select_signal<=(NOP_mux_sel and (not flush));
mux1 : generic_mux_2to1 generic map (data_width=>15) port map ( input0=>control_word_for_stall(14 downto 0), input1=> control_word(14 downto 0),
                           output0=>pipelined_control_word, select_signal=>select_signal) ; 

end architecture ; -- arch