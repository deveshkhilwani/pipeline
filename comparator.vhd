library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity comparator3 is
port(
	x: in std_logic_vector(2 downto 0) ;
	y: in std_logic_vector(2 downto 0);
	equal_flag: out std_logic
	);
end entity;

architecture arch of comparator3 is

begin
equal_flag<= (x(0)xnor y(0)) and (x(1)xnor y(1)) and (x(2)xnor y(2))  
end architecture ; -- arch

entity comparator5 is
port(
	x: in std_logic_vector(4 downto 0) ;
	y: in std_logic_vector(4 downto 0);
	equal_flag: out std_logic
	);
end entity;

architecture arch of comparator5 is

begin
equal_flag<= (x(0)xnor y(0)) and (x(1)xnor y(1)) and (x(2)xnor y(2)) and (x(3)xnor y(3)) and (x(4)xnor y(4));
end architecture ; -- arch