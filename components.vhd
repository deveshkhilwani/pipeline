library std;
library ieee;
use ieee.std_logic_1164.all;

package components is

    component priority_encoder_4to2 is
        port(
            x : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(1 downto 0)
            );
    end component;

    component comparator3 is
    	port(
			x: in std_logic_vector(2 downto 0) ;
			y: in std_logic_vector(2 downto 0);
			equal_flag: out std_logic
			);
    end component;

     component comparator5 is
    	port(
			x: in std_logic_vector(4 downto 0) ;
			y: in std_logic_vector(4 downto 0);
			equal_flag: out std_logic
			);
    end component;
end package;  -- components 
