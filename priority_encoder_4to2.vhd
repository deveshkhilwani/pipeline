library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity priority_encoder_4to2 is
port(
	x: in std_logic_vector(3 downto 0) ;
	y: out std_logic_vector(1 downto 0)
	);
end entity;

architecture arch of priority_encoder_4to2 is

begin
y(1) <= x(3) or x(2);
y(0) <= x(3) or ((not x(2)) and x(1)); 

end architecture ; -- arch