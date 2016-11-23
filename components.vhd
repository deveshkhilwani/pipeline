library std;
library ieee;
use ieee.std_logic_1164.all;

package components is

	component priority_encoder_4to2 is
	port(
		x: in std_logic_vector(3 downto 0) ;
		y: out std_logic_vector(1 downto 0)
		);
	end component;


end package ; -- components 